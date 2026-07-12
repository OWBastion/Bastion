# Architecture Rules (Canonical)

This document is the canonical rule source for entry architecture and structural consistency.

## Core Rules

1. Include order in entry files is behavior-critical; do not reorder casually.
2. Keep `src/main.opy` and `src/devMain.opy` structurally aligned unless a clear environment-only reason exists.
3. Event config updates must check both:
   - `src/config/eventConfig.opy`
   - `src/config/eventConfigDev.opy`
4. Seasonal/event-specific logic belongs to dedicated follow-up branches, not current mainline.
5. Prefer minimal-scope changes in owning module before cross-directory edits.
6. Do not use `shared` in project-owned names to describe common configuration or behavior; use responsibility-based names, `BASE` for base macros, and `MAIN` / `DEV` for entry-specific overrides.

## Validation Expectations

1. If only one entry file changed (`main` or `devMain`), explain why in change notes.
2. For event changes, verify config registration, effect implementation, and localization consistency.
3. For map changes, verify map aggregation and map detection integration paths when applicable.
