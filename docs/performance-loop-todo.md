# Performance Loop Safety TODO (Risk-First)

Source baseline:
- `docs/agents/performance-loop-safety.md`
- `docs/improve-server-stability.md`
- `docs/Loops.md`

## 1) Audit Scope and Scoring

Scope:
- `Ongoing - Global` and `Ongoing - Each Player` rules
- Rule loops (`loop`, `Loop If*`)
- `while` loops
- bounded busy loops (no `wait` but finite iteration)
- heavy condition/selection expressions (`distance`, `sorted`, player-array scans)

Priority model:
- `P0`: High crash/load risk or repeated hot-path cost in high-frequency rules.
- `P1`: Medium risk or localized performance inefficiency with lower concurrency impact.
- `P2`: Low risk, readability/maintainability, or optional optimizations.

Status model:
- `TODO`: not started
- `IN_PROGRESS`: currently being optimized
- `DONE`: implemented and validated
- `DEFERRED`: intentionally postponed with reason

## 2) Priority TODO List

| ID | Priority | Rule | Location | Risk | Planned Fix | Acceptance Criteria | Status |
|---|---|---|---|---|---|---|---|
| P0-001 | P0 | `Decay Overhealth` | `src/utilities/system/overhealthDecay.opy` | Legacy disabled module with no active include path; retained code adds maintenance overhead and loop-safety review noise. | Remove unused `overhealthDecay` module and compatibility shim; keep docs/index aligned. | No remaining `overhealthDecay`/`StoreOverhealth`/`storedOverhealth` code references in `src`; no entry include references in `main.opy`/`devMain.opy`. | DONE |
| P0-002 | P0 | `bastion constantly searches for targets in line of sight` | `src/bastion/init.opy` | High-frequency target scan does repeated `getLivingPlayers` + LoS + `sorted`/`distance`; hot-path CPU pressure scales with player count. | Apply layered gates and sparse evaluation rhythm; reduce redundant scans/sorts per tick; keep target quality logic intact. | Target acquisition behavior unchanged functionally; scan cadence is explicitly controlled; hotspot expression count per cycle reduced. | DONE |
| P0-003 | P0 | `players pick up speed while not targeted for 3 seconds` + control-jump related eachPlayer rules | `src/main.opy` and `src/devMain.opy` | Expensive radius/distance checks appear early in eachPlayer gating; extra reevaluation load every tick. | Reorder conditions to high-selectivity/low-cost first; keep expensive radius/distance checks behind cheap gates; preserve `main/devMain` parity. | Condition order follows performance guideline; gameplay behavior unchanged; `main.opy` and `devMain.opy` remain aligned for touched rules. | DONE |
| P0-004 | P0 | Debuff/Mech continuous effect loops | `src/events/effects/debuffEffects.opy`, `src/events/effects/mechEffects.opy` | Multiple sustained loop rules execute heavy checks and effect operations at short intervals; cumulative server-load risk under concurrency. | Standardize loop throttling floor and move costly lookups behind narrower gates; split bursty action chains when needed. | No newly introduced waitless loops; sustained-event rules keep original effects while reducing per-cycle heavy operations. | IN_PROGRESS |
| P0-005 | P0 | `rejecSampling` | `src/events/allocation/rejectSampling.opy` | Busy finite `while` loops (cap=8) still execute in a single frame; may contribute to startup/selection spikes under many players. | Convert to safer bounded sampling pattern with pacing or lighter per-iteration cost while preserving weighted selection intent. | Selection semantics remain equivalent (weighted rejection behavior preserved); no high-cost busy loop remains in this path. | DONE |

| ID | Priority | Rule | Location | Risk | Planned Fix | Acceptance Criteria | Status |
|---|---|---|---|---|---|---|---|
| P1-001 | P1 | Health-pool cleanup loop | `src/utilities/system/healthPool.opy` | Per-player sort + cleanup can spike when queues grow. | Cap per-cycle removals or batch with explicit frame slicing under large queues. | Cleanup remains correct; large queue processing no longer concentrates in one frame. | TODO |
| P1-002 | P1 | Bastion aim/turn update micro-loops | `src/bastion/init.opy` | Several independent loops each tick can stack cost on Team 2 bots. | Review merge opportunities and cadence harmonization for shared gating rules. | No behavior regression in aim/turn responsiveness; reduced duplicate reevaluation work. | DONE |
| P1-003 | P1 | Event loop consistency pass | `src/events/effects/buffEffects.opy` | Many ongoing loop patterns with heterogeneous wait strategy increase maintenance risk. | Normalize loop pattern templates (`wait` + `loop`) and annotate exceptions. | Consistent loop safety pattern applied; exceptions documented with rationale. | TODO |

| ID | Priority | Rule | Location | Risk | Planned Fix | Acceptance Criteria | Status |
|---|---|---|---|---|---|---|---|
| P2-001 | P2 | Performance lint-style scan automation | `tools/` (new or existing script path TBD) | Manual review can drift over time. | Add repeatable scan command for `loop/while/wait` and common heavy-expression hotspots. | One-command report available and referenced in docs workflow. | TODO |
| P2-002 | P2 | Documentation cross-linking | `docs/agents/*`, `docs/modules/*` | Performance constraints may drift from module docs. | Add pointers from relevant module docs back to canonical loop-safety rules. | Links present; no duplicate canonical rule text introduced. | TODO |

## 3) Done Log

Use this section when an item reaches `DONE`.

Template:
- `Date`:
- `ID`:
- `Change Summary`:
- `Validation`:
  - static scan:
  - behavior checks:
  - perf observation:
- `Notes`:

Current:
- `Date`: 2026-03-08
- `ID`: P0-001
- `Change Summary`: Removed deprecated `overhealthDecay` implementation and shim (`src/utilities/system/overhealthDecay.opy`, `src/utilities/overhealthDecay.opy`) and synchronized module docs/index.
- `Validation`:
  - static scan: `rg` confirms no `overhealthDecay`/`StoreOverhealth`/`storedOverhealth` source references remain.
  - behavior checks: no runtime behavior impact expected because module was disabled and not included by entry files.
  - perf observation: eliminates a flagged waitless-loop risk surface by retiring dead code.
- `Notes`: Scoped as deprecation cleanup for P0-001.

- `Date`: 2026-03-08
- `ID`: P0-002
- `Change Summary`: Refactored Bastion target scanning in `src/bastion/init.opy` to reuse valid current targets, gate full rescans behind a cheap nearby-LoS probe, and move expensive LoS checks after cheaper candidate filters.
- `Validation`:
  - static scan: existing target path now bypasses `getLivingPlayers`/`sorted`; full scans only sort when more than one candidate survives.
  - behavior checks: target preference logic remains unchanged for both normal mode and `dlcVishkarEvent`; invalid or hidden targets are still cleared before the next loop.
  - perf observation: removes repeated full-array LoS scans while a target remains valid and cuts unnecessary LoS work on filtered-out candidates.
- `Notes`: Preserves existing scan cadence constants and avoids adding new player variable slots.

- `Date`: 2026-03-08
- `ID`: P0-005
- `Change Summary`: Refactored `src/events/allocation/rejectSampling.opy` to unify Buff/Debuff/Mech paths, cache eligible event candidates once per roll, and preserve the existing max-8 rejection attempts with last-candidate fallback.
- `Validation`:
  - static scan: no `exclude(...)/filter` candidate rebuild remains inside the retry loop; `rejecSampling()` call sites in `setPlayerEvent` are unchanged.
  - behavior checks: keeps previous selection flow (`eventLastId` exclusion first, fallback to full pool if needed, accept on `random.uniform(0, eventWeight) < weight`, fallback to last sampled id after 8 misses).
  - perf observation: removes repeated candidate-array reconstruction inside the busy loop, reducing per-roll hotspot cost.
- `Notes`: No new variable-slot allocations or entry include changes.

- `Date`: 2026-03-08
- `ID`: P0-003 / P0-004 (Wave 1)
- `Change Summary`: Reordered cheap-first gating in `players pick up speed while not targeted for 3 seconds` for both entry files, and applied first-wave loop gating reductions in Debuff/Mech (`献祭`, `保持距离(易伤光环)`, `有点松弛`, `刹车失灵`).
- `Validation`:
  - static scan: target rules now put cheap checks (`isMoving`/`isAlive`) ahead of expensive radius scans; duplicate ability-scan condition in `献祭` reduced from two list scans to one.
  - behavior checks: no wait cadence or core loop control flow changed; effect math and event durations remain unchanged.
  - perf observation: cuts avoidable per-tick scans on dead/non-moving players and reduces duplicate team-wide ability scans in a sustained debuff loop.
- `Notes`: This is a partial completion wave; P0-003 control-jump and P0-004 remaining sustained-loop hotspots continue in Wave 2.

- `Date`: 2026-03-08
- `ID`: P0-003 / P0-004 (Wave 2)
- `Change Summary`: Completed P0-003 control-jump path optimization in `main/devMain` (cheap-first `isAlive`/null gating and staged height-then-distance spatial checks), and advanced P0-004 with additional alive/availability gates for `引力异常`, `无能的丈夫/妻子`, `我和你(生命同步)`, `吸血鬼(按需吸血)`.
- `Validation`:
  - static scan: expensive map-control distance checks are now guarded by cheap preconditions and split into staged checks; added gates prevent repeated radius/sort work for dead/ineligible players.
  - behavior checks: no wait cadence, duration, damage/heal formulas, or event timing constants were changed.
  - perf observation: reduces avoidable per-tick math on control-jump path and skips heavy target collection when preconditions fail in sustained debuff loops.
- `Notes`: P0-003 is closed in this wave. P0-004 remains `IN_PROGRESS`; remaining hotspots continue in next wave.

- `Date`: 2026-03-08
- `ID`: P0-004 (Wave 3)
- `Change Summary`: Advanced sustained-loop optimization for Debuff/Mech by reducing avoidable heavy calculations in `引力异常`, `保持距离(易伤光环)`, `我和你(生命同步)`, `吸血鬼(按需吸血)`, plus alive-first gating consistency for `瓦尔基里降临 大招充能`, `瓦尔基里降临(大招持续回血)`, `三位一体(SSR)`.
- `Validation`:
  - static scan: `保持距离` now skips `sorted(...)` when no candidates exist; `引力异常` now bypasses sort when Team 2 has a single target; added cheap `isAlive`/team-size gates in sustained rules.
  - behavior checks: wait cadence, durations, formulas, and Team 2 target-set semantics for `引力异常` were preserved.
  - perf observation: fewer per-tick sort/radius evaluations under sparse or ineligible player states.
- `Notes`: P0-004 remains `IN_PROGRESS`; remaining hotspots include `献祭` target-selection path and selected debuff AOE distance-scan rules for next wave.

- `Date`: 2026-03-08
- `ID`: P1-002
- `Change Summary`: Merged Bastion turn-speed tracking and no-target flick-prep micro-loops into a single shared-gating rule in `src/bastion/init.opy`, reusing aim-direction computation for the no-target path while keeping target/no-target cadence branches intact.
- `Validation`:
  - static scan: one independent `turnSpeed` loop rule removed; no-target path now computes `directionTowards(...)` once and reuses it for angle gate plus turn-speed update.
  - behavior checks: preserved target semantics (`target != false` tracking path and `target == false` flick-prep path), existing wait constants, and `startFacing` trigger preconditions.
  - perf observation: reduces duplicate reevaluation overhead from adjacent aim/turn micro-loops and avoids repeated direction reconstruction in the no-target branch.
- `Notes`: No new player variable slots, include-order changes, or entry-file edits were introduced.

## 4) Regression Checklist

- [x] Full scan confirms no new waitless loop paths in modified logic.
- [x] `Ongoing` rule conditions are ordered by high-selectivity and low-cost checks first.
- [x] Expensive array/distance queries are gated and not front-loaded unnecessarily.
- [ ] Heavy action bursts are split across frames where practical.
- [x] `src/main.opy` and `src/devMain.opy` stay aligned for touched entry-level rules.
- [ ] Any deferred item has explicit rationale and owner/date note.
