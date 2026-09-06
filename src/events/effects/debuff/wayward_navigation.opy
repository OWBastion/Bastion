#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/缺德导航"

# Event: DebuffEventId.WAYWARD_NAVIGATION

rule "Random launch":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.DEBUFF
    @Condition eventPlayer.eventId == DebuffEventId.WAYWARD_NAVIGATION
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()

    wait(EVT_DEBUFF_22_INTERVAL, Wait.ABORT_WHEN_FALSE)
    eventPlayer.applyImpulse(directionFromAngles(random.randint(0, 359), 0), EVT_DEBUFF_22_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if ruleCondition:
        loop()
