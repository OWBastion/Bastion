# 01. 入口与主架构

## 双入口模型

- 生产入口：`src/main.opy`
- 开发入口：`src/devMain.opy`

两者结构高度一致，差异主要集中在：

- 头部环境文件：`env/env.opy` vs `env/env_dev.opy`
- 事件目录顺序入口：`config/eventCatalogMain.opy` vs `config/eventCatalogDev.opy`（注册定义共用 `config/eventCatalog.opy`）
- 英雄设置入口：`heroes/settings/team_rules.opy` + `heroes/settings/all_teams.opy`
- 调试能力与默认配置（`DEBUG`、workshop 默认值等）

## 入口执行分层（按 include 顺序）

1. 环境/本地化/宏
2. 全局变量与玩家变量声明
3. 基础系统：地图检测、黑名单、游戏设置初始化、称号库（由平台 Agents API 同步生成）、事件开关
4. 功能系统：英雄规则、事件配置、抽样器、业务服务（`map/`、`blacklist/`、`player/`、`env/`、`bastion/`、`events/effects`、`events/integrity`、`events/lifecycle` 与 `utilities/system` 遗留项按固定槽位交错 include）
5. 事件执行层：分配器 + buff/debuff/mech 规则
6. 地图层 + 堡垒 AI
7. 效果层：HUD、特效、玩家状态可视化
8. 玩家层：初始化、进度、成就
9. 菜单层：`menu/`（公共框架 + 玩家/房主/开发职责拆分）

## 服务 include 约定（main/devMain 同步）

- 入口顶部宏 include 固定为：`utilities/dev_support/macros.opy`
- `core.opy` 为纯有序组装表，不含内联规则；中段服务按固定槽位交错 include 各属主模块，槽位顺序不可重排
- `events/lifecycle/resetPlayerEventState.opy` 固定 include 在 `player/status.opy` 之前，维持子程序索引与规则展开顺序
- 菜单 include 固定在末尾位置：`menu/frame.opy` -> `menu/hero.opy` -> `menu/dev/*` -> `menu/player.opy` -> `menu/host/*` 等按既有槽位交错展开，跨角色交错顺序不可重排

## 核心全局数据结构

入口文件通过共享/增量变量 include 形成完整的 `globalvar` / `playervar` 索引表，重点包含：

- 地图点位：`bastionPosition`, `endPosition`, `controlJumpPosition`, `controlRespawnPosition`
- 事件池：按统一 ID 直接注册的一维 `event*` 元数据数组与标量 `eventCatalogId` 目录
- 玩家事件态：`eventId`, `eventType`, `eventDuration`, `eventCount`, `eventLucky`
- 进度态：`heroNumber`, `progressionDeathCount`, `runDeathCount`, `isWinner`
- 扩展态：`heart_steel`, `eventSize`, `phase_trigger`, `earnedAchievements`

## 主循环机制

玩法循环规则已归位职责模块，`core.opy` 仅保留有序组装：

- 控制点检查点推进与回位：`map/controlJump.opy`
- 终点结算与胜者充能：`player/finishSettlement.opy`
- 对局码生成：`events/integrity/masteryRunCode.opy`
- 自动重开：`utilities/system/autoReboot.opy`

这些规则与 `map/`、`player/`、`events/` 子模块深度联动。

## Workshop 版本生效模型

- 仓库代码更新后，需要重新编译并将新脚本手动粘贴/导入到 Workshop code。
- 已在运行中的房间不会热更新为新脚本；旧房间会持续运行创建该房间时的脚本版本。
- 新版本仅在使用新 code 新建房间后生效。
- 因此跨版本运行态在线迁移（例如同房间内将 legacy 标量状态迁移为新数组状态）不属于主线兼容要求。

## 关键注意点

- include 顺序敏感，不能随意重排。
- `settings.heroes` 已从入口内联块拆分到 `heroes/settings/`，新增英雄设置优先改职责明确的基础配置文件；main、dev 与 en-US 入口直接使用同一组英雄设置。
- 新增全局变量时需谨慎维护索引稳定性，避免覆盖既有槽位。
- 修改业务逻辑时改职责属主目录下的真实文件；`utilities/system/` 只承载无单一属主的系统机制，不再新增业务实现。
