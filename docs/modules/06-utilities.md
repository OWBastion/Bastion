# 06. 通用工具层（`utilities/`）

`utilities/` 现采用“分组目录 + 兼容层”结构。业务逻辑文件进入分组目录，旧平铺路径仅保留 shim（单行 `#!include`）用于过渡兼容。

## 目录结构（当前）

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

## 兼容层策略（过渡期）

- 旧路径（如 `utilities/setPlayerEvent.opy`）保留同名文件，但内容仅为 `#!include "event_core/setPlayerEvent.opy"`。
- 兼容层文件不再放置业务逻辑，避免双源维护。
- 兼容窗口结束后，再统一移除旧路径 shim。

## 入口约定（main/devMain）

- 顶部宏：`utilities/dev_support/macros.opy`
- 中段工具分组顺序：`utilities/system/*` -> `utilities/event_core/*`
- 末尾开发工具：`utilities/dev_support/devTool.opy`

## 关键实现模式

- 通过 `wait(getAverageServerLoad()/...)` 做负载自适应节流
- 长循环均包含 wait，避免无等待循环
- 高复用动作封装为 subroutine，规则中只做触发与组合
- `playerRegen.opy` 采用“受伤信号 + `waitUntil`”驱动 HOT 生命周期：受伤即停疗，满 3 秒未再受伤后才重新允许触发

## 易错点

- 事件结束后若忘记 `clearPlayerEvent()`，容易残留状态
- 新增属性修正时需记得并入 `updatePlayerStats()`
- `hp_data` 相关功能必须维护过期清理，否则元素数会累积
- 过渡期修改 utility 时应改分组目录下的“真实文件”，不要改旧路径 shim
- `playerRegen.opy` 的脱战回复由受伤信号控制：受伤会立即停止 HOT，并通过 `wait(3, Wait.RESTART_WHEN_TRUE)` 保证“满 3 秒未再受伤”后才重新允许启动回复
- `hashtag.opy` 现改为 init 阶段主机 `titlePlayer` 白名单校验：等待称号数组初始化并确认 `hostPlayer` 存在后，若主机名不在白名单中则关闭 `hashTag`
