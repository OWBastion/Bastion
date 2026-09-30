#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/黑洞"

# Event: DebuffEventId.BLACK_HOLE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 强度校准：引力异常（EVT_DEBUFF_5_PULL_GROUND 0.85 / PULL_AIR 0.6）是本仓库既有的持续牵引量纲——
# 同为每 tick（wait() ≈ 0.016s）施加一次 applyImpulse，等效约 53/37 m/s² 的强牵引。
# 黑洞目标约 8 m/s²（Issue 原型手感），按同一模型取 PULL_STRENGTH = 0.13 m/s/tick（8 × 0.016 ≈ 0.128）。
# INCORPORATE_CONTRARY_MOTION 保留反向运动：不做硬锁定/传送，正常移动可对抗挣脱。
# 牵引只作用于其他有效友方（eventPlayer.target 已排除自己/阵亡/未生成/相位转移及 4m 内友方）。

rule "Black hole marker":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.BLACK_HOLE, eventPlayer.eventEffect == null]) == true

    createEffect(getAllPlayers() if eventPlayer.isAlive() else null, Effect.ORB, Color.BLACK, eventPlayer, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != DebuffEventId.BLACK_HOLE or eventPlayer.eventType != EventType.DEBUFF, eventPlayer.eventDuration)


rule "Pull allies toward black hole":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.BLACK_HOLE]) == true

    # 每 tick 先快照有界友方集合（≤11）再施加脉冲，不依赖 wait 之后的事件上下文
    eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.hasSpawned() and not player.hasStatus(Status.PHASED_OUT) and distance(eventPlayer, player) > EVT_DEBUFF_26_STOP_RADIUS]
    for eventPlayer.temp in range(len(eventPlayer.target)):
        eventPlayer.target[eventPlayer.temp].applyImpulse(directionTowards(eventPlayer.target[eventPlayer.temp], eventPlayer), EVT_DEBUFF_26_PULL_STRENGTH, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    # 收尾：正常结束或中途 abort 后清空暂存；eventEffect 由 clearEventEffect 统一销毁
    eventPlayer.target = null
    eventPlayer.temp = null
