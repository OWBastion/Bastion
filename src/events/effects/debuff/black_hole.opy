#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/黑洞"

# Event: DebuffEventId.BLACK_HOLE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 牵引用 startAcceleration 一次调用 + 引擎持续结算，不做逐 tick 脉冲循环：
# DIRECTION_RATE_AND_MAX_SPEED 重估使牵引方向每帧追踪移动的持有者，
# 多黑洞共存时自动转向最近的存活持有者；持有者死亡/结束/进入停止圈即停。
# 强度校准：引力异常（EVT_DEBUFF_5_PULL_*）每 tick applyImpulse 0.85/0.6 m/s
# 等效约 53/37 m/s²；黑洞按 issue 原型手感取 8 m/s² 持续加速度 + 8 m/s 上限，
# 远低于引力异常且玩家地面加速度可对抗挣脱——不做硬锁定/传送。

# 当前对本玩家生效的黑洞持有者（存活、已生成、本人在其停止圈之外），按距离升序；空列表 = 不受牵引
macro Player.blackHoles():
    sorted(
        getPlayers(Team.2).filter(lambda h: h != self and h.eventType == EventType.DEBUFF and h.eventId == DebuffEventId.BLACK_HOLE and h.hasSpawned() and h.isAlive() and distance(self, h) > EVT_DEBUFF_26_STOP_RADIUS),
        lambda h: distance(self, h)
    )

rule "Black hole marker":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.BLACK_HOLE, eventPlayer.eventEffect == null]) == true

    createEffect(getAllPlayers() if eventPlayer.isAlive() else null, Effect.ORB, Color.BLACK, eventPlayer, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != DebuffEventId.BLACK_HOLE or eventPlayer.eventType != EventType.DEBUFF, eventPlayer.eventDuration)


rule "Pulled toward black hole":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasStatus(Status.PHASED_OUT) == false
    @Condition len(eventPlayer.blackHoles()) > 0

    eventPlayer.startAcceleration(
        directionTowards(eventPlayer, eventPlayer.blackHoles()[0] if len(eventPlayer.blackHoles()) > 0 else eventPlayer),
        EVT_DEBUFF_26_PULL_ACCEL,
        EVT_DEBUFF_26_PULL_MAX_SPEED,
        Relativity.TO_WORLD,
        AccelReeval.DIRECTION_RATE_AND_MAX_SPEED
    )
    waitUntil(
        len(eventPlayer.blackHoles()) == 0
        or eventPlayer.isAlive() == false
        or eventPlayer.hasStatus(Status.PHASED_OUT) == true,
        Math.INFINITY
    )
    eventPlayer.stopAcceleration()
