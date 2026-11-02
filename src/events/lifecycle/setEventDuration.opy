#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setEventDuration

def setEventDuration():
    @Name "[VishkarEvent]: set Event Duration"

    eventPlayer.eventEndTime = getTotalTimeElapsed() + eventDuration[eventPlayer.eventId]
