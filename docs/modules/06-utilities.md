# 06. 通用工具层（`utilities/`）

`utilities/` 采用分组目录结构，真实实现仅位于 `event_core/`、`system/`、`dev_support/` 三个子目录。

## 目录结构

### A. `utilities/event_core/`

事件生命周期核心动作：

- `setPlayerEvent.opy`
- `clearPlayerEvent.opy`
- `setEventDuration.opy`
- `clearEventEffect.opy`
- `updatePlayerStats.opy`
- `setPlayerHP.opy`
- `resetPlayerCD.opy`
- `startCombatRegen.opy`
- `setPlayerSize.opy`

### B. `utilities/system/`

通用系统逻辑与常驻规则：

- `mapDetection.opy`
- `healthPool.opy`
- `playerRegen.opy`
- `removeFromBlacklist.opy`
- `createBastionBot.opy`
- `progressHero.opy`
- `savePlayerData.opy`
- `setDifficulty.opy`
- `setPlayerTitle.opy`
- `setThirdPerson.opy`
- `unlockAchievement.opy`
- `hashtag.opy`
- `anticrash.opy`
- `dashDetector.opy`

### C. `utilities/dev_support/`

开发辅助能力：

- `macros.opy`
- `devTool.opy`

## 入口约定（main/devMain）

- 顶部宏：`utilities/dev_support/macros.opy`
- 中段工具分组顺序：`utilities/system/*` -> `utilities/event_core/*`
- 末尾开发工具：`utilities/dev_support/devTool.opy`

## 关键实现模式

- Canonical 规则来源：`docs/agents/performance-loop-safety.md`（此处仅保留路由指针，不复制规则正文）。
- 高频玩家与事件循环使用按行为域命名的固定节拍；服务器负载读数不参与这些循环的等待计算
- 长循环均包含 wait，避免无等待循环
- 高复用动作封装为 subroutine，规则中只做触发与组合
- `playerRegen.opy` 采用“受伤信号 + `waitUntil`”驱动 HOT 生命周期：受伤即停疗，满 3 秒未再受伤后才重新允许触发
- `clearEventEffect()` 同步销毁当前事件的单一或双 Effect 句柄；最终调用由 `clearPlayerEvent()` 统一负责
- `healthPool.opy` 每轮最多显式销毁 6 个到期生命池，未处理记录保留到后续轮次，只有执行 `removeHealthPool()` 后才从队列删除

## 易错点

- 事件结束后若忘记 `clearPlayerEvent()`，容易残留状态
- 新增属性修正时需记得并入 `updatePlayerStats()`
- `hp_data` 相关功能必须维护过期清理，否则元素数会累积
- `playerRegen.opy` 的脱战回复由受伤信号控制：受伤会立即停止 HOT，并通过 `wait(3, Wait.RESTART_WHEN_TRUE)` 保证“满 3 秒未再受伤”后才重新允许启动回复
- `hashtag.opy` 现改为 init 阶段主机 `titlePlayer` 白名单校验：等待称号数组初始化并确认 `hostPlayer` 存在后，若主机名不在白名单中则关闭 `hashTag`
