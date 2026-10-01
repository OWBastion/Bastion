# 09. 季节/活动分支（`special/` 与 `lunar.opy`）

## 目的

`special/` 与 `src/lunar.opy` 形成春节活动分支（“鸿运当头”），包含红包玩法和活动事件包。

## 主要组件

- `special/locale.opy`：活动文案与设置
- `special/eventConfig.opy`：活动事件池
- `special/event.opy`：活动事件效果
- `special/packet.opy`：红包刷新、HUD、拾取逻辑
- `special/getRedPacket.opy`：红包触发类别选择
- `special/rollActivePacket.opy`：红包点位抽样
- `special/achievement.opy`：活动成就追踪
- `special/map/lijiang_tower.opy`：春节漓江塔点位（含红包点）

## 与主线差异

- 入口从 `main/devMain` 切到 `lunar.opy`
- 事件来源改为 `special/eventConfig.opy`
- 玩家事件类型可由红包拾取直接决定
- 地图可能带活动专用点位与世界特效

## 维护建议

- 主线不长期保留季节逻辑；按 AGENTS 约定使用独立分支维护。
- 活动迁回主线前，先抽离可复用基础能力（如事件框架、HUD 组件）。
- 活动结束后关注：是否需要回收文本 key、事件常量、地图临时点位。

## 周年庆分支（`special/anniversary-2026`）

- 入口为 `src/anniversary2026.opy`，在共享 `core.opy` 之后追加 `src/anniversary2026/` 下的周年庆专用模块。
- `src/anniversary2026/minefield.opy`（Issue #273 地雷禁区）：在受支持地图上维持一只隐藏破坏球 Bot（隐身 + 相移 + 无法杀死），每 60 秒传送至该图预配置点位（`minefieldPosition`，由八张周年地图规则独立配置，不从堡垒点或终点推导；未配置点位时不启用机制）施放地雷禁区；Team 1 破坏球大招持续 500%（`TEAM1_WRECKINGBALL_ULT_DURATION_PCT`）。施放期间短暂清除相移状态，随后恢复并回传出生点待命；点位选择避免连续重复。
- 共享规则按英雄过滤 Team 1 单位（命名、击杀归属、斥退、引力异常、狂欢盛宴、Bot 创建与事件分配计数），保证非堡垒的机制 Bot 不影响堡垒编队与事件逻辑；对主线（Team 1 全为堡垒）无行为差异。
