# 08. 玩家、效果与称号

## `player/`：玩家生命周期

### `player/init.opy`

- 玩家加入初始化（dev 标识、事件初始态、称号加载）
- 从存档恢复：英雄进度、死亡数、跳过数、通关时间等
- 设置允许英雄池与初始强制英雄

### `player/status.opy`

- 记录进度死亡数 `progressionDeathCount`
- 用终极充能展示“可跳过进度”
- 达阈值后可用大招推进英雄
- reset ring 长按重载进度

### `player/achievement.opy`

- 主线成就追踪（如 Lucky/Unlucky/V50/Steel/Hacking）
- 解锁统一调用 `unlockAchievement()`

## `effects/`：HUD 与视觉反馈

### `effects/init.opy`

- 模式主 HUD 初始化（左侧进度、右侧模式信息、随机事件面板）
- 玩家属性统计并入左侧统计面板中段：心之钢、永久移速、永久减伤、治疗强度
- 首个玩家通关后，左侧结算统计面板为所有参与者显示同一房间级 `NNNN-NNNN-NNNN` 通关代码；该字段与通关耗时、死亡/跳过、事件统计共用截图布局
- 终点、切图点、第三人称点、重置点等世界特效
- 自动重开倒计时可视化

### 通关截图 / OCR 契约

`masteryRunCode` 在 `env/game.opy` 的全局新局初始化中置空；首个玩家通关时在 "Resolve finish" 中生成一次（以 `masteryRunCode == ""` 守卫，首个通关者写入后保持不变），格式为三个 `1000..9999` 数字组。它不随玩家重生、换英雄、重新连接式初始化或玩家进度重置而变化；只有正常新局启动才会重置为空并重新生成。

HUD 在既有左侧结算统计区域直接显示该数字代码（无标签前缀），不调用平台或改变游戏逻辑。`OWBastion/ocrkit` 应把这个字段作为结构化证据处理，并在 Bastion 实际发布后再记录最小兼容游戏/布局版本；本仓库不会预先声明发布版本。

### `effects/nano.opy`

- 堡垒狂暴（hasNano）特效生命周期

### `effects/player.opy`

- 胜者轮廓高亮
- 新玩家加入时同步已通关玩家高亮状态

## `title/`：称号系统

### `tools/sync-platform-data.ts`

- 接收平台 Agents API 规范化数据，生成 `title-cn.opy` 受管区块
- 地图称号的地图/槽位关系以成就投影中的 `mapTitleRule` 为准；称号目录只提供展示元数据
- 地图持有者必须携带显式 `slotSemantics`，不通过空 slot 推断语义
- 不再读取本地玩家、称号或地图持有者数据源

### `title/title-cn.opy`

- 运行时称号配置载体
- 受管区块：`enum TITLE`、`player_database`、`titleText`、`titleColor`（由同步脚本生成）
- 地图称号映射宏（PIONEER/CONQUEROR/DOMINATOR）

### `title/init.opy`

- 生成玩家头顶称号文本
- 支持彩色/渐变/开发者彩虹标题

## 协作关系

- `setPlayerTitle()` 汇总个人称号 + 地图称号
- `player/init` 负责称号恢复与显示初始化
- `effects/init` 与 `title/init` 一起构成完整 UI 体验

## 维护流程（称号）

1. 在平台管理端维护称号定义和 active 授予关系。
2. 执行 `pnpm run sync:platform-data`，从平台 API 拉取并生成 OverPy 数据。
3. 执行 `pnpm run tools -- test:platform-data-sync`。

同步会先 dry-run 生成称号、地图 revision、locale 和事件清单的全部输出；
任一 Agents 投影错误或一致性校验失败时不会替换已有生成文件，也不会进入
构建。可投影地图没有任何持有者仍是合法的空结果。
