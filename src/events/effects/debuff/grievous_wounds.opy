# Event: DebuffEventId.GRIEVOUS_WOUNDS
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 重伤":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.GRIEVOUS_WOUNDS]) == true
    
    eventPlayer.mod_heal_event = EVT_DEBUFF_12_HEAL_DEALT_RED
    eventPlayer.heal_recv = EVT_DEBUFF_12_HEAL_RECV_RED
    updatePlayerStats()
    createEffect(getAllPlayers(), Effect.ANA_BIOTIC_GRENADE_NO_HEALING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND, Color.WHITE, eventPlayer, 200)
    wait(eventPlayer.eventDuration)
    clearEventEffect()
    eventPlayer.mod_heal_event = 0
    eventPlayer.heal_recv = 0
    updatePlayerStats()
    clearEventEffect()
