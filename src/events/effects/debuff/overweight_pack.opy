#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/超重背包"

# Event: DebuffEventId.OVERWEIGHT_PACK

rule "Refresh damage taken":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.OVERWEIGHT_PACK]) == true

    eventPlayer.temp = floor(eventPlayer.getMaxHealth() / EVT_DEBUFF_23_HP_UNIT) * EVT_DEBUFF_23_DMG_TAKEN_PER_UNIT
    if eventPlayer.mod_dmg_taken != eventPlayer.temp:
        eventPlayer.mod_dmg_taken = eventPlayer.temp
        updatePlayerStats()
    wait(EVT_DEBUFF_23_REFRESH_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
    if eventPlayer.mod_dmg_taken != 0:
        eventPlayer.mod_dmg_taken = 0
        updatePlayerStats()
