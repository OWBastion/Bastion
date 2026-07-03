# Bastion OverPy Build Warning Analysis

## Summary

- Date: `2026-07-03`
- Evidence commands:
  - `rtk pnpm run build`
  - `rtk pnpm run build:main`
  - `rtk pnpm run build:dev`
- Scope: current OverPy build warnings only; this document does not apply fixes.

This analysis is based on the current local build output, not historical assumptions. `main` and `devMain` currently share the same warning classes except for `w_element_limit`, which only appears in `devMain`. OverPy prints each warning twice in the current build flow, once as the raw message and once with the `Warning:` prefix; this document counts each warning class once.

## Current Warning Set

| Priority | Warning | Entries | Affected build |
| --- | --- | ---: | --- |
| P0 | `w_element_limit` | 1 | `build:dev` only |
| P1 | `w_ow2_rule_condition_chase` | 2 | `build:main`, `build:dev` |
| P2 | `w_workshop_setting_enum_default` | 1 | `build:main`, `build:dev` |
| P3 | `w_lone_else` | 5 | `build:main`, `build:dev` |
| P4 | `w_wait_9999` | 1 | `build:main`, `build:dev` |
| P5 | `w_censored_var_name` | 2 | `build:main`, `build:dev` |

## P0: `w_element_limit`

- Build evidence: `The gamemode is over the element limit (33321 > 32768 elements)`.
- Scope: `build:dev` only.
- Code location: OverPy reports this at `<internal>`, so the warning is entry-output level rather than a single source line.
- Risk: highest. This is a capacity limit issue, not a style warning. It can block safe future additions and may already affect import/runtime headroom for the dev entry.
- Recommendation: treat as the first remediation track, separate from all other warnings.

### Options

1. Trim `devMain`-only development and debug features.
   - Pros: lowest production risk; leaves `main` behavior alone.
   - Cons: needs targeted measurement to decide which dev-only features are worth cutting.
2. Remove low-value display logic such as redundant HUD/text output.
   - Pros: direct element recovery without changing core gameplay.
   - Cons: benefit must be measured block by block.
3. Refactor shared logic to reduce rule/condition/action expansion.
   - Pros: may benefit both `main` and `devMain`.
   - Cons: largest diff and highest regression risk.

### Recommended approach

Start with option 1, then use option 2 if more headroom is still needed. Do not start with a broad shared refactor. This warning should remain a separate workstream from the semantic warnings below.

### Verification for future fixes

- `rtk pnpm run build:dev`
- Record the element count delta before and after each dev-only reduction.

## P1: `w_ow2_rule_condition_chase`

- Build evidence:
  - `This rule condition will possibly not trigger properly due to a workshop bug, because the player variable 'hack_timer' is chased.`
  - `The player variable 'hack_timer' is chased, but also used in a rule condition, making the rule condition possibly not trigger properly due to a workshop bug.`
- Code location: [src/events/effects/debuff/emp_promax.opy](/Users/teakowa/Repos/teakowa/Bastion/src/events/effects/debuff/emp_promax.opy:23) and [src/events/effects/debuff/emp_promax.opy](/Users/teakowa/Repos/teakowa/Bastion/src/events/effects/debuff/emp_promax.opy:32)
- Current shape:
  - Rule condition gates on `eventPlayer.hack_timer == 0`.
  - The same variable is later driven by `chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)`.
- Risk: high. OverPy flags this as a real Workshop bug risk, not just a readability issue.

### Options

1. Stop using the chased variable in rule conditions and gate with a separate state field.
   - Pros: best match for the warning and clearest long-term model.
   - Cons: requires a small state-model change.
2. Keep one variable but restructure the chase lifecycle so the condition no longer races with it.
   - Pros: smaller code diff.
   - Cons: easy to paper over the warning without fully removing the bug risk.
3. Remove the chase and use explicit countdown logic instead.
   - Pros: avoids the chase-condition combination completely.
   - Cons: may cost more rules/actions and add server-load risk.

### Recommended approach

Option 1. Decouple "hack active / hack rearm ready" from `hack_timer`. A dedicated status flag or other non-chased gate is safer than continuing to overload the timer variable.

### Verification for future fixes

- `rtk pnpm run build:main`
- `rtk pnpm run build:dev`
- Confirm both `w_ow2_rule_condition_chase` warnings disappear.
- Recheck event behavior in the `EMP_PROMAX` flow after the state change.

## P2: `w_workshop_setting_enum_default`

- Build evidence: `Default value for workshop setting enum should be 0, as otherwise the first option is not selectable via the UI.`
- Code location: [src/env/game.opy](/Users/teakowa/Repos/teakowa/Bastion/src/env/game.opy:43)
- Current shape: `difficulty = createWorkshopSettingEnum(STR_SETTING_CAT_GAME, STR_SETTING_DIFFICULTY, 1, STR_ENUM_DIFFICULTY_OPTIONS, 1)`
- Risk: medium. This warning points to a likely UI behavior issue rather than a compile-only concern.

### Options

1. Change the default enum value to `0` and audit all difficulty index consumers.
   - Pros: aligns with OverPy guidance and likely fixes the UI issue.
   - Cons: cannot be done safely without checking existing difficulty semantics.
2. Keep the default at `1` and accept the warning.
   - Pros: zero behavior change.
   - Cons: the first difficulty option may remain unselectable in the Workshop UI.

### Recommended approach

Audit the difficulty index contract first, especially the mapping logic in [src/utilities/system/setDifficulty.opy](/Users/teakowa/Repos/teakowa/Bastion/src/utilities/system/setDifficulty.opy:13). If the value is intended to be zero-based, change the default to `0` and update the mapping together. Do not change the literal in isolation.

### Verification for future fixes

- `rtk pnpm run build:main`
- `rtk pnpm run build:dev`
- Manual check that the first difficulty option is selectable in the Workshop settings UI.

## P3: `w_lone_else`

- Build evidence: `Found 'else' directly after another 'else'`
- Code locations:
  - [src/utilities/system/setDifficulty.opy](/Users/teakowa/Repos/teakowa/Bastion/src/utilities/system/setDifficulty.opy:19)
  - [src/utilities/system/setDifficulty.opy](/Users/teakowa/Repos/teakowa/Bastion/src/utilities/system/setDifficulty.opy:22)
  - [src/utilities/system/setDifficulty.opy](/Users/teakowa/Repos/teakowa/Bastion/src/utilities/system/setDifficulty.opy:25)
  - [src/utilities/system/setDifficulty.opy](/Users/teakowa/Repos/teakowa/Bastion/src/utilities/system/setDifficulty.opy:28)
  - [src/utilities/system/setDifficulty.opy](/Users/teakowa/Repos/teakowa/Bastion/src/utilities/system/setDifficulty.opy:31)
- Current shape: the file uses `if true` plus `goto loc+[ ... ]` and a run of bare `else:` branches to build a jump-table style mapping.
- Risk: medium. This looks intentional, but it is structurally brittle and compiler-hostile.

### Options

1. Rewrite it as standard `if / elif / else`.
   - Pros: warning likely disappears and the code becomes more legible.
   - Cons: may increase element count and remove an intentional compact pattern.
2. Keep the current jump-table trick and accept the warning.
   - Pros: zero behavior risk.
   - Cons: warning remains and the structure stays opaque.
3. Replace the branch chain with a table-driven text/color mapping.
   - Pros: could reduce structural noise while keeping the logic compact.
   - Cons: element impact must be measured; not guaranteed to be smaller after OverPy expansion.

### Recommended approach

Evaluate option 3 first, then fall back to option 1 if it removes the warning without raising the compiled element footprint. This item is coupled to `w_element_limit`, so any cleanup here must be judged partly on compiled size, not just source readability.

### Verification for future fixes

- `rtk pnpm run build:main`
- `rtk pnpm run build:dev`
- Compare element count before and after the rewrite, especially for `build:dev`.

## P4: `w_wait_9999`

- Build evidence: `waitUntil(..., 9999) is not enough because a custom game can last up to 16200 seconds. Use Math.INFINITY or 99999.`
- Code location: [src/heroes/ana.opy](/Users/teakowa/Repos/teakowa/Bastion/src/heroes/ana.opy:45)
- Current shape: `waitUntil(not isHeroBeingPlayed(Hero.ANA, Team.1), 9999)`
- Risk: medium-low. This only matters in long sessions, but the warning points to a real upper-bound mismatch.

### Options

1. Change the timeout to `Math.INFINITY`.
   - Pros: cleanest way to express "wait until Ana is no longer active."
   - Cons: only correct if the wait truly has no desired hard timeout.
2. Change the timeout to `99999`.
   - Pros: keeps a finite timeout while satisfying the compiler advice.
   - Cons: remains a magic number with weaker intent.

### Recommended approach

If the intended behavior is "stay alive until Ana is no longer present," use `Math.INFINITY`. This is a localized cleanup and does not need a large refactor.

### Verification for future fixes

- `rtk pnpm run build:main`
- `rtk pnpm run build:dev`
- Confirm `w_wait_9999` disappears and the HUD cleanup still occurs when Ana leaves play.

## P5: `w_censored_var_name`

- Build evidence:
  - `The variable or subroutine name 'phase_trigger' will not be able to be pasted by English players, as it contains the word 'rigger'.`
  - `The variable or subroutine name 'altFormTrigger' will not be able to be pasted by English players, as it contains the word 'rigger'.`
- Code locations:
  - [src/env/vars_shared.opy](/Users/teakowa/Repos/teakowa/Bastion/src/env/vars_shared.opy:165)
  - [src/env/vars_shared.opy](/Users/teakowa/Repos/teakowa/Bastion/src/env/vars_shared.opy:174)
- Risk: medium-low. This is primarily a pasteability / user-facing naming restriction for English clients, not a logic bug.

### Options

1. Rename the variables to names that avoid `trigger`.
   - Pros: warning disappears fully.
   - Cons: requires repo-wide replacement across shared includes and all entries.
2. Keep the current names and document them as accepted baseline warnings.
   - Pros: zero runtime risk.
   - Cons: warning remains permanently.

### Recommended approach

Defer unless nearby work already touches the same state model. If the project later chooses to clean these up, rename them consistently across shared sources and validate all affected entries together.

### Suggested naming direction

- `phase_trigger` -> a state name that describes readiness or active phase without `trigger`
- `altFormTrigger` -> a state name that describes alternate-form latch / active state without `trigger`

### Verification for future fixes

- `rtk pnpm run build:main`
- `rtk pnpm run build:dev`
- If shared names are changed, also run the `en-US` entry build because the affected vars live in shared includes.

## Suggested Remediation Order

1. `w_element_limit` (`devMain` only)
2. `w_ow2_rule_condition_chase`
3. `w_workshop_setting_enum_default`
4. `w_lone_else`
5. `w_wait_9999`
6. `w_censored_var_name`

## Acceptance Standard For This Document

- Each warning class has a concrete source location or an explicit statement that it is entry-output level.
- Each warning class has a clear recommendation, at least two possible fixes, and a recommended path.
- `w_element_limit` is documented as a separate capacity risk instead of being mixed with the semantic warnings.
- The document stays scoped to analysis and remediation planning only; no source changes are implied by this artifact alone.
