---
name: workshop-event
description: Add, change, or remove a Bastion random event (Buff/Debuff/Mech): event enum, constants, zh-CN/en-US locale keys, eventCatalog registration, effects rules, and the platform event ID mapping. Use for 新增/调整/移除/下线事件, retiring an event, or fixing an event whose enum, catalog, effects, or platform mapping disagree. Not for platform title metadata or gameplay unrelated to the event lifecycle.
---

# Workshop Event

Keep the change to the target event; no reordering, refactors, placeholder events, or compatibility shims.

## Scaffold with the tool

`pnpm run tools -- event:add --spec <file.json>` and `event:remove --spec <file.json>` (add `--dry-run` first) edit `event_ids`, `event_constants`, both locales, `eventCatalog`, and `EVENT_CATALOG_ORDER` in the Main and Dev catalogs. The spec fields are defined in `tools/event.ts` (`type`, `key`, `id`, `titleZh/En`, `descZh/En`, `duration`, `weight`, optional `configDescExpr`). Do not repeat that work by hand.

## What the tool does not do

- **Platform mapping:** `data/platform-event-ids.json` must map every catalog event to its platform ID and nothing else; `sync:platform-data` only validates it and fails on a missing or unknown key. Adding needs the event to exist on the platform first, since the stable ID comes from there. Removing deletes the mapping.
- **Effects rules (`src/events/effects/*`):** write or delete them by hand. Dispatch on a single `eventId == EventId.X` condition, never `eventType`; gate in the default condition area; any action-area check needs an explicit `wait(...)`; finish by resetting player state and effect entities. Removal also drops the `#!include` and, by default, the effect file.

## Verify

Run the builds, `./tools/check_locale_keys.sh`, and `pnpm run test:platform-data-sync` from `docs/agents/build-validation.md`. After removal, `rg` for the key, `STR_EVT_*`, and `EVT_*` names must find nothing.
