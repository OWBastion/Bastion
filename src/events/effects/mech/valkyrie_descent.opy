# Event: MechEventId.VALKYRIE_DESCENT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 瓦尔基里降临":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VALKYRIE_DESCENT]) == true
    
    eventPlayer.sizeHealth = EVT_MECH_13_SIZE_HEALTH
    setPlayerHP()
    eventPlayer.heal_recv = EVT_MECH_0_HEAL_BAN
    eventPlayer.mod_heal_event = EVT_MECH_0_HEAL_BAN
    updatePlayerStats()
    eventPlayer.eventMission = eventPlayer.getMaxHealth()
    wait(eventPlayer.eventDuration)
    eventPlayer.sizeHealth = 1
    setPlayerHP()
    eventPlayer.heal_recv = 0
    eventPlayer.mod_heal_event = 0
    updatePlayerStats()
    clearEventEffect()

rule "[VishkarEvent]: 瓦尔基里降临 大招充能":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VALKYRIE_DESCENT]) == true
    @Condition attacker != eventPlayer
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + EVT_MECH_13_ULT_CHARGE_GAIN)
    wait(EVT_MECH_13_ULT_CHARGE_INTERVAL)

rule "[VishkarEvent]: 瓦尔基里降临 (大招持续回血)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VALKYRIE_DESCENT, eventPlayer.isUsingUltimate()]) == true
    
    if eventPlayer.eventTargetHP == 0:
        eventPlayer.eventTargetHP = eventPlayer.getMaxHealth()
    eventPlayer.eventTargetHP = eventPlayer.getHealth() + ((eventPlayer.eventTargetHP - eventPlayer.getHealth()) * EVT_MECH_13_HEAL_SMOOTHING)
    while all([eventPlayer.isUsingUltimate(), eventPlayer.getHealth() < eventPlayer.eventTargetHP]):
        eventPlayer.setHealth(min(eventPlayer.eventTargetHP, eventPlayer.getHealth() + eventPlayer.getMaxHealth() * EVT_MECH_13_HEAL_TICK_PERCENT))
        playEffect(getAllPlayers(), DynamicEffect.HEAL_TARGET_ACTIVE, Color.YELLOW, eventPlayer, 60)
        wait(EVT_MECH_13_HEAL_TICK_INTERVAL)
