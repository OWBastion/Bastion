# Event: BuffEventId.IRON_BULWARK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 钢铁防线":
    @Event eachPlayer
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.IRON_BULWARK]) == true
    
    wait(0.032)
    if eventPlayer.healthId[1] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.healthId[1])
    lbl_0:
    eventPlayer.addHealthPool(Health.ARMOR, EVT_2_ARMOR_AMOUNT, false, false)
    eventPlayer.healthId[1] = getLastCreatedHealthPool()
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, Color.WHITE, eventPlayer, 200)
    eventPlayer.mod_dmg_taken = EVT_2_DMG_TAKEN
    updatePlayerStats()
    # Exception: effect teardown is bound to event lifecycle completion.
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)
    removeHealthPool(eventPlayer.healthId[1])
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.healthId[1] = null
