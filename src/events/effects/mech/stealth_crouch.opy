#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/悄悄地进村"

# Event: MechEventId.STEALTH_CROUCH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "Create effect":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.eventType == EventType.MECH,
        eventPlayer.eventId == MechEventId.STEALTH_CROUCH,
        eventPlayer.eventEffect == null
    ]) == true
    
    createEffect(getAllPlayers() if eventPlayer.isHoldingButton(Button.CROUCH) == true else null, Effect.REAPER_WRAITH_FORM, Color.TEAM_1, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != MechEventId.STEALTH_CROUCH or eventPlayer.eventType != EventType.MECH, eventPlayer.eventDuration)


rule "Apply stealth crouch":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.STEALTH_CROUCH]) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.targetSilence = true
    eventPlayer.mod_speed_event += EVT_MECH_3_SPEED_BOOST
    updatePlayerStats()
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) == false, eventPlayer.eventDuration)
    eventPlayer.targetSilence = false
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    wait(0.25)


rule "Drain health":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.eventType == EventType.MECH,
        eventPlayer.eventId == MechEventId.STEALTH_CROUCH,
        eventPlayer.isHoldingButton(Button.CROUCH) == true,
        eventPlayer.isMoving(),
        eventPlayer.getSpeed() != 0
    ]) == true
    
    wait(EVT_MECH_3_TICK_INTERVAL, Wait.ABORT_WHEN_FALSE)
    damage(eventPlayer, null, eventPlayer.maxHealthPercent(EVT_MECH_3_HP_COST_RATIO * 100))
    if ruleCondition:
        loop()
    wait(1)
