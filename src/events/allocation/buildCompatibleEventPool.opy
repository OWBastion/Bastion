#!mainFile "../main.opy"

#!optimizeStrict

subroutine refreshCompatibleEventPool

#!define EVENT_GROUP_PHASE_TRIGGER [EventId.PHASE_SURGE, EventId.BODYGUARD]

macro Player.supportsPhaseTrigger():
    (self.getHero() in phaseHero[0] or self.getHero() in phaseHero[1] or self.getHero() in phaseHero[2] or self.getHero() in phaseHero[3] or isHero(self, Hero.BRIGITTE) or self.getHero() in phaseHero[4])

def refreshCompatibleEventPool():
    @Name "[VishkarEvent]: refresh player compatible event pool"

    waitUntil((eventPlayer.joinTime and vishkarEventActivated == true and phaseHero[0] and eventCatalogId), 125)
    if not (eventPlayer.joinTime and vishkarEventActivated == true and phaseHero[0] and eventCatalogId):
        return
    eventPlayer.eventCompatibleBasePool = eventCatalogId.slice(0, len(eventCatalogId))
    if eventPlayer.supportsPhaseTrigger() == false:
        eventPlayer.eventCompatibleBasePool = eventPlayer.eventCompatibleBasePool.filter(lambda candidateIndex: candidateIndex not in EVENT_GROUP_PHASE_TRIGGER)
    waitLoadBrief()


rule "initialize player compatible event pool":
    @Event playerJoined
    @Team 1

    refreshCompatibleEventPool()
