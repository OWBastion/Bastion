#!mainFile "../main.opy"

#!optimizeStrict

subroutine refreshCompatibleEventPool

#!define EVENT_GROUP_PHASE_TRIGGER [BuffEventId.PHASE_SURGE, BuffEventId.BODYGUARD]

macro Player.supportsPhaseTrigger():
    any([
        self.getHero() in phaseHero[0],
        self.getHero() in phaseHero[1],
        self.getHero() in phaseHero[2],
        self.getHero() in phaseHero[3],
        isHero(self, Hero.BRIGITTE),
        self.getHero() in phaseHero[4]
    ])

def refreshCompatibleEventPool():
    @Name "[VishkarEvent]: refresh player compatible event pool"

    waitUntil(all([eventPlayer.joinTime != null, vishkarEventActivated == true, phaseHero[0] != null, eventCatalogId != null]), 125)
    if all([eventPlayer.joinTime != null, vishkarEventActivated == true, phaseHero[0] != null, eventCatalogId != null]) == false:
        return
    eventPlayer.eventCompatibleBasePool = eventCatalogId.slice(0, len(eventCatalogId))
    if eventPlayer.supportsPhaseTrigger() == false:
        eventPlayer.eventCompatibleBasePool = eventPlayer.eventCompatibleBasePool.filter(lambda candidateIndex: candidateIndex not in EVENT_GROUP_PHASE_TRIGGER)
    wait(getAverageServerLoad() / 100 * 0.032)


rule "initialize player compatible event pool":
    @Event playerJoined
    @Team 1

    refreshCompatibleEventPool()
