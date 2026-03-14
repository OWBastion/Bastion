# Event: BuffEventId.ULT_MOMENTUM
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 我按Q辣":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM, eventPlayer.isMoving(), eventPlayer.getSpeed() != 0]) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + EVT_23_ULT_CHARGE_PER_SEC)
    if ruleCondition:
        loop()
    if eventPlayer.isWinner:
        goto lbl_0
    eventPlayer.setUltCharge(0)
    lbl_0:

rule "[VishkarEvent]: 我按Q辣":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM, eventPlayer.isUsingUltimate()]) == true
    
    resetPlayerCD()
    if eventPlayer.nanoEffect != null:
        goto lbl_0

    createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.nanoEffect = getLastCreatedEntity()
    lbl_0:
    eventPlayer.mod_dmg_taken -= EVT_23_DMG_REDUCTION_DURING_ULT
    updatePlayerStats()
    waitUntil(not eventPlayer.isUsingUltimate(), eventPlayer.eventDuration)
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
