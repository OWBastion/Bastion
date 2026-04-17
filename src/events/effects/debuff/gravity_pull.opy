# Event: DebuffEventId.GRAVITY_PULL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 引力异常":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.GRAVITY_PULL, eventPlayer.eventEffect == null]) == true
    
    createEffect(getAllPlayers() if (eventPlayer.isAlive() and getPlayers(Team.2)[0] != null) else null, Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers() if (eventPlayer.isAlive() and getPlayers(Team.2)[0] != null) else null, Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != DebuffEventId.GRAVITY_PULL or eventPlayer.eventType != 1, eventPlayer.eventDuration)


rule "[VishkarEvent]: 引力异常":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.GRAVITY_PULL]) == true
    @Condition getPlayers(Team.2)[0] != null
    
    if eventPlayer.mod_speed_event != 0:
        goto lbl_0
    eventPlayer.mod_speed_event -= EVT_DEBUFF_5_SPEED_REDUCTION
    updatePlayerStats()
    lbl_0:
    if getPlayers(Team.2)[1] == null:
        eventPlayer.target = getPlayers(Team.2)[0]
    else:
        eventPlayer.target = sorted(getPlayers(Team.2), lambda player: distance(eventPlayer, player))[0]
    eventPlayer.applyImpulse(directionTowards(eventPlayer, eventPlayer.target), EVT_DEBUFF_5_PULL_AIR if eventPlayer.isInAir() else EVT_DEBUFF_5_PULL_GROUND, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
