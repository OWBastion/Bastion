#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

playervar eventCandidateId

subroutine rejecSampling

def rejecSampling():
    @Name "[VishkarEvent]: set player event"
    
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    if eventPlayer.eventType == 0:
        eventPlayer.eventTempId = buffEventId.filter(lambda id:
            buffEvent[id] != 0 and buffEvent[id].last() > 0 and (eventPlayer.eventLastId == null or (0 * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = buffEventId.filter(lambda id: buffEvent[id] != 0 and buffEvent[id].last() > 0)
        while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
            if eventPlayer.eventLoopCount > 0:
                wait(0.016)
            eventPlayer.eventCandidateId = random.choice(eventPlayer.eventTempId)
            eventPlayer.eventTempWeight = buffEvent[eventPlayer.eventCandidateId][3]
            if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
                eventPlayer.eventId = eventPlayer.eventCandidateId
                eventPlayer.eventIsSelected = true
                break
            eventPlayer.eventLoopCount++
        if eventPlayer.eventIsSelected == false:
            eventPlayer.eventId = eventPlayer.eventCandidateId
    elif eventPlayer.eventType == 1:
        eventPlayer.eventTempId = debuffEventId.filter(lambda id:
            debuffEvent[id] != 0 and debuffEvent[id].last() > 0 and (eventPlayer.eventLastId == null or (1 * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id: debuffEvent[id] != 0 and debuffEvent[id].last() > 0)
        while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
            if eventPlayer.eventLoopCount > 0:
                wait(0.016)
            eventPlayer.eventCandidateId = random.choice(eventPlayer.eventTempId)
            eventPlayer.eventTempWeight = debuffEvent[eventPlayer.eventCandidateId][3]
            if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
                eventPlayer.eventId = eventPlayer.eventCandidateId
                eventPlayer.eventIsSelected = true
                break
            eventPlayer.eventLoopCount++
        if eventPlayer.eventIsSelected == false:
            eventPlayer.eventId = eventPlayer.eventCandidateId
    else:
        eventPlayer.eventTempId = mechEventId.filter(lambda id:
            mechEvent[id] != 0 and mechEvent[id].last() > 0 and (eventPlayer.eventLastId == null or (2 * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = mechEventId.filter(lambda id: mechEvent[id] != 0 and mechEvent[id].last() > 0)
        while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
            if eventPlayer.eventLoopCount > 0:
                wait(0.016)
            eventPlayer.eventCandidateId = random.choice(eventPlayer.eventTempId)
            eventPlayer.eventTempWeight = mechEvent[eventPlayer.eventCandidateId][3]
            if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
                eventPlayer.eventId = eventPlayer.eventCandidateId
                eventPlayer.eventIsSelected = true
                break
            eventPlayer.eventLoopCount++
        if eventPlayer.eventIsSelected == false:
            eventPlayer.eventId = eventPlayer.eventCandidateId
