# AGENTS.md

This file is the repository entrypoint for AI agents working on Bastion. [OWBastion organization policy](https://github.com/OWBastion/.github/blob/main/README.md) owns shared engineering, testing, verification, entropy, and delivery policy. This file specializes Bastion ownership, domain constraints, risk routing, and local validation.

## Repository role

Bastion owns gameplay implementation, Workshop / OverPy source, game-side UI, build and release behavior, and game-specific performance characteristics.

Platform-owned metadata is consumed through the platform contract. Do not duplicate platform business truth here or move platform-owned behavior into game code for implementation convenience.

## Repository delivery constraints

Use [organization PR delivery policy](https://github.com/OWBastion/.github/blob/main/docs/pr-delivery.md) and `docs/agents/collaboration-commit.md` for the repository's local delivery contract.

## Minimal red lines

1. Do not reorder the entry include flow casually.
2. Keep `src/main.opy` and `src/devMain.opy` aligned where intended behavior is shared.
3. Do not bypass commit hooks; `git commit --no-verify` is forbidden.
4. Do not implement seasonal/event-specific content on the current mainline unless the Issue explicitly targets it.
5. Do not use `shared` in project-owned names for common configuration or behavior; use responsibility-based names, `BASE` for base macros, and `MAIN` / `DEV` for entry-specific overrides.
6. Do not turn gameplay code into a generic interpreter or extension framework without a current approved requirement.

## Risk routing

Read only documents needed for the actual change:

| Risk / task shape | Read first | Then if needed |
| --- | --- | --- |
| Entry/include/order changes or `main/devMain` parity | `docs/agents/architecture-rules.md` | `docs/modules/01-entry-architecture.md` |
| Build, CI, release, or local validation | `docs/agents/build-validation.md` | relevant workflow files |
| Performance, loops, `Ongoing`, polling, expensive player scans | `docs/agents/performance-loop-safety.md` | `docs/improve-server-stability.md`, `docs/Loops.md` |
| Event lifecycle, temporary state/effects, reconnect/leave cleanup | `docs/agents/performance-loop-safety.md` | affected event/module source |
| Random-event selection, eligibility, weighting, history/duplication | affected selection source and tests | performance guidance if hot-path behavior changes |
| Platform metadata, title/event/map sync, Agents API, cross-repo contracts | `docs/agents/ecosystem-platform-boundary.md` | `docs/agents/build-validation.md`, affected sync tooling |
| PR/commit/review delivery | `docs/agents/collaboration-commit.md` | this file |
| Documentation ownership or source-to-doc sync | `docs/agents/doc-sync.md` | `docs/modules/README.md` |
| Context acquisition and route-first loading | `docs/agents/context-routing.md` | `docs/agents/README.md` |

## Gameplay verification

Apply the [organization testing policy](https://github.com/OWBastion/.github/blob/main/docs/testing-policy.md) and [verification policy](https://github.com/OWBastion/.github/blob/main/docs/verification-and-acceptance.md). Material gameplay behavior, state lifecycle, random-event selection, platform boundaries, and performance-sensitive changes need evidence that can expose an incorrect behavior at the affected game/build boundary.

## Local invariants

- No repeating loop may run without an appropriate `Wait` or equivalent bounded/event-driven control.
- `0.016` is reserved for behavior that genuinely requires near-frame updates.
- Prefer event-driven or low-frequency checks over polling. Put cheap, stable, selective conditions before expensive distance, raycast, array-filter, player-scan, or dynamic-text work.
- Temporary gameplay state must account for creation, update, normal completion, abnormal termination, player leave, and reconnect/reset paths where applicable.
- Long-session changes must consider stale variables, effect/HUD handles, array growth, and cumulative cost across repeated events.
- Performance-sensitive changes should reduce frequency, candidate scope, or persistent state before micro-optimizing.
- Code should communicate gameplay responsibility through naming, structure, and control flow. Comments are for durable external constraints, non-obvious invariants, compatibility reasons, and safety/performance rationale, not prose walkthroughs of unclear code.

## Canonical rule index

1. Architecture consistency and entry constraints -> `docs/agents/architecture-rules.md`
2. Build and validation -> `docs/agents/build-validation.md`
3. Performance and loop safety -> `docs/agents/performance-loop-safety.md`
4. Collaboration, delivery, and commit hygiene -> `docs/agents/collaboration-commit.md`
5. Documentation synchronization -> `docs/agents/doc-sync.md`
6. Context routing -> `docs/agents/context-routing.md`
7. Ecosystem/platform boundaries -> `docs/agents/ecosystem-platform-boundary.md`

Link to canonical owners instead of duplicating their full guidance.

## Workflow command pointers

- CI-parity install: `pnpm install --frozen-lockfile`
- Core compile validation: `pnpm run build`
- Entry-specific compile validation: `pnpm run build:cn:zh`, `pnpm run build:external:en`, `pnpm run build:external:zh`, `pnpm run build:dev:cn:zh`
- Aggregate tool tests: `pnpm run tools:test`
- Unified source-data sync: `pnpm run tools -- sync`
- Platform/title metadata sync: `pnpm run sync:platform-data`
- Event add/remove: `pnpm run tools -- event:add`, `pnpm run tools -- event:remove`
- Platform-data sync validation: `pnpm run sync:platform-data` then `pnpm run tools -- test:platform-data-sync`
- Locale-key integrity: `./tools/check_locale_keys.sh`
- Performance scan: `pnpm run tools -- perf:scan`; strict gate: `pnpm run tools -- perf:scan --strict`
- Release artifact parity: `pnpm run build:release`
- Profile release builds: `pnpm run build:cn:zh`, `pnpm run build:external:en`
- Manual env-version helper: `pnpm run tools -- bump:env-version`

Player title grants remain platform-owned; Bastion has no local grant helper.

## Skills

- `add-workshop-title`: use when platform title metadata or generated title artifacts are being added or changed.
- `add-workshop-event`: use when adding/removing/changing event enum/constants/i18n/config/effects or their generated facts.
- `session-skill-maintainer`: use when durable evidence shows repository-local skill content or routing needs maintenance.

Skill metadata is an activation surface. Relevant task shapes, changed artifacts, or failure signals should trigger the skill without the user having to name it. Skills are procedures, not policy owners, and must not enlarge task scope or override this file and its canonical routed contracts.
