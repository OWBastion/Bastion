# Event: BuffEventId.TENACITY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 坚韧":
    @Event eachPlayer
    @Team 1
    @Condition all([
        dlcVishkarEvent,
        eventPlayer.hasSpawned(),
        eventPlayer.isAlive(),
        eventPlayer.eventType == 0,
        eventPlayer.eventId == BuffEventId.TENACITY,
        eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * EVT_34_TRIGGER_HP_PERCENT
    ]) == true

    eventPlayer.startHealingOverTime(eventPlayer, EVT_34_HEAL_DURATION, eventPlayer.getMaxHealth() * EVT_34_HEAL_PER_SEC_MAXHP_FACTOR)
    playEffect(getAllPlayers(), DynamicEffect.HEAL_TARGET_ACTIVE, Color.YELLOW, eventPlayer, 60)
    wait(EVT_34_HEAL_DURATION)
    wait(EVT_34_TRIGGER_COOLDOWN)
