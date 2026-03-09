# AGENTS.md

This file is the minimal entrypoint for AI agents. Detailed rules are canonical in `docs/agents/*.md`.

## Goals

- Keep gameplay changes low risk.
- Keep `src/main.opy` and `src/devMain.opy` aligned.
- Prevent server load regressions.
- Use route-first, conditional context loading (no full-context injection by default).

## Minimal Red Lines

1. Do not reorder entry include flow casually.
2. Do not bypass commit hooks (`git commit --no-verify` is forbidden).
3. Do not implement seasonal/event-specific content on current mainline.
4. Do not preload all docs; read only routed files for the task.

## Task-to-Doc Routing

Read only the documents needed by task type:

| Task type | Read first | Then read if needed |
| --- | --- | --- |
| Entry/include/order updates, `main/devMain` parity | `docs/agents/architecture-rules.md` | `docs/modules/01-entry-architecture.md` |
| Build/CI/check commands and validation flow | `docs/agents/build-validation.md` | `.github/workflows/ci-build.yml`, `.github/workflows/release.yml`, `.github/workflows/pages-title-query.yml` |
| Title source sync / title-query page updates | `docs/modules/08-player-effects-title.md` | `README.md`, `tools/sync-title-data.mjs`, `.github/workflows/pages-title-query.yml` |
| Performance tuning, loops, Ongoing rules | `docs/agents/performance-loop-safety.md` | `docs/improve-server-stability.md`, `docs/Loops.md` |
| PR/commit hygiene and AI collaboration boundaries | `docs/agents/collaboration-commit.md` | this file (`AGENTS.md`) |
| Doc sync and module documentation updates | `docs/agents/doc-sync.md` | `docs/modules/README.md` |
| Context loading strategy and scope declaration | `docs/agents/context-routing.md` | `docs/agents/README.md` |

## On-Demand Read Protocol

1. Layer 1: touched file(s) only.
2. Layer 2: direct dependencies (include/config/constants used by Layer 1).
3. Layer 3: routed rule docs in `docs/agents/` only.
4. Never default-load all `docs/agents/*` or all `docs/modules/*`.

## Canonical Rule Index

Each rule family has exactly one canonical document:

1. Architecture consistency and entry constraints -> `docs/agents/architecture-rules.md`
2. Build and validation process -> `docs/agents/build-validation.md`
3. Performance and loop safety -> `docs/agents/performance-loop-safety.md`
4. Collaboration and commit hygiene -> `docs/agents/collaboration-commit.md`
5. Documentation synchronization -> `docs/agents/doc-sync.md`
6. Context routing and conditional loading -> `docs/agents/context-routing.md`

If a rule is referenced elsewhere, keep only a short pointer and do not duplicate full rule text.

## Workflow Command Pointers

- CI-parity install: `pnpm install --frozen-lockfile`
- Core compile validation: `pnpm run build`
- Entry-specific compile validation: `pnpm run build:main` and `pnpm run build:dev`
- Title data sync and validation: `pnpm run sync:title-data` then `pnpm run test:title-data-sync`
- Title query page build: `pnpm run build:title-query` (or `pnpm run build:pages` in CI)
- Release artifact build (local parity): `pnpm run build:release`
- Manual env version bump (release helper): `pnpm run bump:env-version`
- Release trigger: push to `main` (workflow auto-runs `pnpm run bump:env-version`, builds release artifacts, tags `v{VERSION}`, and publishes GitHub Release)
- TODO: Document one canonical local decompile verification command once standardized.
