# Event: DebuffEventId.SELFLESS_GIVEAWAY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 舍己为人":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SELFLESS_GIVEAWAY]) == true
    
    if eventPlayer.getMaxHealth() <= EVT_DEBUFF_15_MIN_MAX_HP:
        eventPlayer.eventDuration = 0
    else:
        getPlayers(Team.1).exclude(eventPlayer).heart_steel += EVT_DEBUFF_15_STACKS_GIVE
        getPlayers(Team.1).exclude(eventPlayer).setPlayerHP = true
        eventPlayer.heart_steel -= EVT_DEBUFF_15_STACKS_TAKE * len(getPlayers(Team.1).exclude(eventPlayer))
        setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION, Color.TEAM_1, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 100)
    wait(eventPlayer.eventDuration)

rule "[VishkarEvent]: 舍己为人":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.setPlayerHP]) == true
    
    setPlayerHP()
    eventPlayer.setPlayerHP = false
