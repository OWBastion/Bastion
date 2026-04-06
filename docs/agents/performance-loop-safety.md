# Performance and Loop Safety (Canonical)

This document is the canonical rule source for server-load and loop safety.

## Mandatory Rules

1. Never add loops without a reasonable `wait`.
2. For `Ongoing - Global` and `Ongoing - Each Player`, prefer condition-block gating first.
3. Order conditions by high-selectivity and low-cost checks first.
4. Use action-side checks (`If` + `wait`) only for explicit interval control or shared upper gating.
5. Rule declaration order matters for same-gate execution; treat ordering changes as behavior changes.
6. Use heavy array/distance operations carefully in per-player ongoing rules.
7. Split heavy action bursts across frames where needed.
8. Prefer absorbing new checks into existing gated rules when feasible to reduce startup condition explosion.
9. In AOE-triggered event rules, do not rely on post-`wait` event target context for multi-target behavior; either move those actions before `wait`, switch to per-victim event paths (for example `Player Took Damage`), or cache and iterate bounded target sets.

## Deep References

For detailed rationale and examples, read:

1. `docs/improve-server-stability.md`
2. `docs/Loops.md`

## Operational Scan Command

Use `pnpm run tools -- perf:scan` for repeatable static loop/performance hotspot reporting.
Use `pnpm run tools -- perf:scan --strict` when you need non-zero exit on high-risk findings.

## Historical Closure

Performance-loop cleanup history is archived in `docs/plans/performance-loop-closure.md`.
