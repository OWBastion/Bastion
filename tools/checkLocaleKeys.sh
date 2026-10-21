#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZH_FILE="$ROOT_DIR/src/locales/zh-CN.opy"
EN_FILE="$ROOT_DIR/src/locales/en-US.opy"
CONFIG_FILES=(
  "$ROOT_DIR/src/events/catalog/eventCatalog.opy"
)

if ! command -v rg >/dev/null 2>&1; then
  echo "ERROR: ripgrep (rg) is required." >&2
  exit 2
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

extract_keys_with_lines() {
  local file="$1"
  rg -n -o '^#!define\s+STR_[A-Z0-9_]+' "$file" \
    | awk -F: '{print $1 ":" $2 ":" $NF}' \
    | awk '{print $1 ":" $2 ":" $3}' \
    | sed 's/^/line /'
}

extract_keys() {
  local file="$1"
  rg -N -o '^#!define\s+STR_[A-Z0-9_]+' "$file" \
    | awk '{print $2}' \
    | sort -u
}

extract_refs() {
  rg -N -o --no-filename 'STR_[A-Z0-9_]+' "${CONFIG_FILES[@]}" \
    | sort -u
}

extract_usage() {
  rg -N -o --no-filename 'STR_[A-Z0-9_]+' "$ROOT_DIR/src" -g '!src/locales/*' \
    | sort -u
}

find_duplicates() {
  local file="$1"
  rg -n -o '^#!define\s+STR_[A-Z0-9_]+' "$file" \
    | awk '{print $2}' \
    | sort \
    | uniq -d
}

extract_keys "$ZH_FILE" > "$TMP_DIR/zh_keys.txt"
extract_keys "$EN_FILE" > "$TMP_DIR/en_keys.txt"
extract_refs > "$TMP_DIR/config_refs.txt"
extract_usage > "$TMP_DIR/usage.txt"
cat "$TMP_DIR/zh_keys.txt" "$TMP_DIR/en_keys.txt" | sort -u > "$TMP_DIR/all_locale_keys.txt"

FAIL=0

echo "== Locale Key Consistency Check =="
echo

echo "[A] Missing in en-US (present in zh-CN):"
comm -23 "$TMP_DIR/zh_keys.txt" "$TMP_DIR/en_keys.txt" | tee "$TMP_DIR/missing_in_en.txt"
if [[ -s "$TMP_DIR/missing_in_en.txt" ]]; then
  FAIL=1
fi
echo

echo "[B] Missing in zh-CN (present in en-US):"
comm -13 "$TMP_DIR/zh_keys.txt" "$TMP_DIR/en_keys.txt" | tee "$TMP_DIR/missing_in_zh.txt"
if [[ -s "$TMP_DIR/missing_in_zh.txt" ]]; then
  FAIL=1
fi
echo

echo "[C] Duplicate keys in locale files:"
ZH_DUP="$(find_duplicates "$ZH_FILE" || true)"
EN_DUP="$(find_duplicates "$EN_FILE" || true)"
if [[ -n "$ZH_DUP" ]]; then
  echo "zh-CN duplicates:"
  echo "$ZH_DUP"
  FAIL=1
fi
if [[ -n "$EN_DUP" ]]; then
  echo "en-US duplicates:"
  echo "$EN_DUP"
  FAIL=1
fi
if [[ -z "$ZH_DUP" && -z "$EN_DUP" ]]; then
  echo "(none)"
fi
echo

echo "[D] Invalid STR_ references in config (not defined in any locale):"
comm -23 "$TMP_DIR/config_refs.txt" "$TMP_DIR/all_locale_keys.txt" | tee "$TMP_DIR/invalid_refs.txt"
if [[ -s "$TMP_DIR/invalid_refs.txt" ]]; then
  FAIL=1
fi
echo

echo "[E] Unused locale keys (warning only):"
comm -23 "$TMP_DIR/all_locale_keys.txt" "$TMP_DIR/usage.txt" | tee "$TMP_DIR/unused_keys.txt"
if [[ ! -s "$TMP_DIR/unused_keys.txt" ]]; then
  echo "(none)"
fi
echo

if [[ "$FAIL" -ne 0 ]]; then
  echo "FAILED: locale checks found blocking issues."
  exit 1
fi

echo "PASSED: locale checks found no blocking issues."
