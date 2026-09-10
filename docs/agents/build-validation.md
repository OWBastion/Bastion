# Build and Validation (Canonical)

This document is the canonical rule source for build commands and validation workflow.

## Canonical Commands

1. `pnpm run build` (sync current platform metadata, then build every canonical profile, locale, and environment combination)
2. `pnpm run build:cn:zh`
3. `pnpm run build:external:en`
4. `pnpm run build:external:zh`
5. `pnpm run build:dev:cn:zh`
6. `pnpm run build:release` (sync current platform metadata, then build the CN zh-CN and External en-US release outputs)

## CI References

1. PR build workflow: `.github/workflows/ci-build.yml`
2. Release workflow: `.github/workflows/release.yml` (triggered by push to `main` when `src/**` changes, or by manual `workflow_dispatch`; auto-bumps `src/env/env.opy` VERSION, pushes bump commit, tags `v{VERSION}`, and publishes release)

## Required Checks Before Completion

1. Run the relevant build validation for the changed scope.
2. Run `./tools/check_locale_keys.sh` when source/localization/event text may be affected.
3. Ensure no unrelated formatting/reordering noise is included in final changes.
