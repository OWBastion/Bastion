# Bastion settlement screenshot HUD contract

## Current contract

- Contract revision: `settlement-hud-v1`
- Introduced by released version: `v26.0811.1`
- Current released verification baseline: `v26.0822.1`
- Producer: Bastion settlement/completion HUD
- Consumer ownership: OCRKit selects layouts and extracts evidence; the platform decides how evidence is used

This document describes visible game facts emitted by the released Bastion HUD. It does not define OCR regions, preprocessing, model settings, confidence thresholds, approval rules, or service integration.

## Visible fields

The current settlement HUD is composed of a left progress/completion area, a left statistics panel, a right map/difficulty line, and a right version line. The exact localized labels are part of the visible format; the field meaning and display conditions are the stable contract.

| Field | Visible format in the current release | Display condition and context |
| --- | --- | --- |
| Completion state | `Challenge Complete` / `挑战完成`; the completion announcement also says `Congratulations {player}` / `祝贺 {player}` | The persistent completion indicator is shown for a player after that player reaches the final hero. The announcement is emitted on the normal completion path. |
| Viewer/player name | The transient completion announcement includes the completing player name | This is announcement evidence, not a persistent dedicated name row in the settlement statistics panel. |
| Map | Current localized map name, with the `Classic` / `·经典版` suffix when the selected map variant requires it | Shown to all players in the right-side map/difficulty line. |
| Difficulty | Localized difficulty label | Shown to all players in the right-side map/difficulty line. |
| Game version | `Ver <VERSION>` / `版本 <VERSION>` | Shown to all players in the right-side version line. The value is the released Bastion `VERSION`. |
| Elapsed time | `Total Time: <hours/minutes/seconds>` / `通关总计耗时 <hours/分/秒>` | Shown in the statistics panel for a winning player and included in the completion announcement. Zero-hour/minute units are omitted according to the locale format. |
| Deaths and skips | `Deaths/Skips <deaths>/<skips>` / `总计阵亡/跳过 <deaths>/<skips>` | Shown in the statistics panel. Values are the current player's run counters. |
| Run code | Three numeric groups in `NNNN-NNNN-NNNN` format | Generated once during game initialization and kept as the room-level `masteryRunCode`. The current HUD appends it to the settlement statistics/version display only when the local player is a winner. Older screenshots produced before `settlement-hud-v1` do not contain this field. |
| Event statistics | `Buff/Debuff/Total <buff>/<debuff>/<total>` / localized equivalent | Shown in the statistics panel for the current player. |
| Player attributes | `Heartsteel/Speed/DR/Heal% <stacks>/<speed>/<damage reduction>/<healing>` / localized equivalent | Shown in the statistics panel for the current player. |
| Achievement/title evidence | Earned title text followed by a completion checkmark | Shown in the left achievement area when achievements are enabled and the player has earned achievements. When disabled, the HUD shows the localized disabled warning instead. |

The player identity in the persistent lower-left hero UI is not a Bastion-owned settlement field in this revision. OCRKit must not infer a player-account match from the transient announcement or any unrelated game UI without a separate consumer contract.

## Revision history and compatibility boundary

| Revision | Released boundary | Material change | Compatibility note |
| --- | --- | --- | --- |
| `settlement-hud-pre-run-code` | Releases before `v26.0811.1` | Settlement HUD had the fields above except the room-level run code | Treat screenshots from this boundary as no-run-code evidence. |
| `settlement-hud-v1` | `v26.0811.1` and later, including `v26.0822.1` | Added the stable room-level run code to the existing settlement/version display | Existing map, difficulty, version, completion, time, deaths/skips, event, attribute, and achievement displays remain part of the supported layout. |

The next revision must record its first real released Bastion version here. A source change or unreleased build is not a new released contract revision.

## Change assessment rule

Any change to settlement/completion HUD behavior must include one explicit line in the change description:

- `OCR compatibility impact: no OCR compatibility impact — <reason>`; or
- `OCR compatibility impact: requires OCRKit compatibility update — <affected contract revision and fields>`.

Use the second form for changes to field grouping, localized labels, value formats, visibility conditions, field additions/removals, or layout changes that can affect screenshot capture or recognition. Update this contract only when the visible producer behavior and released revision change. Do not add OCR implementation details or runtime coupling to Bastion.

## Source references

- `src/effects/init.opy`: persistent completion, statistics, achievement, map/difficulty, and version HUD emission
- `src/main.opy` and `src/en-US.main.opy`: completion state, announcement, and elapsed-time emission
- `src/env/game.opy`: room-level `masteryRunCode` initialization
- `src/locales/en-US.opy` and `src/locales/zh-CN.opy`: localized visible labels and formats
