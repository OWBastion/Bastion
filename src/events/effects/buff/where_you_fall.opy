#!mainFile "../../../main.opy"

#!optimizeStrict

# Event: BuffEventId.WHERE_YOU_FALL

rule "[VishkarEvent]: 在哪里跌倒（预备态）":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL, eventPlayer.hasStatus(Status.UNKILLABLE) != true]) == true

    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, eventPlayer.eventDuration)
    waitUntil(eventPlayer.eventType != EventType.BUFF or eventPlayer.eventId != BuffEventId.WHERE_YOU_FALL, eventPlayer.eventDuration)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    if eventPlayer.eventMission == 1:
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
        eventPlayer.eventMission = 0
        eventPlayer.targetSilence = false
        kill(eventPlayer, eventPlayer)

rule "[VishkarEvent]: 在哪里跌倒":
    @Event playerTookDamage
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL, eventPlayer.eventMission == 0, eventPlayer.eventDurationHud > 0, eventPlayer.hasStatus(Status.UNKILLABLE)]) == true
    @Condition eventDamage >= eventPlayer.getHealth()

    wait(1)
    if eventPlayer.eventType != EventType.BUFF or eventPlayer.eventId != BuffEventId.WHERE_YOU_FALL:
        return
    # eventMission marks a pending rescue so unrelated knockdowns are not treated as this event's state.
    eventPlayer.eventMission = 1
    # 倒地期间不参与堡垒索敌；复用 targetSilence（救起或事件清理时复位）
    eventPlayer.targetSilence = true
    eventPlayer.setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, eventPlayer.eventDurationHud)
    smallMessage(getPlayers(Team.2), STR_EVT_BUFF_33_DOWNED.format(eventPlayer, EVT_33_RESCUE_RADIUS, Button.INTERACT, EVT_33_RESCUE_TIME))

rule "[VishkarEvent]: 在哪里跌倒（救援）":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL, eventPlayer.eventMission == 1, eventPlayer.eventDurationHud > 0, eventPlayer.hasStatus(Status.KNOCKED_DOWN)]) == true
    @Condition len(getLivingPlayers(Team.2).filter(lambda p: p != eventPlayer and p.hasSpawned() and distance(p, eventPlayer) <= EVT_33_RESCUE_RADIUS and p.isHoldingButton(Button.INTERACT))) > 0

    wait(EVT_33_RESCUE_TIME, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
        eventPlayer.setHealth(eventPlayer.maxHealthPercent(EVT_33_REVIVE_HEALTH_RATIO * 100))
        eventPlayer.eventMission = 0
        eventPlayer.targetSilence = false
        smallMessage(eventPlayer, STR_EVT_BUFF_33_RESCUED.format(percent(EVT_33_REVIVE_HEALTH_RATIO)))
