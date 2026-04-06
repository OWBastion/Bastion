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

### `data/title-source.json`

- 称号系统唯一真源（`titles` + `players/titleKeys` + `meta`）
- 维护规则：`players` 顺序即索引语义，新增玩家仅追加，禁止重排

### `tools/sync-title-data.ts`

- 从真源生成 `title-cn.opy` 受管区块
- 生成 web 查询页数据 `web/title-query/public/data/titles.json`
- 提供一致性校验入口（配合 `pnpm run tools -- test:title-data-sync`）

### `tools/grant-player-title.ts`

- 通过 `pnpm run tools -- grant:title` 写入 `data/title-source.json`
- 非 `--dry-run` 且有实际变更时自动执行 `pnpm run tools -- sync:title-data`
- CLI 输出包含 auto-sync 结果，便于确认生成产物是否已刷新

### `title/title-cn.opy`

- 运行时称号配置载体
- 受管区块：`enum TITLE`、`player_database`、`allTitle`（由同步脚本生成）
- 地图称号映射宏（PIONEER/CONQUEROR/DOMINATOR）

### `title/init.opy`

- 生成玩家头顶称号文本
- 支持彩色/渐变/开发者彩虹标题

## 协作关系

- `setPlayerTitle()` 汇总个人称号 + 地图称号
- `player/init` 负责称号恢复与显示初始化
- `effects/init` 与 `title/init` 一起构成完整 UI 体验

## 维护流程（称号）

1. 编辑 `data/title-source.json`（称号定义、玩家授予）。
2. 如有地图奖励变更，更新 `data/title-source.json` 的 `mapTitles` 对应槽位。
3. 若通过 `pnpm run tools -- grant:title` 发放称号，确认输出中的 auto-sync 已执行；若手动编辑真源，则执行 `pnpm run tools -- sync:title-data`。
4. 执行 `pnpm run tools -- test:title-data-sync`。
