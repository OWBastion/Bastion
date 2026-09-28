#!mainFile "../../../main.opy"

#!optimizeStrict

# Event: BuffEventId.WHERE_YOU_FALL

rule "[VishkarEvent]: 在哪里跌倒（预备态）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL, eventPlayer.hasStatus(Status.UNKILLABLE) != true]) == true

    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, eventPlayer.eventDuration)

rule "[VishkarEvent]: 在哪里跌倒":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL, eventPlayer.eventMission == 0, eventPlayer.eventDurationHud > 0, eventPlayer.hasStatus(Status.UNKILLABLE)]) == true
    @Condition eventDamage >= eventPlayer.getHealth()

    # eventMission marks a pending rescue so unrelated knockdowns are not treated as this event's state.
    eventPlayer.eventMission = 1
    eventPlayer.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, eventPlayer.eventDurationHud)
    smallMessage(getPlayers(Team.1), STR_EVT_BUFF_33_DOWNED.format(eventPlayer, EVT_33_RESCUE_RADIUS, Button.INTERACT, EVT_33_RESCUE_TIME))

rule "[VishkarEvent]: 在哪里跌倒（救援）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL, eventPlayer.eventMission == 1, eventPlayer.eventDurationHud > 0, eventPlayer.hasStatus(Status.KNOCKED_DOWN)]) == true
    @Condition len([player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.isHoldingButton(Button.INTERACT) and distance(player, eventPlayer) <= EVT_33_RESCUE_RADIUS]) > 0

    wait(EVT_33_RESCUE_TIME, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
        eventPlayer.setHealth(eventPlayer.maxHealthPercent(EVT_33_REVIVE_HEALTH_RATIO * 100))
        eventPlayer.eventMission = 0
        smallMessage(eventPlayer, STR_EVT_BUFF_33_RESCUED.format(percent(EVT_33_REVIVE_HEALTH_RATIO)))
