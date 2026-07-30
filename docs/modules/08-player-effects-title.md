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
- 终点、切图点、第三人称点、重置点等世界特效
- 自动重开倒计时可视化

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
