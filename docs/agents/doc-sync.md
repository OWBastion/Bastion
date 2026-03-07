# Documentation Sync (Canonical)

This document is the canonical rule source for source-code to documentation synchronization.

## Sync Matrix

When source logic changes, update related docs in the same change whenever practical:

1. Entry/include flow -> `docs/modules/01-entry-architecture.md`
2. Constants/localization/env -> `docs/modules/02-env-constants-locales.md`
3. Event pool/effects/allocation -> `docs/modules/03-events-system.md`
4. Bastion AI behavior -> `docs/modules/04-bastion-ai.md`
5. Map point/flow -> `docs/modules/05-map-system.md`
6. Utility subroutine/system -> `docs/modules/06-utilities.md`
7. Hero-specific logic -> `docs/modules/07-heroes.md`
8. Player/effects/title -> `docs/modules/08-player-effects-title.md`
9. Seasonal branch logic -> `docs/modules/09-special-seasonal.md`
10. New external workshop references -> `docs/modules/10-references-workshop-codes.md`

## Quality Gate

If docs are intentionally not updated in the same change, record the reason in change notes.
