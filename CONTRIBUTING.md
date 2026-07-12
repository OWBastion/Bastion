# Contribution Guide / 贡献指南

Thank you for contributing to Bastion Escape 3.  
感谢你为躲避堡垒3做出贡献。

This repository is an Overwatch Workshop project powered by [OverPy]. Our core goals are:  
本仓库是基于 [OverPy] 的守望先锋地图工坊项目，核心目标是：
- Make low-risk gameplay changes / 以低风险方式迭代玩法
- Keep `main/devMain` dual-entry consistency / 保持 `main/devMain` 双入口一致性
- Avoid server-load regressions / 避免引入服务器负载回归

Please read these first before contributing:  
提交前建议先阅读：
- `README.md`
- `AGENTS.md`
- `docs/improve-server-stability.md`
- `docs/modules/README.md`

## 1. Required Tools / 必备工具

- [Visual Studio Code](https://code.visualstudio.com/download)  
  Recommended editor for `.opy` source files / 推荐用于编辑 `.opy` 源码
- [OverPy]  
  Toolchain for compiling OverPy source to Workshop script (repo scripts use the `overpy` CLI) / 用于将 OverPy 源码编译为工坊代码（仓库脚本使用 `overpy` CLI）
- [Git](https://git-scm.com/downloads)  
  Version control / 版本控制
- [GitHub](https://github.com/)  
  Issue tracking and Pull Requests / 问题跟踪与 PR 协作
- [pnpm](https://pnpm.io/installation)  
  Used by repository scripts / 仓库脚本使用的包管理器

## 2. Setup Instructions / 环境准备

1. Install VS Code and OverPy-related tooling.  
   安装 VS Code 与 OverPy 相关工具。
2. Clone this repository and open it in VS Code.  
   克隆仓库并在 VS Code 中打开。
3. Install dependencies:  
   安装依赖：

```bash
pnpm install
```

4. Run a local build to verify setup:  
   运行本地构建验证环境：

```bash
pnpm run build
```

5. Run locale key checks before your first PR:  
   在首次 PR 前执行本地化键检查：

```bash
./tools/check_locale_keys.sh
```

## 3. Ownership / 模块归属

Find the owning module before editing:  
先定位改动归属模块：
- `src/bastion/`: Bastion AI and behavior / Bastion AI 与行为
- `src/events/`: event trigger/allocation/effects / 随机事件触发、分配与效果
- `src/config/`: event config (weights, durations, toggles) / 事件配置（权重、时长、开关）
- `src/map/`: map points and flow / 地图点位与流程
- `src/heroes/`: hero abilities and restrictions / 英雄能力与限制
- `src/utilities/`: common utilities / 通用工具逻辑
- `src/player/`: player state/init/achievements / 玩家状态、初始化、成就
- `src/effects/`: gameplay and visual effects / 玩法与视觉效果
- `src/env/`: env and version macros / 环境与版本宏
- `src/locales/`: localization text / 本地化文本

## 4. Architecture Constraints / 架构约束（必须遵守）

1. Include order in `src/main.opy` and `src/devMain.opy` is meaningful; do not reorder casually.  
   `src/main.opy` 与 `src/devMain.opy` 的 include 顺序有意义，不要随意重排。
2. Keep both entries structurally aligned whenever practical. If only one is changed, explain why in commit/PR notes.  
   双入口应尽量结构对齐；如果只改其中一个，需在提交说明中解释原因。
3. Any event change must check both configs:  
   涉及事件增删改时，必须同时检查：
   - `src/config/eventConfig.opy`
   - `src/config/eventConfigDev.opy`
4. Seasonal/special-event logic should live in dedicated branches, not in the mainline general logic.  
   季节/活动特化逻辑应放到专用分支，不直接进入主线通用逻辑。
5. Do not use `shared` in project-owned names to describe common configuration or behavior. Use responsibility-based names, `BASE` for base macros, and `MAIN` / `DEV` for entry-specific overrides.  
   项目自产文件、目录、宏和标识符不得使用 `shared` 表示共用配置或行为；应使用职责名称，基础宏使用 `BASE`，入口差异使用 `MAIN` / `DEV`。

## 5. Performance Rules / 性能与稳定性硬规则

1. No waitless loops (`Loop If`, `while`, batch loops, etc.).  
   禁止无 `wait` 的循环（包括 `Loop If` / `while` / 批量循环场景）。
2. Order conditions by cheap short-circuit checks first.  
   条件顺序遵循“低成本优先、可短路优先”。
3. Be careful with heavy array/distance operations in `Ongoing - Each Player`.  
   在 `Ongoing - Each Player` 中谨慎使用数组遍历、距离计算等重操作。
4. Split large action bursts across frames (insert short `wait`).  
   单帧内动作过多时，拆帧执行（插入短 `wait`）。
5. Reuse existing rules/macros/utilities when possible.  
   能复用现有规则、宏、工具时，不新增重复规则。

## 6. General Workflow / 通用开发流程

1. Find or create an issue describing the change scope.  
   先找到或创建对应 issue，明确改动范围。
2. Create a dedicated branch for the task.  
   为任务创建独立分支。
3. Make minimal-scope changes in the owning module.  
   在归属模块内做最小范围改动。
4. Rebuild and validate locally.  
   本地重新构建并验证。
5. Commit with a clear message and open a PR.  
   使用清晰提交信息并发起 PR。
6. Address review feedback and keep the branch focused.  
   根据 Review 反馈迭代，并保持分支聚焦单一目标。

## 7. Coding Style Guidelines / 代码风格建议

This project follows OverPy/Python-like style with repository-specific constraints:  
本项目遵循 OverPy/Python 风格，并补充仓库约束：

1. Prefer descriptive names and consistent naming within each module.  
   使用语义明确的命名，并保持模块内一致性。
2. Prefer constants/config values over scattered magic numbers.  
   优先使用常量/配置，避免散落魔法数字。
3. Reuse existing macros/subroutines/utilities instead of copying large blocks.  
   优先复用现有宏/子程序/工具，避免复制大段逻辑。
4. Do not casually rename existing rules/macros/constants unless required.  
   非必要不要重命名既有规则、宏或常量。
5. Avoid formatting-only or include-order-only diffs unrelated to the task.  
   避免与任务无关的纯格式化或 include 顺序改动。

## 8. Event Changes Checklist / 事件改动清单

When adding/changing events, at minimum:  
新增或调整事件时，至少完成：
1. Sync definitions, weights, durations, toggles in `config/eventConfig*.opy`.  
   在 `config/eventConfig*.opy` 同步定义、权重、时长、开关。
2. Implement or update behavior in `events/effects/`.  
   在 `events/effects/` 实现或更新具体行为。
3. Sync localization and display formatting in `locales/`.  
   在 `locales/` 同步文本与显示格式。
4. Verify allocation/sampling flow in `events/allocation/` remains intact.  
   验证 `events/allocation/` 采样与分配流程未被破坏。

## 9. Map Changes Checklist / 地图改动清单

1. Keep map points/flow in the corresponding `src/map/` file.  
   点位与流程逻辑放在对应 `src/map/` 文件。
2. Update `src/map/setup_all_map.opy` when adding new maps.  
   新增地图时更新 `src/map/setup_all_map.opy` 聚合入口。
3. Verify teleport/checkpoint compatibility with `mapDetection` and settlement flow.  
   联动验证传送/检查点与 `mapDetection`、结算逻辑兼容。

## 10. Build & Validation / 本地构建与校验

Install dependencies / 安装依赖：

```bash
pnpm install
```

Build both entries / 构建双入口：

```bash
pnpm run build
```

Build separately / 分别构建：

```bash
pnpm run build:main
pnpm run build:dev
```

Release build (EN + ZH) / 发布构建（中英双语）：

```bash
pnpm run build:release
```

Locale key consistency check (required before commit) / 本地化键一致性检查（提交前必跑）：

```bash
./tools/check_locale_keys.sh
```

## 11. Pre-commit Checklist / 提交前检查

1. Confirm whether both `main.opy` and `devMain.opy` need updates.  
   是否需要同步更新 `main.opy` 与 `devMain.opy`。
2. Ensure no waitless loops were introduced.  
   是否引入了无 `wait` 循环。
3. Ensure condition ordering is cost-aware.  
   条件是否按低成本优先排序。
4. Ensure event config/implementation/text are all synced.  
   事件改动是否已同步配置、实现与文案。
5. Ensure no unrelated formatting/reordering diffs.  
   是否出现无关格式化或重排。
6. Ensure seasonal logic is moved to dedicated branches if needed.  
   季节性内容是否应转入专用分支。
7. Run and pass `./tools/check_locale_keys.sh`.  
   `./tools/check_locale_keys.sh` 是否通过。

## 12. Commit / PR Suggestions / Commit / PR 建议

Recommended commit subjects / 建议提交信息：
- `feat(events): add xxx effect and config sync`
- `fix(map): correct checkpoint flow on oasis`
- `refactor(utilities): reuse cooldown helper`
- `docs(modules): update event-system notes`

PR description should include / PR 描述建议包含：
1. What changed and why / 改动内容与动机
2. Affected entries (`main.opy` / `devMain.opy`) / 影响入口
3. Event/map linkage points / 事件或地图联动点
4. Performance risk assessment / 性能风险评估
5. Local validation results / 本地验证结果

## 13. Documentation Sync / 文档同步要求

When source logic changes, update related docs in the same change when practical:  
当源码逻辑发生变化时，请尽量在同一提交中同步更新对应文档：
- Entry/include flow: `docs/modules/01-entry-architecture.md`  
  入口/include 流程：`docs/modules/01-entry-architecture.md`
- Constants/locales/env: `docs/modules/02-env-constants-locales.md`  
  常量/本地化/env：`docs/modules/02-env-constants-locales.md`
- Events system: `docs/modules/03-events-system.md`  
  事件系统：`docs/modules/03-events-system.md`
- Bastion AI: `docs/modules/04-bastion-ai.md`  
  Bastion AI：`docs/modules/04-bastion-ai.md`
- Map system: `docs/modules/05-map-system.md`  
  地图系统：`docs/modules/05-map-system.md`
- Utilities: `docs/modules/06-utilities.md`  
  工具系统：`docs/modules/06-utilities.md`
- Heroes: `docs/modules/07-heroes.md`  
  英雄逻辑：`docs/modules/07-heroes.md`
- Player/effects/title: `docs/modules/08-player-effects-title.md`  
  玩家/效果/称号：`docs/modules/08-player-effects-title.md`
- Seasonal branch: `docs/modules/09-special-seasonal.md`  
  季节分支：`docs/modules/09-special-seasonal.md`
- External references: `docs/modules/10-references-workshop-codes.md`  
  外部参考：`docs/modules/10-references-workshop-codes.md`

## 14. Recommended Reading Order / 建议阅读顺序

For first-time contributors / 首次贡献者建议按以下顺序阅读：
1. `README.md`
2. `src/main.opy`
3. `src/devMain.opy`
4. `src/config/eventConfig.opy`
5. `src/events/` and `src/utilities/`
6. `docs/improve-server-stability.md`

[OverPy]: https://www.npmjs.com/package/overpy
