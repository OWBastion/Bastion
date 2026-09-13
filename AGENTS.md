# AGENTS.md

This file is the repository entrypoint for AI agents working on Bastion. Workspace guidance owns shared engineering policy; this file specializes Bastion-specific contracts, risk routing, and local validation.

## Repository role

Bastion owns gameplay implementation, Workshop / OverPy source, game-side UI, build and release behavior, and game-specific performance characteristics.

Platform-owned metadata is consumed through the platform contract. Do not duplicate platform business truth in this repository or move platform-owned behavior into game code for implementation convenience.

## Start here

For substantive work:

1. Read the linked Issue and inspect the relevant source before deciding where to change code.
2. Identify the affected gameplay or build responsibility and load only the routed guidance for that risk surface.
3. Compare the Issue contract, current Bastion contract, and current code reality. If they materially disagree, report the mismatch instead of inventing a new gameplay or architecture decision.
4. Implement the smallest complete change that keeps the affected behavior in a coherent local responsibility.
5. Verify at the narrowest decisive surface first, then run the broader repository gates required by the touched risk.

Do not preload all documentation or skills. Use the smallest relevant context.

## Minimal red lines

1. Do not reorder the entry include flow casually.
2. Keep `src/main.opy` and `src/devMain.opy` aligned where their intended behavior is shared.
3. Do not bypass commit hooks (`git commit --no-verify` is forbidden).
4. Do not implement seasonal/event-specific content on the current mainline unless the Issue explicitly targets it.
5. Do not use `shared` in project-owned names for common configuration or behavior; use responsibility-based names, `BASE` for base macros, and `MAIN` / `DEV` for entry-specific overrides.
6. Do not turn gameplay code into a generic interpreter or extension framework without a current approved requirement.

## Risk routing

Read only the documents needed for the actual change:

| Risk / task shape | Read first | Then read if needed |
| --- | --- | --- |
| Entry/include/order changes or `main/devMain` parity | `docs/agents/architecture-rules.md` | `docs/modules/01-entry-architecture.md` |
| Build, CI, release, or local validation | `docs/agents/build-validation.md` | relevant workflow files |
| Performance, loops, `Ongoing`, polling, expensive player scans | `docs/agents/performance-loop-safety.md` | `docs/improve-server-stability.md`, `docs/Loops.md` |
| Event lifecycle, temporary effects/state, reconnect/leave cleanup | `docs/agents/performance-loop-safety.md` | affected event/module docs and source |
| Random-event selection, eligibility, weighting, history/duplication logic | affected event-selection source and tests | performance guidance if hot-path behavior changes |
| Platform metadata, title/event/map sync, Agents API, cross-repository contract changes | `docs/agents/ecosystem-platform-boundary.md` | `docs/agents/build-validation.md`, affected sync tooling |
| PR/commit hygiene and collaboration boundaries | `docs/agents/collaboration-commit.md` | this file |
| Documentation ownership or source-to-doc synchronization | `docs/agents/doc-sync.md` | `docs/modules/README.md` |
| Context acquisition and route-first loading | `docs/agents/context-routing.md` | `docs/agents/README.md` |

When a change materially affects gameplay behavior, state lifecycle, random selection, cross-repository contracts, or performance-sensitive logic, verification must include an independent attempt to falsify the change rather than relying only on the authoring test/build pass. Where practical, temporarily remove, invert, or simplify the key behavior and confirm that the targeted regression becomes observable again.

## Local invariants

- No repeating loop may run without an appropriate `Wait` or equivalent bounded/event-driven control.
- `0.016` is reserved for behavior that genuinely requires near-frame updates.
- Prefer event-driven or low-frequency checks over polling. Put cheap, stable, selective conditions before expensive distance, raycast, array-filter, player-scan, or dynamic-text work.
- Temporary gameplay state must account for creation, update, normal completion, abnormal termination, player leave, and reconnect/reset paths where applicable.
- Long-session changes must consider stale variables, effect/HUD handles, array growth, and cumulative cost across repeated events.
- Performance-sensitive changes should reduce frequency, candidate scope, or persistent state before pursuing micro-optimizations.
- Code should communicate gameplay responsibility through naming, structure, and control flow. Do not use explanatory comments to compensate for unclear feature placement or mixed responsibility.

## Canonical rule index

Each rule family has one canonical document:

1. Architecture consistency and entry constraints -> `docs/agents/architecture-rules.md`
2. Build and validation -> `docs/agents/build-validation.md`
3. Performance and loop safety -> `docs/agents/performance-loop-safety.md`
4. Collaboration and commit hygiene -> `docs/agents/collaboration-commit.md`
5. Documentation synchronization -> `docs/agents/doc-sync.md`
6. Context routing -> `docs/agents/context-routing.md`
7. Ecosystem/platform boundaries -> `docs/agents/ecosystem-platform-boundary.md`

If another document needs one of these rules, link to its canonical owner rather than duplicating the full guidance.

## Workflow command pointers

- CI-parity install: `pnpm install --frozen-lockfile`
- Core compile validation: `pnpm run build`
- Entry-specific compile validation: `pnpm run build:cn:zh`, `pnpm run build:external:en`, `pnpm run build:external:zh`, and `pnpm run build:dev:cn:zh`
- Aggregate tool tests: `pnpm run tools:test`
- Unified source-data sync: `pnpm run tools -- sync`
- Platform/title metadata sync: `pnpm run sync:platform-data`
- Event add/remove workflows: `pnpm run tools -- event:add`, `pnpm run tools -- event:remove`
- Platform-data sync validation: `pnpm run sync:platform-data` then `pnpm run tools -- test:platform-data-sync`
- Locale-key integrity when touching source/localization/event text: `./tools/check_locale_keys.sh`
- Performance scan: `pnpm run tools -- perf:scan`; strict gate: `pnpm run tools -- perf:scan --strict`
- Release artifact parity: `pnpm run build:release`
- Profile release builds: `pnpm run build:cn:zh` and `pnpm run build:external:en`
- Manual env-version helper: `pnpm run tools -- bump:env-version`

Player title grants remain platform-owned; Bastion has no local grant helper.

## Skills

- `add-workshop-title`: platform title metadata and generated-artifact checks.
- `add-workshop-event`: event enum/constants/i18n/config/effects workflow with count and rule-safety checks.
- `session-skill-maintainer`: maintain repository-local skills and routing from durable evidence.

Skills are procedures, not additional policy owners. Keep root `AGENTS.md` as a route-first entrypoint and keep detailed procedures in the skill or canonical routed document.
