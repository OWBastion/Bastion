# 06. 通用工具层（`utilities/`）

`utilities/` 仅保留无单一业务属主的系统机制与共享生产宏。业务实现已按职责归位：地图检测、控制点推进与点位交互 `src/map/`、玩家进度/存档/属性/回复/摄像机 `src/player/`、称号操作 `src/title/`、菜单 `src/menu/`、堡垒 bot `src/bastion/`、难度展示 `src/env/`、黑名单解除 `src/blacklist/`、事件域支撑 `src/events/effects/`、目录权重校验 `src/events/integrity/`（文件级索引见附录）。

## 目录结构

### A. `utilities/system/`

无单一业务属主的全局机制：

- `anticrash.opy`：防崩溃慢动作保护（历史遗留孤立文件，未接入任何入口）
- `autoReboot.opy`：整局自动重开计时

### B. `utilities/macros.opy`

共享生产宏（英雄判定、存档索引、定位、`percent` 等），由 `bootstrap.opy` 显式 include；原 `dev_support/` 层为误标，已消除。

## 入口约定

- 顶部宏：`utilities/macros.opy`
- 中段服务分组：`core.opy` 按固定槽位交错 include 各属主模块（`map/`、`blacklist/`、`player/`、`env/`、`bastion/`、`events/*` 及 `utilities/system` 遗留项），槽位顺序不可重排
- 末尾菜单分组：`menu/frame.opy` -> `menu/hero.opy` -> `menu/dev/*` -> `menu/player.opy` -> `menu/host/*` 等固定槽位交错展开

## 关键实现模式

- Canonical 规则来源：`docs/agents/performance-loop-safety.md`（此处仅保留路由指针，不复制规则正文）。
- 高频玩家与事件循环使用按行为域命名的固定节拍；服务器负载读数不参与这些循环的等待计算
- 长循环均包含 wait，避免无等待循环
- 高复用动作封装为 subroutine，规则中只做触发与组合
- `player/playerRegen.opy` 采用“受伤信号 + `waitUntil`”驱动 HOT 生命周期：受伤即停疗，满 3 秒未再受伤后才重新允许触发
- `events/lifecycle/clearEventEffect.opy` 同步销毁当前事件的单一或双 Effect 句柄；最终调用由 `clearPlayerEvent()` 统一负责
- `events/effects/healthPool.opy` 每轮最多显式销毁 6 个到期生命池，未处理记录保留到后续轮次，只有执行 `removeHealthPool()` 后才从队列删除

## 易错点

- 事件结束后若忘记 `clearPlayerEvent()`，容易残留状态
- 新增属性修正时需记得并入 `player/updatePlayerStats.opy`
- `hp_data` 相关功能必须维护过期清理，否则元素数会累积
- `player/playerRegen.opy` 的脱战回复由受伤信号控制：受伤会立即停止 HOT，并通过 `wait(3, Wait.RESTART_WHEN_TRUE)` 保证“满 3 秒未再受伤”后才重新允许启动回复
- `title/hashtag.opy` 为 init 阶段主机 `titlePlayer` 白名单校验：等待称号数组初始化并确认 `hostPlayer` 存在后，若主机名不在白名单中则关闭 `hashTag`
- `events/integrity/hashtag.opy` 权重校验分两路：对局 125s 后做一次权重总和等值校验（与 `EVENT_MANIFEST_ACTIVE_WEIGHT_SUM` 不一致即判负）；另有持续生效的超限校验，`eventCatalogWeightTotal`（由对局码生成规则维护的实际权重总账）超过清单值 +0.05 即判负，覆盖 125s 检查点之后的开发菜单权重页加权
