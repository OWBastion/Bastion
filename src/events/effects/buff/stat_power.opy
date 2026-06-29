#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.STAT_POWER
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 数值之力":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.STAT_POWER]) == true
    
    eventPlayer.mod_heal_event = EVT_17_HEAL_BOOST
    eventPlayer.heal_recv = EVT_17_HEAL_BOOST
    updatePlayerStats()
    createEffect(getAllPlayers(), Effect.ANA_BIOTIC_GRENADE_INCREASED_HEALING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENADE_INCREASED_HEALING_SOUND, Color.WHITE, eventPlayer, 200)
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_heal_event = 0
    eventPlayer.heal_recv = 0
    updatePlayerStats()
    clearEventEffect()
