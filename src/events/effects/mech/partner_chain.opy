#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/同行链"

# Event: MechEventId.PARTNER_CHAIN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 与一名随机有效友方相连并持续被牵引向对方：每 tick 冲击 =
# MAX_PULL_STRENGTH × clamp01((距离 − FREE_DISTANCE) / (FULL_PULL_DISTANCE − FREE_DISTANCE))，
# 8m 内零牵引（不干扰正常移动），8→20m 线性斜坡，≥20m 满牵引。
# 牵引只作用于事件玩家本人，伙伴不受任何反向拉力。
#
# 强度校准：沿用引力异常的每 tick applyImpulse 量纲（0.85/0.6 ≈ 53/37 m/s²），
# MAX_PULL_STRENGTH = 0.13 m/s/tick ≈ 8 m/s²（Issue 原型最大牵引强度）。
# INCORPORATE_CONTRARY_MOTION 为纯速度叠加：不做硬锁定/传送，正常移动可反向对抗。
#
# 伙伴语义：有效友方 = Team.1 存活、已生成、非自身、非 PHASED_OUT（与黑洞筛选同族）。
#   开局无有效友方 → 提示并直接结束（eventDuration=0，有福同享/窃贼的无目标处理同构）。
#   途中伙伴失效（离场/死亡/未生成/相位转移）→ 每 tick 原地重选；
#   暂无可选则不牵引、事件保持存活，有友方重新有效即恢复牵引。
#   eventMission 闩锁区分"事件首绑"与"死亡重生后规则重触发"：重生重进跳过首绑判空，
#   仅靠途中重选——只有真正的事件开局才允许无友方即结束。
#
# 变量分工（target/eventMission 由 clearPlayerEvent 兜底，temp 本地清理）：
#   eventMission   — 首绑闩锁（0=未首绑，1=已首绑；跨死亡存活至事件结束）
#   target         — 当前连接伙伴（null=暂无有效伙伴）
#   temp           — 候选列表 / 牵引系数暂存

rule "Chain pull":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.PARTNER_CHAIN]) == true

    # 首绑（每事件实例仅一次）：无有效友方则提示并直接结束
    if eventPlayer.eventMission == 0:
        eventPlayer.eventMission = 1
        eventPlayer.temp = [player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.hasSpawned() and not player.hasStatus(Status.PHASED_OUT)]
        eventPlayer.target = random.choice(eventPlayer.temp) if len(eventPlayer.temp) > 0 else null
        eventPlayer.temp = null
        if eventPlayer.target == null:
            smallMessage(eventPlayer, "  {0}  没有可连接的有效友方".format(iconString(Icon.WARNING)))
            eventPlayer.eventDuration = 0
    while all([eventPlayer.isAlive(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.PARTNER_CHAIN, eventPlayer.eventDuration > 0]):
        # 伙伴失效即原地重选；暂无可选则本 tick 不牵引，事件保持存活等待友方恢复有效
        if eventPlayer.target == null or not eventPlayer.target in getPlayers(Team.1) or not eventPlayer.target.isAlive() or not eventPlayer.target.hasSpawned() or eventPlayer.target.hasStatus(Status.PHASED_OUT):
            eventPlayer.temp = [player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.hasSpawned() and not player.hasStatus(Status.PHASED_OUT)]
            eventPlayer.target = random.choice(eventPlayer.temp) if len(eventPlayer.temp) > 0 else null
            eventPlayer.temp = null
        if eventPlayer.target != null:
            eventPlayer.temp = min(1, max(0, (distance(eventPlayer, eventPlayer.target) - EVT_MECH_30_FREE_DISTANCE) / (EVT_MECH_30_FULL_PULL_DISTANCE - EVT_MECH_30_FREE_DISTANCE)))
            if eventPlayer.temp > 0:
                eventPlayer.applyImpulse(directionTowards(eventPlayer, eventPlayer.target), EVT_MECH_30_MAX_PULL_STRENGTH * eventPlayer.temp, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
            eventPlayer.temp = null
        wait()
    # 收尾：while 各出口统一清空暂存；eventMission 不在此归零——死亡重进仍属同一事件，
    # 须靠闩锁跳过首绑判空；事件结束时由 clearPlayerEvent 统一清零
    eventPlayer.target = null
    eventPlayer.temp = null


rule "Teardown":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.PARTNER_CHAIN]) == true

    wait(eventPlayer.eventDuration)
    eventPlayer.target = null
    eventPlayer.temp = null
    eventPlayer.eventMission = 0
