#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setEventDuration

def setEventDuration():
    @Name "[VishkarEvent]: set Event Duration"

    eventPlayer.eventDurationHud = eventPlayer.eventDuration

rule "[VishkarEvent]: tick event duration hud":
    @Event eachPlayer
    @Condition eventPlayer.eventId != -1
    @Condition eventPlayer.eventDurationHud > 0

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventDurationHud -= 1
    if ruleCondition:
        loop()
