#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

playervar eventCandidateId

subroutine rejecSampling

def rejecSampling():
    @Name "[VishkarEvent]: set player event"
    
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
        if eventPlayer.eventLoopCount > 0:
            wait(0.016)
        eventPlayer.eventCandidateId = random.choice(eventPlayer.eventTempId)
        eventPlayer.eventTempWeight = (buffEvent[eventPlayer.eventCandidateId][3] if eventPlayer.eventType == EventType.BUFF else debuffEvent[eventPlayer.eventCandidateId][3] if eventPlayer.eventType == EventType.DEBUFF else mechEvent[eventPlayer.eventCandidateId][3])
        if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
            eventPlayer.eventId = eventPlayer.eventCandidateId
            eventPlayer.eventIsSelected = true
            break
        eventPlayer.eventLoopCount++
    if eventPlayer.eventIsSelected == false:
        eventPlayer.eventId = eventPlayer.eventCandidateId
