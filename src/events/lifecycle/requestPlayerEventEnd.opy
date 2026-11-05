#!mainFile "../../main.opy"

#!optimizeStrict

subroutine requestPlayerEventEnd

def requestPlayerEventEnd():
    @Name "[VishkarEvent]: request player event end"

    if eventPlayer.eventId != -1:
        eventPlayer.eventEndTime = getTotalTimeElapsed()
        eventPlayer.eventDurationHud = 0
