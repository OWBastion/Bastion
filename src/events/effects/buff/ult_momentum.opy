#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/我按Q辣"

# Event: BuffEventId.ULT_MOMENTUM
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "Charge while moving":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM, eventPlayer.isMoving(), eventPlayer.getSpeed() != 0]) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + EVT_18_ULT_CHARGE_PER_SEC)
    if ruleCondition:
        loop()
    if eventPlayer.isWinner:
        goto lbl_0
    eventPlayer.setUltCharge(0)
    lbl_0:

rule "Create effect":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM, eventPlayer.eventEffect == null]) == true
    
    createEffect(getAllPlayers() if eventPlayer.isUsingUltimate() else null, Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != BuffEventId.ULT_MOMENTUM or eventPlayer.eventType != EventType.BUFF, eventPlayer.eventDuration)
    clearEventEffect()


rule "Sustain ultimate":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM, eventPlayer.isUsingUltimate()]) == true
    
    resetPlayerCD()
    eventPlayer.mod_dmg_taken -= EVT_18_DMG_REDUCTION_DURING_ULT
    updatePlayerStats()
    waitUntil(not eventPlayer.isUsingUltimate(), eventPlayer.eventDuration)
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
