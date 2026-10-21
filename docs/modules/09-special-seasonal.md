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
- `special/map/lijiangTower.opy`：春节漓江塔点位（含红包点）

## 与主线差异

- 入口从 `main/devMain` 切到 `lunar.opy`
- 事件来源改为 `special/eventConfig.opy`
- 玩家事件类型可由红包拾取直接决定
- 地图可能带活动专用点位与世界特效

## 维护建议

- 主线不长期保留季节逻辑；按 AGENTS 约定使用独立分支维护。
- 活动迁回主线前，先抽离可复用基础能力（如事件框架、HUD 组件）。
- 活动结束后关注：是否需要回收文本 key、事件常量、地图临时点位。
