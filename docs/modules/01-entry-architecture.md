# 01. 入口与主架构

## 三入口模型

- 生产入口：`src/main.opy`（CN）
- 开发入口：`src/devMain.opy`（CN，开发调试）
- 外部入口：`src/externalMain.opy`（external，不含 CN 专属功能）

三者共享同一套组装骨架，差异由头部 `ENTRY_*` 定义与 `composition/` profile 文件表达：

- 头部环境文件：`env/env.opy` vs `env/env_dev.opy`
- Profile 差异宏：`composition/profile-cn.opy` vs `composition/profile-external.opy`
- 事件目录顺序入口：`events/catalog/eventCatalogMain.opy`（main + externalMain）vs `events/catalog/eventCatalogDev.opy`（devMain），注册定义共用 `events/catalog/eventCatalog.opy`
- CN 专属功能尾部：仅 `main`/`devMain` 直接 include 称号实现、`menu/title.opy` 和成就模块
- 调试能力与默认配置（`DEBUG`、workshop 默认值等）

## 显式入口组装

三个入口直接列出编译定义、`settings {}`、变量声明、初始化、运行模块和菜单的引入顺序。include 路径以入口所在的 `src/` 为基准，顶层不依赖某个已引入 settings 文件留下的目录上下文。

`composition/` 保留实际定义：`mode_constants.opy` 和 CN/external 的 `PROFILE_*` 差异宏。profile 文件只定义策略宏，不再隐式引入称号数据或功能模块。

事件效果、地图和英雄聚合仍分别维护自己的有序列表。不要将这些有实际职责的聚合替换成通用装配框架。

三个入口中的公共段按同一顺序维护；修改公共引入、settings、extensions 或声明时同步检查三个入口，保留各自的 `ENTRY_*`、事件目录顺序、profile 和编译钩子差异。入口允许适度重复，以便直接追踪编译输入。

## 入口执行分层（按 include 顺序）

1. 环境/本地化/宏
2. 全局变量与玩家变量声明
3. 基础系统：地图检测、黑名单、游戏设置初始化、称号库（由平台 Agents API 同步生成）、事件开关
4. 功能系统：英雄规则、事件配置、抽样器、业务服务（`map/`、`blacklist/`、`player/`、`session/`、`bastion/`、`events/effects`、`events/integrity`、`events/lifecycle` 与 `utilities/system` 遗留项按固定槽位交错 include）
5. 事件执行层：分配器 + buff/debuff/mech 规则
6. 地图层 + 堡垒 AI
7. 效果层：HUD、特效、玩家状态可视化
8. 玩家层：初始化、进度、成就
9. 菜单层：`menu/`（公共框架 + 玩家/房主/开发职责拆分）

## 服务 include 约定（三入口同步）

- 三个入口直接 include `utilities/macros.opy` 和编译所需的事件/模式/地图定义
- 三个入口直接列出中段服务，按固定槽位交错 include 各属主模块；不要按目录重新分组排序
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

玩法循环规则归属职责模块，由三个入口按原顺序直接引入：

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
- `settings.heroes` 位于三个入口的 settings 块，宏真源在 `heroes/settings/`（`team_rules.opy`、`all_teams.opy`），三入口共用同一组英雄设置。
- 新增全局变量时需谨慎维护索引稳定性，避免覆盖既有槽位。
- 修改业务逻辑时改职责属主目录下的真实文件；`utilities/system/` 只承载无单一属主的系统机制，不再新增业务实现。
