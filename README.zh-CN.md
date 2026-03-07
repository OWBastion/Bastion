# 躲避堡垒3

![GitHub License](https://img.shields.io/github/license/Teakowa/Bastion)
[![CI Build Check](https://github.com/Teakowa/Bastion/actions/workflows/ci-build.yml/badge.svg)](https://github.com/Teakowa/Bastion/actions/workflows/ci-build.yml)

[English](README.md) | 简体中文

本项目是基于 [OW2 Bastion Escape](https://workshop.codes/QF8RN) 的后续开发版本。

我们保留了经典的 躲避堡垒 玩法，并为 Overwatch 2 进行了重构与扩展。

玩家需要协作潜行、突破 Bastion 看守，并在各地图中抵达终点；随着进度推进，挑战会逐步提升。该模式也常被称为 逃离监狱 / CCTV。

当前版本新增内容如下：

## 随机事件系统

游戏开始 2 分钟后，系统会为每位存活玩家随机分配事件。此后每次事件结束后约 30-45 秒会再次抽取新事件，直到对局结束。

事件分为增益、减益与机制三类。你可能获得强力帮助，也可能遭遇致命诅咒。目标依旧不变：活下来并到达终点，但你需要在堡垒的火力压制下持续应对不断出现的“惊喜”或“惊吓”。

# 三合一挑战

该模式将 占领要点 地图池中的三张小图整合为一张长流程地图。玩家需依次完成三个阶段并抵达最终终点。若中途阵亡，将在当前阶段对应的重生室复活。

支持地图：
    - 漓江塔
    - 萨摩亚
    - 绿洲城
    - 釜山

## 新难度：地狱

- AI 堡垒的伤害提高
- AI 堡垒会发射榴弹
- AI 堡垒的减伤无法关闭
- 无法跳过英雄

## 第三人称支持

玩家可在重生室中进行第一人称与第三人称的自由切换，也可以通过 互动+近战 打开游戏内菜单进行切换

## 自动重开

可在地图工坊设置中配置，最长 4 个半小时

## 全英雄威能充能

可在地图工坊设置中启用

## 参与开发

- 本项目支持 AI 协助开发，架构与协作规范请优先阅读 `AGENTS.md`。
- `src/main.opy` 与 `src/devMain.opy` 应尽量保持结构对齐。
- 修改事件逻辑时，请同步检查：
  - `src/config/eventConfig.opy`
  - `src/config/eventConfigDev.opy`
- 性能与稳定性规则见 `docs/improve-server-stability.md`：
  - 避免无 `wait` 循环
  - 持续规则默认使用条件区门控（约每 0.016s 自上而下短路判定）
  - 条件判断优先“高筛选率且低成本在前”，而不是“最复杂计算在前”
  - 尽量避免在 `Ongoing - Each Player` 中引入重计算
  - 仅在需要手动控频或多个子判断复用上级门槛时，才用动作区 `If + wait`
  - 同门槛规则按声明顺序执行，先声明先执行动作
- 模块文档位于 `docs/modules/`，涉及源码改动时应尽量同步更新对应文档。
- 以最小改动为原则，避免无关 include 顺序调整或大范围格式化。

### CI 自动发布（pnpm）

项目已支持通过 GitHub Actions 在推送 `v*` 标签时自动编译并发布 Workshop 文件：

- 工作流文件：`.github/workflows/release.yml`
- 发布产物（双语言）：
  - `build/main.en-US.ow`
  - `build/devMain.en-US.ow`
  - `build/main.zh-CN.ow`
  - `build/devMain.zh-CN.ow`
- 包管理器：`pnpm`

本地构建：

```bash
pnpm install
pnpm run build
```

构建脚本已切换为 npm 包 `overpy` 的 CLI（`overpy compile ...`）。

分别构建双入口：

```bash
pnpm run build:main
pnpm run build:dev
```

称号查询页：

```bash
pnpm run test:title-data-sync
pnpm run sync:title-data
pnpm run build:title-query
```

静态查询页与游戏内称号源块均由 `tools/sync-title-data.mjs` 基于 `data/title-source.json` 自动生成，并通过 `.github/workflows/pages-title-query.yml` 部署到 GitHub Pages。

发布用双语言构建：

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
