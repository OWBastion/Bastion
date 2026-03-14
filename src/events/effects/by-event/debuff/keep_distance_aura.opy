# Event: DebuffEventId.KEEP_DISTANCE_AURA
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 保持距离 (易伤光环)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.KEEP_DISTANCE_AURA]) == true
    
    eventPlayer.target = getPlayersInRadius(eventPlayer, EVT_DEBUFF_16_RADIUS, Team.1, LosCheck.SURFACES).exclude(eventPlayer)
    if len(eventPlayer.target) > 1:
        eventPlayer.target = sorted(eventPlayer.target, lambda i: distance(eventPlayer, i))[0]
    elif eventPlayer.target[0] != null:
        eventPlayer.target = eventPlayer.target[0]
    else:
        eventPlayer.target = null
    if eventPlayer.target != null:
        eventPlayer.mod_dmg_taken = min(EVT_DEBUFF_16_MAX, max(0, (EVT_DEBUFF_16_RADIUS - distance(eventPlayer, eventPlayer.target)) * EVT_DEBUFF_16_FACTOR))
        eventPlayer.hudText = "受到伤害 +{0}%".format(eventPlayer.mod_dmg_taken)
    else:
        eventPlayer.mod_dmg_taken = 0
        eventPlayer.hudText = ""
    updatePlayerStats()
    wait(1)
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.hudText = ""
    updatePlayerStats()
    clearEventEffect()
