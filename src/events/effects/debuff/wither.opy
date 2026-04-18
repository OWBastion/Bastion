#!mainFile "../../main.opy"

# Event: DebuffEventId.WITHER

rule "[VishkarEvent]: 枯萎":
    @Event playerReceivedHealing
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.WITHER, eventHealing > 0]) == true

    if eventPlayer.eventMission < EVT_DEBUFF_22_STACK_CAP:
        eventPlayer.eventMission++
    eventPlayer.mod_speed_event = eventPlayer.eventMission * EVT_DEBUFF_22_SPEED_DELTA_PER_STACK
    eventPlayer.mod_dmg_taken = eventPlayer.eventMission * EVT_DEBUFF_22_DMG_TAKEN_PER_STACK
    eventPlayer.hudText = "枯萎：{0}层".format(eventPlayer.eventMission)
    updatePlayerStats()
    if eventPlayer.eventMissionGoal == 0:
        eventPlayer.eventMissionGoal = 1
    wait(1)

rule "[VishkarEvent]: 枯萎 (12秒清零)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.WITHER, eventPlayer.eventMission > 0, eventPlayer.eventMissionGoal == 1]) == true

    eventPlayer.eventMissionGoal = 2
    wait(EVT_DEBUFF_22_STACK_WINDOW, Wait.IGNORE_CONDITION)
    if eventPlayer.eventMissionGoal != 2:
        goto lbl_0
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.mod_speed_event = 0
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.hudText = ""
    updatePlayerStats()
    lbl_0:
