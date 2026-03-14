# Event: BuffEventId.ADRENALINE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 肾上腺素":
    @Event eachPlayer
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.ADRENALINE]) == true
    
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED_SOUND, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    eventPlayer.mod_dmg_taken = EVT_3_DMG_TAKEN
    eventPlayer.mod_heal_event = EVT_3_HEAL_BOOST
    eventPlayer.heal_recv = EVT_3_HEAL_BOOST
    wait(getAverageServerLoad() / 100 * 0.032)
    updatePlayerStats()
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.mod_heal_event = 0
    eventPlayer.heal_recv = 0
    updatePlayerStats()
    clearEventEffect()
