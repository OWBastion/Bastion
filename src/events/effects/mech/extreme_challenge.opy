# Event: MechEventId.EXTREME_CHALLENGE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 极限挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.EXTREME_CHALLENGE]) == true
    
    waitUntil(eventPlayer.isAlive(), MAX_TIME)
    eventPlayer.mod_heal_event = EVT_MECH_0_HEAL_BAN
    eventPlayer.heal_recv = EVT_MECH_0_HEAL_BAN
    createEffect(getAllPlayers(), Effect.ANA_BIOTIC_GRENADE_NO_HEALING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * EVT_MECH_0_HP_PERCENT)
    eventPlayer.mod_dmg_taken = EVT_MECH_0_DMG_TAKEN
    updatePlayerStats()
    waitUntil(eventPlayer.isDead(), eventPlayer.eventDuration)
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
    clearEventEffect()
    eventPlayer.mod_heal_event = 0
    eventPlayer.heal_recv = 0
    updatePlayerStats()
    eventPlayer.eventDuration = 0

rule "[VishkarEvent]: 极限挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.EXTREME_CHALLENGE]) == true
    @Condition eventPlayer.getHealth() > eventPlayer.getMaxHealth() * EVT_MECH_0_HP_PERCENT == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * EVT_MECH_0_HP_PERCENT)
    wait(5)
    if ruleCondition:
        loop()
