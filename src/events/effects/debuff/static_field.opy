#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/静电力场"

# Event: DebuffEventId.STATIC_FIELD
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# eventPlayer.eventMission 在本文件中被借用为“触发保护截止时间戳”（> getTotalTimeElapsed() 时条件不满足，
# 规则停转且不产生判定；保护到期后由 Ongoing 条件重新命中恢复扫描）。clearPlayerEvent 统一将其归零，
# 事件正常结束或中途 abort 均不会残留保护状态。

rule "Proximity repel":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), not eventPlayer.hasStatus(Status.PHASED_OUT), eventPlayer.eventId == DebuffEventId.STATIC_FIELD, getTotalTimeElapsed() >= eventPlayer.eventMission]) == true

    eventPlayer.target = getRealClosestPlayer(eventPlayer, Team.2)
    if eventPlayer.target != eventPlayer and distance(eventPlayer, eventPlayer.target) <= EVT_DEBUFF_25_TRIGGER_RADIUS:
        # 仅作用于触发双方：沿两者连线向相反方向弹开，并同时击晕
        eventPlayer.applyImpulse(directionTowards(eventPlayer.target, eventPlayer), EVT_DEBUFF_25_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.target.applyImpulse(directionTowards(eventPlayer, eventPlayer.target), EVT_DEBUFF_25_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.setStatusEffect(eventPlayer, Status.STUNNED, EVT_DEBUFF_25_STUN)
        eventPlayer.target.setStatusEffect(eventPlayer, Status.STUNNED, EVT_DEBUFF_25_STUN)
        eventPlayer.eventMission = getTotalTimeElapsed() + EVT_DEBUFF_25_TRIGGER_PROTECTION
        eventPlayer.target = null
    wait(EVT_DEBUFF_25_SCAN_INTERVAL)
    if ruleCondition:
        loop()
    # 兜底收尾（中途 abort 时由 clearPlayerEvent 复位 eventMission）
    eventPlayer.target = null
