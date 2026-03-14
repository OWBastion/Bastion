# Event: DebuffEventId.VAMPIRE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 吸血鬼 (按需吸血)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.VAMPIRE, eventPlayer.getNormalizedHealth() != 1]) == true
    @Condition getPlayers(Team.1)[1] != null
    @Condition getLivingPlayers(Team.1)[1] != null
    
    eventPlayer.passiveRegenBlocked = true
    
    eventPlayer.target = [i for i in getPlayersInRadius(eventPlayer, EVT_DEBUFF_20_RADIUS, Team.1, LosCheck.SURFACES).exclude(eventPlayer) if i.isAlive()]
    if len(eventPlayer.target) > 0:
        damage(eventPlayer.target, eventPlayer, EVT_DEBUFF_20_DAMAGE_PER_TARGET)
        heal(eventPlayer, eventPlayer.target, len(eventPlayer.target) * EVT_DEBUFF_20_HEAL_PER_TARGET)
        eventPlayer.dlcTimeChallenge[4] += len(eventPlayer.target) * EVT_DEBUFF_20_DAMAGE_PER_TARGET
        playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.RED, eventPlayer.target, 200)
    wait(EVT_DEBUFF_20_INTERVAL)
    if ruleCondition:
        loop()
    clearEventEffect()
    eventPlayer.target = null
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()
