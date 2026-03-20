# 01. 入口与主架构

## 双入口模型

- 生产入口：`src/main.opy`
- 开发入口：`src/devMain.opy`

两者结构高度一致，差异主要集中在：

- 头部环境文件：`env/env.opy` vs `env/env_dev.opy`
- 事件配置入口：`config/eventConfig.opy` vs `config/eventConfigDev.opy`
- 英雄设置入口：`heroes/settings/main_heroes_settings.opy` vs `heroes/settings/dev_heroes_settings.opy`
- 调试能力与默认配置（`DEBUG`、workshop 默认值等）

## 入口执行分层（按 include 顺序）

1. 环境/本地化/宏
2. 全局变量与玩家变量声明
3. 基础系统：地图检测、黑名单、游戏设置初始化、称号库（由 `data/title-source.json` 同步生成）、事件开关
4. 功能系统：英雄规则、事件配置、抽样器、工具层（`utilities/system` -> `utilities/event_core`）
5. 事件执行层：分配器 + buff/debuff/mech 规则
6. 地图层 + 堡垒 AI
7. 效果层：HUD、特效、玩家状态可视化
8. 玩家层：初始化、进度、成就
9. 开发层：`utilities/dev_support/devTool.opy`

## Utilities include 约定（main/devMain 同步）

- 入口顶部宏 include 固定为：`utilities/dev_support/macros.opy`
- 中段 utilities include 分两组，顺序固定：
  - `utilities/system/*`
  - `utilities/event_core/*`
- 开发工具 include 固定在靠后位置：`utilities/dev_support/devTool.opy`
- 旧路径 `utilities/*.opy` 为兼容 shim，过渡期可被外部分支引用，但入口文件应优先使用新路径

## 核心全局数据结构

入口文件通过共享/增量变量 include 形成完整的 `globalvar` / `playervar` 索引表，重点包含：

- 地图点位：`bastionPosition`, `endPosition`, `controlJumpPosition`, `controlRespawnPosition`
- 事件池：`buffEvent/debuffEvent/mechEvent` 与对应 `*Id`
- 玩家事件态：`eventId`, `eventType`, `eventDuration`, `eventCount`, `eventLucky`
- 进度态：`heroNumber`, `progressionDeathCount`, `runDeathCount`, `isWinner`
- 扩展态：`heart_steel`, `eventSize`, `phase_trigger`, `earnedAchievements`

## 主循环机制

入口内除 include 外还定义了少量全局规则，用于：

- 未被锁定时加速
- 三图/控制点切图传送
- 到达终点后的英雄推进或胜利结算
- 自动重开

这些规则与 `map/`、`player/`、`utilities/` 子模块深度联动。

## 关键注意点

- include 顺序敏感，不能随意重排。
- `settings.heroes` 已从入口内联块拆分到 `heroes/settings/`，新增英雄设置优先改 shared 文件，入口差异通过 `main_overrides.opy` / `dev_overrides.opy` 处理。
- 新增全局变量时需谨慎维护索引稳定性，避免覆盖既有槽位。
- 修改 utilities 时，优先改分组目录下真实文件，不要把业务逻辑写回旧路径 shim。
