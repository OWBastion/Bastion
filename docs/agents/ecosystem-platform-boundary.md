# Ecosystem Platform Boundary.md

> Ecosystem contract version: `1.0`
> Repository: `OWBastion/Bastion`
> Role: authoritative game-content and build repository

## 1. Mission

This repository is the source of truth for the released **Bastion Escape 3** game mode.

Agents working here protect the correctness, performance, buildability, and release integrity of:

- OverPy and Workshop source code;
- random-event implementations and configuration;
- released OverPy title structure and generated title data;
- map, difficulty, localization, and gameplay configuration;
- generated game artifacts and build packages;
- current platform metadata consumed during a Bastion build.

This repository is **not** the primary home for public web product development, screenshot review workflows, player identity, OCR orchestration, or administrator dashboards.

## 2. Ecosystem Position

The target system contains four repositories:

| Repository | Ownership |
| --- | --- |
| `OWBastion/Bastion` | Game source, released content, generated title structure, build and release |
| `OWBastion/owbastion.com` | Public portal, review platform, admin/developer control plane, business data |
| `OWBastion/qqbot` | QQ channel adapter and user notifications |
| `OWBastion/ocrkit` | Stateless screenshot recognition and model lifecycle |

### Hard boundary

`Bastion` owns the stable game definitions, OverPy implementations, generated data, and compilation. `owbastion.com` owns the current platform metadata, gameplay-revision lifecycle, spatial configuration, challenge applicability, and progression facts. Bastion reads that metadata through the Agents APIs when it runs its sync tool; the platform does not mutate Bastion source files or run Bastion builds.

No external service may silently mutate released game data or bypass repository CI.

## 3. Source-of-Truth Rules

The platform is authoritative for:

- event names, weights, durations, and status;
- title names, conditions, scope, and grants;
- map metadata, revision lifecycle, spatial configuration, challenge applicability, and revision-scoped progression facts.

This repository is authoritative for:

- event Workshop effects;
- OverPy indices, arrays, and implementation mappings;
- game versions, build artifacts, and releases;
- localization keys and released player-visible text where they are implemented in Bastion.

This repository is not authoritative for:

- QQ account bindings;
- screenshot submissions and OCR results;
- review decisions and audit history;
- player-facing submission status;
- balance proposals that have not been merged;
- administrator sessions or permissions;
- OCR training datasets and model binaries.

## 4. Transitional Web UI Rules

The former `web/title-query` page has been removed. Its title, event, glossary, and
allocator views are owned by `OWBastion/owbastion.com`; Bastion does not generate
or deploy a web page.

## 5. Agents Current Metadata Sync

When preparing a Bastion build, the repository actively pulls the platform's current metadata from these read-only Agents APIs:

```text
GET /v1/agents/events
GET /v1/agents/maps
GET /v1/agents/achievements
GET /v1/agents/titles
GET /v1/agents/player-title-grants
GET /v1/agents/map-title-holders?mapId=...
```

`/v1/agents/maps` is the revision-aware contract. Each map must expose exactly one
`default` revision and may expose `selectable` revisions. `preparing` and
`historical` revisions are intentionally omitted. A projected revision carries
`gameplayRevisionId`, spatial data, and revision-scoped challenge references;
map title holders carry the same revision ID and an explicit slot discriminator.

`sync:platform-data` must:

- fetch all pages and validate the response contract;
- require `contractVersion` `1`, exactly one default revision per map, and only
  default/selectable revisions;
- validate finite spatial coordinates, control-point array cardinality, default
  versus selectable semantics, revision-scoped challenge references, and holder
  references before writing any generated file;
- preserve and validate Bastion's stable IDs, supported enums, and cross-resource references;
- merge platform metadata by stable ID only, never by localized name;
- generate revision-scoped map/challenge/title-holder data deterministically;
- generate player and map holder data from public player names; reject duplicate
  names or holders without a valid active map-grant projection;
- retain Bastion-owned OverPy implementations while taking title presentation semantics from the platform;
- treat `map_title_achievement.mapTitleRule` as the authority for dynamic map-title map/slot projections; `/titles` supplies presentation metadata only;
- require the map-holder `slotSemantics` discriminator instead of inferring meaning from a null slot;
- update the existing generated title data and
  `src/constants/platform_map_revision_data.opy`;
- compile the normal OverPy entries after the data sync succeeds.

The platform supplies the revision-aware metadata only. Administrators make
revision and progression changes centrally; Bastion does not create revisions,
copy player progress, or resolve platform lifecycle state in a hot loop. This
flow does not add a Release API, a platform build task, runtime HTTP, or dynamic
include generation.

Generated files remain deterministic outputs of the sync and build inputs, not
an independent platform source of truth.

## 6. Data and Build Flow

Agents must preserve this flow:

```text
administrator determines current platform data
→ Bastion sync:platform-data
→ GET Agents current metadata
→ contract, revision, spatial, enum, and reference validation
→ generated-data synchronization
→ tests and OverPy compilation
→ normal Git review and release
```

The platform response is not proof that a change is safe. Repository validation and the normal Git review remain mandatory.

## 7. Gameplay and Performance Invariants

Agents must preserve existing repository-level rules and routed documentation. At minimum:

1. Do not casually reorder entry or include flow.
2. Keep `src/main.opy` and `src/devMain.opy` aligned where applicable.
3. Never introduce waitless repeating logic.
4. Put cheap, selective, slow-changing rule conditions before expensive checks.
5. Prefer sparse evaluation and throttled action-side checks for expensive logic.
6. De-synchronize expensive player initialization when startup spikes are possible.
7. Do not bypass commit hooks or CI gates.
8. Keep inspector-recording and release-performance guidance aligned with existing performance docs.
9. Treat server-load regressions as release blockers.

For detailed rules, route to the existing canonical documents in `docs/agents/` and `docs/modules/` rather than duplicating their full contents here.

## 8. Structured Content Editing

When synchronizing platform metadata:

- use stable IDs, not localized labels, as machine identifiers;
- reject unknown event, map, title, achievement, or challenge references;
- validate platform enum values before updating generated data;
- preserve Bastion-owned array ordering and index-sensitive title behavior;
- keep the sync deterministic and repeatable;
- produce a readable generated-data diff for human review.

The platform must not edit OverPy source or generated files directly. Bastion remains responsible for mapping metadata to its local implementations.

## 9. Compatibility and Contract Changes

Any change to the Agents metadata contract, generated data, or build outputs must include:

- producer and consumer impact analysis;
- `contractVersion` handling;
- migration or compatibility strategy;
- tests for old and new consumers when a compatibility window exists;
- documentation updates in this repository and the consuming repository.

Breaking changes must not be hidden inside routine content work.

## 10. Security and Release Safety

- Do not commit credentials, tokens, private screenshots, QQ identifiers, or OCR artifacts.
- GitHub Actions must use least-privilege permissions.
- A failed compile, sync test, schema check, or integrity check blocks release.
- Rollback must be possible by reverting a repository change and rebuilding the corresponding OverPy output.

## 11. Agent Workflow

Before changing code or running a platform-data build:

1. Classify the task: gameplay, title, event, data export, build, release, migration, or integration.
2. Load only the relevant routed documents and touched dependencies.
3. State the source of truth and external contract affected.
4. Identify risks, rollback path, and generated files.
5. Confirm that the Agents APIs are used only as the current metadata source.

During implementation:

- keep the diff narrowly scoped;
- avoid unrelated formatting or include-order churn;
- update canonical source before generated outputs;
- use existing tools and skills instead of reproducing logic;
- preserve deterministic generation.

Before delivery:

- run the relevant source sync tools;
- run unit and contract tests;
- compile both required OverPy entries when gameplay source is affected;
- run locale and performance checks when applicable;
- document cross-repository follow-up requirements;
- report anything not verified.

## 12. Minimum Definition of Done

A change is complete only when applicable items are satisfied:

- canonical source updated;
- generated outputs synchronized;
- stable identifiers preserved;
- idempotency considered for external requests;
- tests added or updated;
- OverPy build succeeds;
- Agents API and generated-data contracts remain valid;
- documentation updated;
- rollback is clear;
- no public/private data boundary is violated.

## 13. Repository Routing

Keep the existing route-first model:

- architecture and entry rules: `docs/agents/architecture-rules.md`;
- build and validation: `docs/agents/build-validation.md`;
- performance and loops: `docs/agents/performance-loop-safety.md`;
- collaboration and commits: `docs/agents/collaboration-commit.md`;
- documentation synchronization: `docs/agents/doc-sync.md`;
- title system: `docs/modules/08-player-effects-title.md`;
- module-specific implementation: `docs/modules/`.

If this ecosystem guide conflicts with a more specific local safety rule, follow the stricter local rule and report the conflict.
