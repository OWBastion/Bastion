# Event: DebuffEventId.ENERGY_LEAK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 能量泄漏":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.ENERGY_LEAK]) == true
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.isUsingAbility2()]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    wait()
    playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Color.TEAM_2, eventPlayer, 200)
    damage(eventPlayer, null, eventPlayer.getMaxHealth() * EVT_DEBUFF_8_DMG_PERCENT)
    wait(EVT_DEBUFF_8_COOLDOWN)
    if ruleCondition:
        loop()
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()
