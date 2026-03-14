# Event: DebuffEventId.SPEED_LIMIT_40
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 限速40":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SPEED_LIMIT_40, eventPlayer.isMoving(), eventPlayer.getSpeed() != 0]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    wait(EVT_DEBUFF_4_CHECK_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.hasStatus(Status.BURNING):
        goto lbl_0
    eventPlayer.setStatusEffect(null, Status.BURNING, EVT_DEBUFF_4_BURN_DURATION)
    lbl_0:
    eventPlayer.startDamageOverTime(null, EVT_DEBUFF_4_CHECK_INTERVAL, EVT_DEBUFF_4_DMG_BASE + round(eventPlayer.getMaxHealth() * EVT_DEBUFF_4_DMG_PERCENT))
    wait(0.032)
    if ruleCondition:
        loop()
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()
