# AGENTS.md

This file is the repository entrypoint for AI agents working on Bastion. Workspace guidance owns shared engineering policy; this file specializes Bastion contracts, risk routing, delivery constraints, and local validation. Keep durable guidance stable: current versions, counts, issue state, and temporary gaps belong in their live source of truth rather than here.

## Repository role

Bastion owns gameplay implementation, Workshop / OverPy source, game-side UI, build and release behavior, and game-specific performance characteristics.

Platform-owned metadata is consumed through the platform contract. Do not duplicate platform business truth here or move platform-owned behavior into game code for implementation convenience.

## Work from intent, not a checklist

A short request such as `implement #123`, `fix #123`, or `review #123` is sufficient. Resolve the smallest relevant context yourself instead of asking the user to repeat repository rules, architecture links, or skill names.

For substantive work:

1. Read the linked Issue and inspect the relevant source, tests, and current contract before deciding where to change code.
2. Identify the owning gameplay/build responsibility and load only guidance relevant to the actual risk surface.
3. Compare the Issue contract, current Bastion contract, and code reality. If they materially disagree, surface the mismatch instead of inventing a new gameplay, public-contract, ownership, or architecture decision.
4. Implement the smallest complete coherent change. Before adding persistent state, abstractions, compatibility layers, configuration, or cross-repository contracts, establish the present requirement they satisfy.
5. Verify the narrowest decisive behavior first, then the broader gates required by the touched risk.
6. Re-evaluate the original goal after verification and continue until the requested work is delivered or a concrete blocker remains.

Do not preload all documentation or skills.

## Repository delivery constraints

Use `docs/agents/collaboration-commit.md` for the full local delivery contract. In particular: implementation/fix work uses a non-default branch and PR unless explicitly local-only; PR review results belong on the PR rather than only in chat; review-fix work includes thread/re-review handoff. Never push implementation commits directly to the default branch. Merge, release, deployment, production mutation, destructive operations, and material scope expansion remain separate authorization boundaries.

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

## Verification: correctness and necessity are different questions

For material gameplay behavior, state lifecycle, random selection, cross-repository contracts, or performance-sensitive logic, verification must include an independent attempt to falsify the claimed behavior. State the claim and the independent basis for the expected result; where practical, remove, invert, or simplify the key behavior and confirm the targeted regression becomes observable again. Rerunning the author's green test/build is not independent evidence.

Separately, perform one simplification/ablation pass for substantive design or implementation changes. Ask whether each newly added mechanism can be removed, deferred, inlined, merged into an existing path, or represented with less persistent state while the accepted requirement still holds. Keep complexity only when the simpler form would violate a current contract, constraint, or real workflow. Ablation tests necessity; it does not prove correctness.

Tests should protect durable behavior, regressions, and invariants. Do not create expectations from current counts, incidental implementation structure, mutable documentation text, or the implementation's own output without an independent basis. A plausible wrong implementation should fail the relevant verification.

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
