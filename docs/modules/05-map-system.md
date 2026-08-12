# 05. 地图系统（`map/`）

## 设计目标

- 每张图独立维护地图流程；38 张当前地图的声明式点位由平台 revision 数据提供
- 支持单图逃生与多段控制点/传送切图
- 与玩家进度系统、Bastion 生成逻辑解耦

## 聚合入口

- `src/map/setup_all_map.opy` 统一 include 全部地图文件
- 新增地图时必须同步更新该聚合文件

## 地图文件通用职责

地图文件保留 Workshop 行为和引擎相关的地图/变体判定。每张地图在设置阶段传入显式 `mapId` 和可选变体，再由 `applyPlatformMapRevision.opy` 从生成数据填充以下运行时变量：

- `bastionPosition`
- `endPosition`
- `resetPosition`
- `creditsPosition`
- 可选：`controlRespawnPosition`, `controlJumpPosition`, `controlRespawnAxis`, `controlRespawnAxisThreshold`
- 可选：`portalPosition`, `springBoardPosition`
- 可选：`__currentMapText___`, `__currentMapPioneerText___`

配置形状覆盖：

- `paraiso.opy`：普通单图点位
- `eichenwalde.opy`：默认 revision 与 `classic` 可选 revision
- `busan.opy`：三段控制点的 center/jump/respawn/axis 配置
- `antarctic_peninsula.opy`, `ilios.opy`：在玩家首次出生后，以平台的 `alternateStages.setupDetection` 一次性选择子图；没有命中时使用 base 配置

`src/constants/platform_map_revision_data.opy` 是 `sync:platform-data` 的生成输出，不是第二个手工真源。每个生成行显式携带 `mapId`、`gameplayRevisionId`、生命周期、选择标志、空间数据、挑战引用和修订称号持有者；历史/准备中 revision 不进入该文件。运行时只在地图设置阶段选择唯一默认 revision，只有显式请求的可选 revision 才会替换它；子图也只在 setup 转换时解析，不在热循环中重新解析。

## 多段地图（典型）

三图挑战相关地图（如 `lijiang_tower`, `samoa`, `oasis`, `busan`, `nepal`）使用：

- `controlJumpPosition`：到达后切段
- `controlRespawnPosition`：切段后复活基准点
- `controlRespawnAxis*`：防止出生房偏移导致回档失败

## 代表性地图能力

- 传送门地图：`new_junk_city.opy`（`portalPosition`）
- 弹板地图：`temple_of_anubis.opy`, `esperanca.opy`（`springBoardPosition`）
- 子图判定地图：`antarctic_peninsula.opy`, `ilios.opy`（平台 selector 选定子图配置）

## 地图清单摘要（38 个文件）

- 单图：如 `dorado`, `eichenwalde`, `route66`, `kings_row`, `paraiso` 等
- 多段：`lijiang_tower`, `samoa`, `oasis`, `busan`, `nepal`, `rialto`, `new_junk_city`
- 新图/实验：`suravasa`, `hanaoka`, `aatlis`, `throne_of_anubis`

## 关联模块

- `utilities/system/mapDetection.opy`：地图识别
- `effects/init.opy`：终点/跳点可视化
- 入口主规则：切图传送与终点晋级

## 开发注意

- 对已迁移地图，点位只能在平台 revision 的空间配置中维护；如果流程没有改变，纯坐标更新只需要平台数据同步和 Bastion 构建，不应再编辑地图 `.opy` 坐标。
- `sync:platform-data` 会拒绝没有显式 revision 消费或仍声明本地空间/地图称号数据的地图源文件，避免长期双重真源。
- 添加新地图时，需验证：
  - Bastion 数量与 `bastionPosition` 长度一致
  - 终点触发半径可达
  - reset/third-person/world text 不重叠
- 修改已迁移 revision 时，先通过 `tools/sync-platform-data.ts` 的空间、生命周期、挑战引用和称号持有者校验，再运行 main/dev 构建。
