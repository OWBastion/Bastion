#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/失败的Man"

# Event: MechEventId.FAILED_MAN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 长按 RELOAD 抓钩：以准星射线命中点为固定目标（射线沿用 zenyatta 既有
# 用法——getEyePosition + getFacingDirection × 最大距离，排除自己、含地板命中；
# raycast 未命中时 getHitPosition 直接返回端点，即最大距离点，行为简单可预期），
# 每 tick 沿当前方向施加"速度缺口"脉冲使朝向目标的分量收敛到 EVT_MECH_30_FLIGHT_SPEED。
# 距目标 ≤ ARRIVE_RADIUS、松开按键或超过 MAX_FLIGHT_TIME 即结束本次抓钩；
# 结束后 RESELECT_COOLDOWN 秒内不可再次选点。空中松开=保留残余速度自然坠落（卖点）。
#
# 变量分工（均由 clearPlayerEvent 统一清零，本事件仅需处理闩锁与暂存）：
#   eventMission     — 抓钩闩锁（0=可选点，1=飞行中）
#   eventMissionGoal — 下次可选点时间戳（getTotalTimeElapsed；与 life_pulse/divine_reinforcement 同构）
#   eventTargetHP    — 本次飞行截止时刻（复用浮点暂存，非 HP 语义）
#   target           — 抓钩目标点（向量；null = 未在飞行，兼作标记球可见性门控）
#   temp             — 每 tick 的归一化追踪方向
#   eventEffect[0]   — 目标点标记球（clearEventEffect 统一销毁）
#
# 移动选型：沿用 black_hole/gravity_pull 的每 tick applyImpulse 量纲。
# INCORPORATE_CONTRARY_MOTION 是纯速度叠加（v += m·dir），故脉冲量取
# max(0, FLIGHT_SPEED - getSpeedInDirection(dir)) 时，沿追踪方向的速度分量
# 1-2 tick 内精确收敛到 FLIGHT_SPEED ≈ 22m/s，且方向每 tick 重算 → 自动追踪固定点、
# 重力下坠由方向回摆自动补偿。超速段（俯冲等）不刹车。相比 startThrottleInDirection
# （上限为步行速度）与 startAcceleration（持续性状态，clearPlayerEvent 不兜底），
# 瞬时脉冲没有任何需要"停止"的引擎状态——中止即松手，天然无法泄漏。
#
# 出口审计（所有 while 出口都汇入同一收尾段；Teardown rule 兜底）：
#   松开按键        → isHoldingButton 退出 → 保留残余速度坠落
#   到达目标 ≤2m    → distance 退出 → 同上
#   飞行超时/贴墙   → eventTargetHP 截止退出 → 强制收尾
#   事件结束/死亡   → eventId/eventType/isAlive 检查退出 → 仅清理
#   被眩晕/打断     → 按键读为松开 → 按提前释放处理

rule "Grapple target marker":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.FAILED_MAN, eventPlayer.eventEffect == null]) == true

    createEffect(getAllPlayers() if eventPlayer.target != null else null, Effect.ORB, Color.YELLOW, eventPlayer.target if eventPlayer.target != null else eventPlayer, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != MechEventId.FAILED_MAN or eventPlayer.eventType != EventType.MECH, eventPlayer.eventDuration)


rule "Aim grapple and fly":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.FAILED_MAN, eventPlayer.eventMission == 0, eventPlayer.isAlive(), getTotalTimeElapsed() >= eventPlayer.eventMissionGoal, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    eventPlayer.eventMission = 1
    eventPlayer.target = raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * EVT_MECH_30_MAX_TARGET_DISTANCE, getAllPlayers(), eventPlayer, true).getHitPosition()
    eventPlayer.eventTargetHP = getTotalTimeElapsed() + EVT_MECH_30_MAX_FLIGHT_TIME
    while all([eventPlayer.isHoldingButton(Button.RELOAD), eventPlayer.isAlive(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.FAILED_MAN, getTotalTimeElapsed() < eventPlayer.eventTargetHP, distance(eventPlayer, eventPlayer.target) > EVT_MECH_30_ARRIVE_RADIUS]):
        eventPlayer.temp = directionTowards(eventPlayer, eventPlayer.target)
        eventPlayer.applyImpulse(eventPlayer.temp, max(0, EVT_MECH_30_FLIGHT_SPEED - eventPlayer.getSpeedInDirection(eventPlayer.temp)), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        wait()
    # 收尾：所有出口统一进这里——闩锁归零、写入再选点保护、清空目标/方向暂存
    eventPlayer.eventMissionGoal = getTotalTimeElapsed() + EVT_MECH_30_RESELECT_COOLDOWN
    eventPlayer.eventMission = 0
    eventPlayer.target = null
    eventPlayer.temp = null
    eventPlayer.eventTargetHP = 0


rule "Teardown":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.FAILED_MAN]) == true

    wait(eventPlayer.eventDuration)
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.target = null
    eventPlayer.temp = null
    eventPlayer.eventTargetHP = 0
