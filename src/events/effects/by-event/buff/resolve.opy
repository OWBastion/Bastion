# Event: BuffEventId.RESOLVE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 坚定":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.RESOLVE]) == true
    
    eventPlayer.knockback = EVT_18_KNOCKBACK_RESISTANCE
    updatePlayerStats()
    wait(eventPlayer.eventDuration)
    eventPlayer.knockback = 0
    updatePlayerStats()

rule "[VishkarEvent]: 坚定":
    @Event playerReceivedKnockback
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.RESOLVE]) == true
    
    if eventPlayer.mod_dmg_taken == EVT_18_MAX_DMG_REDUCE:
        goto lbl_0
    eventPlayer.mod_dmg_taken -= EVT_18_DMG_REDUCE_PER_STACK
    eventPlayer.hudText = "伤害减免：{0}%".format(negToPos(eventPlayer.mod_dmg_taken))
    updatePlayerStats()
    lbl_0:
    heal(eventPlayer, eventPlayer, eventPlayer.getMaxHealth() * EVT_18_HEAL_PERCENT)
