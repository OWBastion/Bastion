# Event: BuffEventId.BLACK_FANS_ASSAULT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 黑粉来袭":
    @Event eachPlayer
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.BLACK_FANS_ASSAULT]) == true
   
    # eventPlayer.hudText = "{0}/{1}".format(len([player for player in getPlayers(Team.2) if player.target == eventPlayer]), len(bastionPosition))
    wait(getAverageServerLoad() / 100 * 0.032)
    if len([player for player in getPlayers(Team.2) if player.target == eventPlayer]) == 0:
        if eventPlayer.mod_speed_event != 0:
            eventPlayer.mod_speed_event = 0
            updatePlayerStats()
        if eventPlayer.eventEffect != null:
            clearEventEffect()
        wait(0.25)
        if ruleCondition:
            loop()
        goto lbl_2
    if eventPlayer.eventEffect == null:
        createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.eventEffect = getLastCreatedEntity()
    if eventPlayer.mod_speed_event == EVT_5_SPEED_BOOST:
        goto lbl_0
    eventPlayer.mod_speed_event = EVT_5_SPEED_BOOST
    updatePlayerStats()
    lbl_0:
    eventPlayer.addHealthPool(EVT_5_HEALTH_TYPE, round(EVT_5_HEALTH_FLAT + eventPlayer.getMaxHealth() * EVT_5_HEALTH_MAXHP_FACTOR), false, false)
    eventPlayer.hp_data.append([[getTotalTimeElapsed() + 2, getLastCreatedHealthPool()]])
    waitUntil(len([player for player in getPlayers(Team.2) if player.target == eventPlayer]) == 0, 1.96)
    if len([player for player in getPlayers(Team.2) if player.target == eventPlayer]) > 0 and ruleCondition:
        loop()
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()
    wait(0.25)
    if ruleCondition:
        loop()
    lbl_2:
    # eventPlayer.hudText = ""
