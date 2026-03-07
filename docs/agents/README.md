# AI Agent Rules Index

This directory is the canonical source for agent collaboration rules in this repository.

## How To Read

Read by task route, not by full directory preload:

1. Read touched files first.
2. Read direct dependencies second.
3. Read only the routed rule doc below.

Do not default-load all files under `docs/agents/`.

## Route Index

- Entry architecture and `main/devMain` consistency:
  - `architecture-rules.md`
- Build commands, CI, and validation checks:
  - `build-validation.md`
- Performance guardrails and loop safety:
  - `performance-loop-safety.md`
- Collaboration boundaries and commit hygiene:
  - `collaboration-commit.md`
- Source-to-doc synchronization:
  - `doc-sync.md`
- Context routing and conditional loading:
  - `context-routing.md`

## Canonical Mapping

Each rule family has one canonical file:

1. Architecture consistency -> `architecture-rules.md`
2. Build and validation -> `build-validation.md`
3. Performance and loop safety -> `performance-loop-safety.md`
4. Collaboration and commit hygiene -> `collaboration-commit.md`
5. Documentation synchronization -> `doc-sync.md`
6. Context routing and conditional loading -> `context-routing.md`

If a document needs to mention a rule from another family, link to the canonical file instead of duplicating details.
