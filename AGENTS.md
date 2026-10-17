# AGENTS.md

This file is the repository entrypoint for AI agents working on Bastion. [OWBastion organization routing](../.github/AGENTS.md) owns repository ownership, shared policy routing, and global invariants. This file specializes Bastion ownership, domain constraints, risk routing, and local validation.

## Repository role

Bastion owns gameplay implementation, Workshop / OverPy source, game-side UI, build and release behavior, and game-specific performance characteristics.

Platform-owned metadata is consumed through the platform contract. Do not duplicate platform business truth here or move platform-owned behavior into game code for implementation convenience.

## Contribution to the organization goal

Is the product the [organization product goal](../.github/docs/product-goal.md) protects: a maintained Bastion Escape 3 that keeps fixed-route runs, event-driven change, and map knowledge, with new and reworked events judged by decision space, replayability, and Workshop stability and performance. Build and Agents API sync exist to ship that content reliably, not as independent systems.

## Repository delivery constraints

Follow the organization [PR delivery](../.github/docs/pr-delivery.md) and [issue readiness](../.github/docs/issue-readiness.md) policies, plus `docs/agents/collaboration-commit.md` for the repository's local delivery contract.

## Minimal red lines

1. Do not reorder the entry include flow casually.
2. Keep `src/main.opy` and `src/devMain.opy` aligned where intended behavior is shared.
3. Do not bypass commit hooks; `git commit --no-verify` is forbidden.
4. Do not implement seasonal/event-specific content on the current mainline unless the Issue explicitly targets it.
5. Do not use `shared` in project-owned names for common configuration or behavior; use responsibility-based names, `BASE` for base macros, and `MAIN` / `DEV` for entry-specific overrides.
6. Do not turn gameplay code into a generic interpreter or extension framework without a current approved requirement.
7. Do not write `tools/` tests that assert on Workshop `.opy` source or gameplay behavior; `tools/` tests cover the tooling itself, not game logic.

## Risk routing

Read only documents needed for the actual change:

| Risk / task shape | Read first | Then if needed |
| --- | --- | --- |
| Entry/include/order changes or `main/devMain` parity | `docs/agents/architecture-rules.md` | `docs/modules/01-entry-architecture.md` |
| Build, CI, release, or local validation | `docs/agents/build-validation.md` | relevant workflow files |
| Performance, loops, `Ongoing`, polling, expensive player scans | `docs/agents/performance-loop-safety.md` | `docs/improve-server-stability.md`, `docs/references/Loops.md` |
| Event lifecycle, temporary state/effects, reconnect/leave cleanup | `docs/agents/performance-loop-safety.md` | affected event/module source |
| Random-event selection, eligibility, weighting, history/duplication | affected selection source and tests | performance guidance if hot-path behavior changes |
| Platform metadata, title/event/map sync, Agents API, cross-repo contracts | `docs/agents/ecosystem-platform-boundary.md` | `docs/agents/build-validation.md`, affected sync tooling |
| PR/commit/review delivery | `docs/agents/collaboration-commit.md` | this file |
| Documentation ownership or source-to-doc sync | `docs/agents/doc-sync.md` | `docs/modules/README.md` |
| Context acquisition and route-first loading | `docs/agents/context-routing.md` | `docs/agents/README.md` |

## Gameplay verification

Apply the organization [testing](../.github/docs/testing-policy.md) and [verification](../.github/docs/verification-and-acceptance.md) policies. Material gameplay behavior, state lifecycle, random-event selection, platform boundaries, and performance-sensitive changes need evidence that can expose an incorrect behavior at the affected game/build boundary.

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

## Commands

`package.json` scripts and `docs/agents/build-validation.md` are the command source of truth; do not copy command inventories here.

Player title grants remain platform-owned; Bastion has no local grant helper.

## Skills

- `add-workshop-title`: platform title metadata or generated title artifacts are added or changed.
- `add-workshop-event`: event enum/constants/i18n/config/effects or their generated facts are added, removed, or changed.
- `session-skill-maintainer`: durable evidence shows repository-local skill content or routing needs maintenance.

`skills/` in this repository owns Bastion workflow procedures (`add-workshop-event`, `add-workshop-title`, `remove-workshop-event`, `session-skill-maintainer`); same-name directories under workspace `.agents/skills/` may lag, so treat these as canonical for Bastion tasks. Workspace governance skills (`owbastion-reclaim-entropy`, `owbastion-verify-change`, `owbastion-test-design-review`) apply per the organization routing.
