#!mainFile "../../main.opy"

#!optimizeStrict

subroutine requestPlayerEventEnd
subroutine waitPlayerEventEnd

def requestPlayerEventEnd():
    @Name "[VishkarEvent]: request player event end"

    if eventPlayer.eventId != -1:
        eventPlayer.eventEndTime = getTotalTimeElapsed()
        eventPlayer.eventDurationHud = 0

def waitPlayerEventEnd():
    @Name "[VishkarEvent]: wait player event end"

    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)

def waitLoadBrief():
    wait(getAverageServerLoad() * 0.00032)

def waitLoadShort():
    wait(getAverageServerLoad() * 0.005)

def waitLoadLong():
    wait(getAverageServerLoad() * 0.01)

def waitAllSpawned():
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)

def waitHeroMatch():
    waitUntil(eventPlayer.getHero() == heroList[eventPlayer.heroNumber], 0.5)

def waitTick2():
    wait(0.032)
