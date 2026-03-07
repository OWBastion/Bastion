# AGENTS.md

This document defines the shared collaboration conventions (for both humans and AI agents) in this repository. The goals are to:
- Make low-risk changes to Overwatch Workshop gameplay logic
- Keep consistency between the `main/devMain` dual-entry architecture
- Iterate on features without introducing server load regressions

## 1. Project Overview

- Project type: Overwatch 2 Workshop mode (OverPy source code)
- Primary source files: `src/**/*.opy`
- Primary entry files:
  - `src/main.opy`: production main entry
  - `src/devMain.opy`: development/debug entry (with more dev-oriented settings)
- Build approach: use the OverPy toolchain (this repository does not enforce a single fixed build-script entry)
- References: `docs/*.md` (especially server stability and loop-related docs)

## 2. Directory Responsibilities

- `src/bastion/`: Bastion AI and behavior logic
- `src/events/`: random event assignment, triggering, and effects
- `src/config/`: event-pack and weight initialization (`eventConfig.opy` / `eventConfigDev.opy`)
- `src/map/`: map points and map flow logic
- `src/heroes/`: hero-related ability/restriction logic
- `src/utilities/`: shared utility functions (cooldowns, regen, status, debug, etc.)
- `src/player/`: player state, initialization, achievements
- `src/effects/`: visual and gameplay effects logic
- `src/env/`: environment and version macros (`env.opy`, `env_dev.opy`, `game.opy`)
- `src/locales/`: localization text
- `docs/`: performance, loops, element count, and related docs

## 3. Key Architecture Constraints

1. Include order in entry files is meaningful; do not reorder casually.
2. `main.opy` and `devMain.opy` should remain as structurally aligned as possible; if only one is changed, explain why in the PR/commit notes.
3. `src/config/eventConfig.opy` and `src/config/eventConfigDev.opy` are both core event-system configs; when adding or adjusting events, check behavior differences in both files.
4. Seasonal/event-specific configurations are not maintained on the current mainline and should be implemented in follow-up dedicated Git branches; mainline should keep only general gameplay logic.
5. After all code changes are complete, both tests and build validation must pass before the task is considered done.

## 4. Development Workflow (Recommended)

### 4.1 Feature Changes

1. Locate the owning module first (map/hero/event/utility).
2. Prefer minimal-scope changes; avoid cross-directory large refactors.
3. When adding rules, prefer reusing existing macros/constants/utilities instead of copy-pasting large blocks.
4. For gameplay tuning values, prefer constants/config sections over scattered magic numbers.

### 4.2 Adding Events

1. Register event definitions, weights, durations, and toggles in `config/eventConfig*.opy`.
2. Implement corresponding behavior in `events/effects/`.
3. Validate localization text (`locales/`) and display formatting.
4. Ensure existing sampling/allocation flow (`events/allocation/`) is not broken.

### 4.3 Map-Related Changes

1. Keep map points and flow logic in the corresponding file under `src/map/`.
2. Use `src/map/setup_all_map.opy` as the aggregation entry; update it when adding maps.
3. For teleport/checkpoint logic, verify integration with `mapDetection` and end-of-run settlement rules.

## 5. Build Conventions

- Canonical local build commands are:
  - `pnpm run build` (build both `main.opy` and `devMain.opy`)
  - `pnpm run build:main`
  - `pnpm run build:dev`
  - `pnpm run build:main:en`, `pnpm run build:dev:en` (single-locale en-US outputs)
  - `pnpm run build:main:zh`, `pnpm run build:dev:zh` (single-locale zh-CN outputs)
  - `pnpm run build:release` (dual-language release artifacts)
- CI build check workflow is `.github/workflows/ci-build.yml` and runs on pull requests (`pnpm run build`).
- CI auto release workflow is `.github/workflows/release.yml` and is triggered by pushed `v*` tags.
- When using the OverPy toolchain, prioritize independent compile/decompile verification for both `main.opy` and `devMain.opy`.
- `build/` is an artifact directory and should not contain business/source logic.

## 6. Performance and Stability Hard Rules

Based on `docs/improve-server-stability.md` and existing code practices, the following rules are mandatory by default:

1. Avoid loops without `wait` (rule loops / while loops).
2. For `Ongoing - Global` / `Ongoing - Each Player`, prefer condition-block gating by default (top-to-bottom short-circuit each tick, ~0.016s).
3. Order conditions with high-selectivity low-cost checks first; move expensive calculations later.
4. Only move checks into actions (`If` + `wait`) for explicit interval control or when multiple sub-checks share one upper gate.
5. Rules with the same gates execute by scan order; declaration order is behavior-critical.
6. Use complex array/distance calculations carefully in `Ongoing - Each Player` rules.
7. Split heavy action bursts across frames (insert short `wait` when needed).
8. Prefer merging/absorbing new rules where appropriate to reduce startup condition explosion.

## 7. Pre-Commit Checklist

For each change, verify at least:

1. Whether corresponding updates are needed in both `main.opy` and `devMain.opy`.
2. Whether every new loop has a reasonable `wait`.
3. Whether newly added conditions are ordered by high-selectivity low-cost-first.
4. Whether action-side checks are only used for interval-control / shared-gate exceptions, with explicit `wait`.
5. Whether rule declaration order changes could alter same-gate execution order.
6. Whether new events are synced across config, implementation, and copy/text.
7. Whether unrelated formatting/reordering was introduced (should be avoided).
8. If the change is seasonal/event-specific, whether it should go to a dedicated branch instead of current mainline.
9. Run `./tools/check_locale_keys.sh` and ensure locale key sync checks pass (missing/duplicate/invalid references), and event dynamic numbers come from constants via formatting.

## 8. AI Agent Collaboration Requirements

1. Read relevant modules before editing; do not blindly modify large entry files.
2. Follow a minimal-change principle by default: only touch files/sections directly related to the task.
3. Do not casually rename existing rule names, constant names, or macro names unless explicitly required.
4. Do not introduce or change build-entry conventions (scripts/commands/output paths) without explicit task requirements.
5. In change explanations, clearly state what changed, which entry points are impacted, and what linkage/verification is needed.
6. Never use `git commit --no-verify` (or any workflow that disables hooks) for repository changes; commits must pass configured hooks, including global `commit-msg`.
7. Never manually add `Co-authored-by: Codex <noreply@openai.com>` to commit messages. Keep commit trailers hook-compliant.

## 9. Recommended Reading Order (New Contributors)

1. `README.md`
2. `src/main.opy`
3. `src/devMain.opy`
4. `src/config/eventConfig.opy`
5. `src/events/` and `src/utilities/`
6. `docs/improve-server-stability.md`

## 10. Source Manual (New)

For detailed module-level documentation of `src/`, refer to:

- `docs/modules/README.md` (index)
- `docs/modules/01-entry-architecture.md`
- `docs/modules/02-env-constants-locales.md`
- `docs/modules/03-events-system.md`
- `docs/modules/04-bastion-ai.md`
- `docs/modules/05-map-system.md`
- `docs/modules/06-utilities.md`
- `docs/modules/07-heroes.md`
- `docs/modules/08-player-effects-title.md`
- `docs/modules/09-special-seasonal.md`
- `docs/modules/10-references-workshop-codes.md`
- `docs/modules/appendix-src-file-index.md`

These files are the canonical onboarding companion for architecture, module responsibilities, and extension points.

## 11. Documentation Maintenance Rules

When changing source logic, update related docs in the same change whenever practical:

1. Entry/include flow changes → update `01-entry-architecture.md`.
2. Constants/localization/env changes → update `02-env-constants-locales.md`.
3. Event pool/effects/allocation changes → update `03-events-system.md`.
4. Bastion AI behavior changes → update `04-bastion-ai.md`.
5. Map point/flow changes → update `05-map-system.md`.
6. Utility subroutine/system changes → update `06-utilities.md`.
7. Hero-specific logic changes → update `07-heroes.md`.
8. Player/effects/title changes → update `08-player-effects-title.md`.
9. Seasonal branch changes → update `09-special-seasonal.md`.

When introducing new external workshop references, record them in `10-references-workshop-codes.md`.
