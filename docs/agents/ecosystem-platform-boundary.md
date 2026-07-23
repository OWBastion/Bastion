# Ecosystem Platform Boundary.md

> Ecosystem contract version: `1.0`
> Repository: `OWBastion/Bastion`
> Role: authoritative game-content and release repository

## 1. Mission

This repository is the source of truth for the released **Bastion Escape 3** game mode.

Agents working here protect the correctness, performance, buildability, and release integrity of:

- OverPy and Workshop source code;
- random-event implementations and configuration;
- title definitions and player-title source data;
- map, difficulty, localization, and gameplay configuration;
- generated game artifacts and release packages;
- versioned public data snapshots exported for the wider Bastion ecosystem.

This repository is **not** the primary home for public web product development, screenshot review workflows, player identity, OCR orchestration, or administrator dashboards.

## 2. Ecosystem Position

The target system contains four repositories:

| Repository | Ownership |
| --- | --- |
| `OWBastion/Bastion` | Game source, released content, title source, build and release |
| `OWBastion/owbastion.codes` | Public portal, review platform, admin/developer control plane, business data |
| `OWBastion/qqbot` | QQ channel adapter and user notifications |
| `OWBastion/ocrkit` | Stateless screenshot recognition and model lifecycle |

### Hard boundary

`Bastion` owns **published definitions**. `owbastion.codes` may prepare drafts and change requests, but must modify this repository only through reviewable Git branches and pull requests.

No external service may silently mutate released game data or bypass repository CI.

## 3. Source-of-Truth Rules

This repository is authoritative for:

- formal event IDs, event types, weights, durations, and effect implementations;
- title IDs, labels, slots, styles, map mappings, and released grants;
- map and difficulty definitions used by the game;
- localization keys and released player-visible text;
- game version identifiers;
- build scripts, compiler configuration, and release artifacts.

This repository is not authoritative for:

- QQ account bindings;
- screenshot submissions and OCR results;
- review decisions and audit history;
- player-facing submission status;
- balance drafts that have not been merged;
- administrator sessions or permissions;
- OCR training datasets and model binaries.

## 4. Transitional Web UI Rules

`web/title-query` is a migration source for `OWBastion/owbastion.codes`.

Until migration is complete:

- bug fixes and compatibility changes are allowed;
- data-generation scripts must remain deterministic;
- public data output must remain backward compatible unless a versioned schema is introduced;
- do not add major new product features to the legacy page;
- new review, player account, submission, dashboard, or balance-management features belong in `owbastion.codes`.

After migration, this repository should retain only the exporters and contracts required to publish versioned game-data snapshots.

## 5. Published Snapshot Contract

Bastion CI should produce a versioned, machine-readable snapshot for the platform. The target conceptual shape is:

```text
snapshots/<game-version>/
  manifest.json
  titles.json
  players.json
  events.json
  maps.json
  challenges.json
  glossary.json
  allocator.json
```

Every snapshot must include:

- `schema_version`;
- `game_version`;
- source commit SHA;
- generation timestamp;
- hashes for generated files;
- compatibility notes when a schema changes.

The repository now exposes `export:platform-snapshot` for the deterministic
public release manifest and `build:platform-candidate` for platform-triggered
validation. The latter accepts one immutable Candidate fixture or platform URL,
checks stable IDs against the canonical Bastion sources, builds the normal
Workshop entries, and writes a manifest containing the Candidate hash and code
SHA. It does not edit source files or create pull requests.

Snapshot generation must be reproducible from the repository commit. Generated files are outputs, not independent sources of truth.

## 6. External Change Requests

The platform may request changes such as:

- granting or revoking a title;
- modifying structured event parameters;
- enabling or disabling a challenge;
- updating map metadata;
- generating a balance proposal.

Agents must enforce this flow:

```text
structured request
→ schema validation
→ deterministic source edit
→ generated-data synchronization
→ tests and OverPy compilation
→ pull request with evidence
→ human review
→ merge
→ release and snapshot publication
```

Never accept a platform request as proof that a change is safe. Repository validation remains mandatory.

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

When implementing platform-generated edits:

- edit canonical source files, never only generated JSON;
- use stable internal keys, not localized labels, as machine identifiers;
- reject unknown event, map, title, or player keys;
- preserve array ordering and index-sensitive title behavior;
- make edits idempotent;
- include a stable external request or submission ID in the PR description or commit metadata;
- do not create duplicate grants when a request is retried;
- produce a readable diff for human review.

Arbitrary OverPy source editing from the web platform is out of scope unless an explicit, separately reviewed sandbox design is adopted.

## 9. Compatibility and Contract Changes

Any change to exported JSON, title-grant input, event metadata, or build outputs must include:

- producer and consumer impact analysis;
- schema-version handling;
- migration or compatibility strategy;
- tests for old and new consumers when a compatibility window exists;
- documentation updates in this repository and the consuming repository.

Breaking changes must not be hidden inside routine content work.

## 10. Security and Release Safety

- Do not commit credentials, tokens, private screenshots, QQ identifiers, or OCR artifacts.
- Do not expose administrator-only data in public snapshots.
- GitHub Actions must use least-privilege permissions.
- External automation must open PRs rather than push directly to protected release branches.
- A failed compile, sync test, schema check, or integrity check blocks release.
- Rollback must be possible by reverting a repository change and rebuilding the corresponding snapshot.

## 11. Agent Workflow

Before changing code:

1. Classify the task: gameplay, title, event, data export, build, release, migration, or integration.
2. Load only the relevant routed documents and touched dependencies.
3. State the source of truth and external contract affected.
4. Identify risks, rollback path, and generated files.

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
- snapshot/export contract remains valid;
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
