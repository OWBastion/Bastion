# 04. 堡垒 AI（`bastion/init.opy`）

## 职责范围

`src/bastion/init.opy` 负责敌方堡垒（Team 2）的完整行为控制：

- 生成后定位与姿态维持
- 目标搜索与开火
- 瞄准、转向、追踪速度
- 榴弹逻辑（高难度/配置开关）
- 击杀统计、命名与标记
- 位移纠偏与防脱离

## 关键行为链

1. 初始化：按难度设置伤害，传送至 `bastionPosition`
2. 姿态保持：强制 Assault（机枪形态）
3. 目标搜索：LoS + 距离 + 状态过滤 + 排序策略
4. 开火控制：有目标持续压制，无目标停火
5. 瞄准系统：
   - 优先瞄暴露部位
   - 无目标时预瞄最近潜在威胁
   - 转向速度根据夹角与目标速度动态计算
6. 位置纠偏：被推离原位时拉回并重置

## 难度与设置联动

- `difficulty` 直接影响伤害与地狱难度行为
- `bastionBotSeconFire` 控制榴弹是否启用（可绕过难度）
- `dmgReduction` 影响玩家对堡垒伤害调整逻辑

## 目标选择策略

由 `bastionBotTargetPrefer` 决定排序偏好：

- 自动
- 近距离优先
- 低血优先

## 反卡死/防漂移处理

- 位置偏差超过阈值时强制传送回位
- 站稳后 `startForcingPosition` 锁定
- 高空特殊点位额外处理（避免掉落逻辑干扰）

## 相关联模块

- `utilities/system/createBastionBot.opy`：补齐 dummy 数量
- `events/effects/*`：部分事件会影响堡垒状态
- `effects/nano.opy`：狂暴/纳米状态可视化
