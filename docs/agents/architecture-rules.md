# Architecture Rules (Canonical)

This document is the canonical rule source for entry architecture and structural consistency.

## Core Rules

1. Include order in entry files is behavior-critical; do not reorder casually.
2. Keep `src/main.opy`, `src/devMain.opy`, and `src/externalMain.opy` structurally aligned where intended behavior is shared; `src/editorMain.opy` is the map editor entry: it keeps only the shared modules the editor needs, owns its player join, event allocation and finish rules, and sets the profile macros in `composition/profileEditor.opy`. A change to a shared module must keep the `main`, `devMain`, and `externalMain` outputs rule-identical, and the editor entry must still compile.
3. Event registration lives in `src/events/catalog/eventCatalog.opy`; the one event list shared by every entry lives in `src/events/catalog/eventCatalogOrder.opy`. An entry that must exclude an event sets its catalog weight to 0 (the editor does this for the events that depend on hero progression) and does not keep its own list.
4. Seasonal/event-specific logic belongs to dedicated follow-up branches, not current mainline.
5. Prefer minimal-scope changes in owning module before cross-directory edits.
6. Do not use `shared` in project-owned names to describe common configuration or behavior; use responsibility-based names, `BASE` for base macros, and `MAIN` / `DEV` for entry-specific overrides. A gameplay event whose name is `shared` (for example `sharedBlessing`) is allowed.
7. Source file names under `src/` are camelCase and unique across the tree, so `rg --files` finds a file by name. Entry-specific names (`init<Domain>`, `menu<Name>`, `dev<Name>`, `host<Name>`, `title<Name>`) carry their domain; locale files keep their locale tag (`zh-CN.opy`, `en-US.opy`). Event effect files are named after the event key in camelCase.
8. Entry include order sets subroutine indices and rule expansion order. Stable setup comes first: global variables, titles, event catalog, map detection, blacklist, event flag, map setup, hero settings, then Bastion setup, then event services and effect rules. Middle-section service files are interleaved in fixed slots across owner directories; do not regroup them by directory. `events/lifecycle/resetPlayerEventState.opy` stays before `player/status.opy`. Menu includes stay at the end in their existing order.
9. Event identity is the unified catalog slot `EventId.X`, stored in `eventPlayer.eventId`; `-1` means no event. Dispatch effect rules on `eventId` alone, never on `eventType`, which is derived category state.
10. Updated Workshop code reaches only newly created rooms. Do not add in-room migration of legacy runtime state.

## Validation Expectations

1. If only some entry files changed (`main` / `devMain` / `externalMain`), explain why in change notes.
2. For event changes, verify config registration, effect implementation, and localization consistency.
3. For map changes, verify map aggregation and map detection integration paths when applicable.
