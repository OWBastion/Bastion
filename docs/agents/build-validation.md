# Build and Validation (Canonical)

This document is the canonical rule source for build commands and validation workflow.

## Canonical Commands

1. `pnpm run build` (sync current platform metadata, then build `build:cn:zh`, `build:dev:cn:zh`, `build:external:en`, `build:external:zh`)
2. `pnpm run build:cn:zh`
3. `pnpm run build:external:en`
4. `pnpm run build:external:zh`
5. `pnpm run build:dev:cn:zh`
6. `pnpm run build:release` (sync current platform metadata, then build the CN zh-CN and External en-US release outputs)

## CI References

1. PR build workflow: `.github/workflows/ci-build.yml` (runs `pnpm run typecheck` and `pnpm run tools:test`, then the platform sync and builds; the sync validates only the platform data Bastion consumes)
2. Release workflow: `.github/workflows/release.yml` (triggered by push to `main` when `src/**` changes, or by manual `workflow_dispatch`; auto-bumps `src/env/env.opy` VERSION, pushes bump commit, tags `v{VERSION}`, and publishes release)

## Reading Build and Cost Output

Do not read `build/*.ow` or the full output of `wright inspect cost --all` directly. Summarize them with a script and read only the summary. Why: one build output is hundreds of KB, so reading it consumes the context without adding evidence that a summary cannot give.

## Required Checks Before Completion

1. Run the relevant build validation for the changed scope.
2. Run `./tools/checkLocaleKeys.sh` when source/localization/event text may be affected.
3. Ensure no unrelated formatting/reordering noise is included in final changes.
