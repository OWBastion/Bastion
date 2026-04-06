# AGENTS.override.md (web/title-query)

This file defines local collaboration rules for the web title query page and its data pipeline touchpoints.

## Scope

- Applies to `web/title-query/**` changes.
- Applies to page data flow checks that affect this app:
  - `data/title-source.json`
  - `tools/sync-title-data.ts`
  - `web/title-query/public/data/titles.json` (generated output only)

## Source of Truth and Data Path

- `data/title-source.json` is the only canonical source for title/map-title data.
- Page data must flow through:
  - `pnpm run tools -- sync:title-data` for manual regeneration, or `pnpm run tools -- grant:title` for grant-driven updates with auto-sync
  - then `pnpm run build:title-query`
- Do not manually edit generated artifacts under `web/title-query/public/data/`.

## Theme and Readability Rules

- Any new status text class (`*-empty`, `*-error`, `*-hint`, etc.) must define readable behavior in both dark and light themes.
- Do not add dark-only text color overrides without a corresponding light-theme rule.
- Prefer tokenized text colors (`var(--ow-text)`, `var(--ow-text-soft)`) over ad-hoc per-component colors in light theme.

## Expand/Collapse Safety Rules

- Expanded content must be fully reachable; avoid fixed expanded `max-height` caps that can clip long lists.
- Collapse behavior can use `max-height: 0` + `overflow: hidden`; expanded behavior must not truncate content.
- For sections with dynamic content growth, prioritize correctness (full visibility/scrollability) over fancy height animation.

## Validation Gates

- Required gate for web query changes:
  - `pnpm run build:title-query`
- Manual checks before merge:
  - dark/light theme readability for empty/error/hint states
  - expanded sections can reach bottom content
  - search candidates and map blocks still render and toggle correctly

## PR Evidence Expectations

- For any `web/title-query` style/interaction change, include explicit verification notes that dark and light themes were both checked.
- If behavior changes around map progress or collapse/expand, include one short repro + result note in PR description.
