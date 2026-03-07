# Bastion Escape 3

![GitHub License](https://img.shields.io/github/license/Teakowa/Bastion)
[![CI Build Check](https://github.com/Teakowa/Bastion/actions/workflows/ci-build.yml/badge.svg)](https://github.com/Teakowa/Bastion/actions/workflows/ci-build.yml)

English | [简体中文](README.zh-CN.md)

This is a continued development build based on [OW2 Bastion Escape](https://workshop.codes/QF8RN).

It preserves the classic Bastion Escape gameplay and expands it for Overwatch 2.

Players cooperate to sneak past Bastion guards and reach each map's finish line. The challenge increases over time. This mode is also known as Prison Escape / CCTV.

We have added the following content:

## Random Events

Two minutes after the match starts, the system assigns a random event to each surviving player. After each event ends, another one is drawn in about 30-45 seconds until the match ends.

Events are split into buffs, debuffs, and mechanics. Some events help, some are deadly. The goal is unchanged: survive and reach the finish line, while handling constant "surprises" under Bastion fire.

# 3-in-1 Challenge

This mode combines three Control maps into one long run. Players must clear all three phases and reach the final finish line. If a player dies, they respawn in the current phase's respawn room.

Supported Maps:
    - Lijiang Tower
    - Samoa
    - Oasis
    - Busan

## New Difficulty: Inferno

- AI Bastions deal increased damage
- AI Bastions launch grenades
- AI Bastion damage reduction cannot be disabled
- Hero selection cannot be skipped

## Third-Person Support

Players can switch between first-person and third-person in the respawn room, or open the in-game menu via `Interact + Melee` to switch.

## Auto-Restart

Configurable in Workshop settings, up to 4.5 hours.

## Full Hero Perk Charge

Enable in Workshop settings.

## Development Notes

- This project supports AI-assisted development. Read `AGENTS.md` first for architecture and collaboration rules.
- Keep `src/main.opy` and `src/devMain.opy` structurally aligned whenever practical.
- When changing event logic, validate both:
  - `src/config/eventConfig.opy`
  - `src/config/eventConfigDev.opy`
- Follow server stability rules in `docs/improve-server-stability.md`:
  - Avoid loops without `wait`
  - Default to condition-block gating for continuous rules (`~0.016s` top-to-bottom short-circuit)
  - Put high-selectivity low-cost conditions before expensive checks
  - Avoid heavy computation in `Ongoing - Each Player` whenever possible
  - Use action-side `If + wait` checks only for explicit frequency control or shared-gate sub-checks
  - Rules with identical gates are execution-order sensitive (earlier declaration runs first)
- Module docs are under `docs/modules/`. Update related docs together with source changes when relevant.
- Keep changes minimal; avoid unrelated include-order changes or broad formatting-only diffs.

### CI Auto Release (pnpm)

This project supports automatic compile-and-release of Workshop files via GitHub Actions when pushing `v*` tags:

- Workflow file: `.github/workflows/release.yml`
- Release artifacts (dual-language):
  - `build/main.en-US.ow`
  - `build/devMain.en-US.ow`
  - `build/main.zh-CN.ow`
  - `build/devMain.zh-CN.ow`
- Package manager: `pnpm`

Local build:

```bash
pnpm install
pnpm run build
```

Build scripts use the `overpy` CLI (`overpy compile ...`) from the npm package.

Build each entry independently:

```bash
pnpm run build:main
pnpm run build:dev
```

Title query page:

```bash
pnpm run test:title-data-sync
pnpm run sync:title-data
pnpm run build:title-query
```

The static page and in-game title source blocks are generated from `data/title-source.json` via `tools/sync-title-data.mjs`, and the page is deployed by `.github/workflows/pages-title-query.yml`.

Dual-language release build:

```bash
pnpm run build:release
```

# Credits

Tower escape mod made by: WOBBLYOW#2981, NOTBANANA#21520 and PIRATEBOOT#2133.  
Hanamura made by: REYDI#21629 (not in current version though)  
Blizzard World, Eichenwalde, Hollywood, Junkertown, Paris, Temple of Anubis by DATZENYAT#2990.  
Bastion Escape 2 by EfeDursun125#2815  
OW2 Bastion Escape by BearWhoLived#1783

# License

[MIT License](./LICENSE)
