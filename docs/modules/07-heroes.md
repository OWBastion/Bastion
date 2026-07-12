# 07. 英雄规则层（`heroes/`）

## 结构

- 聚合：`all_hero.opy`
- 子模块：`ana`, `dva`, `juno`, `lifeweaver`, `mercy`, `reinhardt`, `symmetra`, `zenyatta`
- 英雄设置：`settings/team_rules.opy`、`settings/all_teams.opy`

## 设计思路

每位英雄只承载“本模式专属限制或增强”，避免侵入式大改。

## 各英雄摘要

- `ana.opy`
  - 睡眠针对单个堡垒有冷却窗口（避免无限控）
  - 提供睡眠计时提示 HUD

- `dva.opy`
  - 机甲破碎后以位移距离作为再机甲目标
  - 用大招充能进度条表达目标完成度

- `mercy.opy`
  - 周围可复活时延长阵亡者重生，给复活窗口

- `lifeweaver.opy`
  - 非胜者禁用抓人
  - 花瓣平台自动回收

- `symmetra.opy`
  - 传送门自动销毁（避免长期残留）

- `reinhardt.opy`
  - 冲锋碰近堡垒时中断，防止位移穿模或强行控场

- `zenyatta.opy`
  - 近战反冲与滞空机制（含触发条件）

- `juno.opy`
  - 含事件联动禁用逻辑（目前规则标记为 Disabled）

## 与其他模块的耦合

- `phaseHero`（`env/game.opy`）定义哪些技能会触发位移检测
- `dashDetector.opy` 依赖英雄分组与状态位
- `effects/init.opy` 中部分 HUD 按英雄显示

## 扩展建议

- 新英雄规则优先单文件维护，再接入 `all_hero.opy`
- 如涉及事件联动，尽量在事件层设置标记，在英雄层只做行为响应
- 调整 Workshop 的英雄参数时，优先维护 `settings/team_rules.opy` 或 `settings/all_teams.opy`；main、dev 与 en-US 入口当前使用同一组英雄设置。
