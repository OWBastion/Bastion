# Build and Validation (Canonical)

This document is the canonical rule source for build commands and validation workflow.

## Canonical Commands

1. `pnpm run build` (build both entries)
2. `pnpm run build:main`
3. `pnpm run build:dev`
4. `pnpm run build:main:en`, `pnpm run build:dev:en`
5. `pnpm run build:main:zh`, `pnpm run build:dev:zh`
6. `pnpm run build:release`

## CI References

1. PR build workflow: `.github/workflows/ci-build.yml`
2. Release workflow: `.github/workflows/release.yml` (triggered by push to `main`; auto-bumps `src/env/env.opy` VERSION, pushes bump commit, tags `v{VERSION}`, and publishes release)

## Required Checks Before Completion

1. Run the relevant build validation for the changed scope.
2. Run `./tools/check_locale_keys.sh` when source/localization/event text may be affected.
3. Ensure no unrelated formatting/reordering noise is included in final changes.
