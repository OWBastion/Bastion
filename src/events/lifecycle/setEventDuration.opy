#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setEventDuration

def setEventDuration():
    @Name "[VishkarEvent]: set Event Duration"

    eventPlayer.eventEndTime = getTotalTimeElapsed() + eventDuration[eventPlayer.eventId]
    eventPlayer.eventDurationHud = eventDuration[eventPlayer.eventId]

rule "[VishkarEvent]: tick event duration hud":
    @Event eachPlayer
    @Condition eventPlayer.eventId != -1
    @Condition eventDuration[eventPlayer.eventId] > 0
    @Condition eventPlayer.eventEndTime > getTotalTimeElapsed()

    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventDurationHud = ceil(max(0, eventPlayer.eventEndTime - getTotalTimeElapsed()))
    if ruleCondition:
        loop()
