#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine rejecSampling

def rejecSampling():
    @Name "[VishkarEvent]: set player event"
    
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false

    if eventPlayer.eventType == 0:
        eventPlayer.eventTempId = [
            id for id in buffEventId.exclude(eventPlayer.eventLastId)
            if (buffEvent[id] != 0 and buffEvent[id].last() > 0)
        ]
    elif eventPlayer.eventType == 1:
        eventPlayer.eventTempId = [
            id for id in debuffEventId.exclude(eventPlayer.eventLastId)
            if (debuffEvent[id] != 0 and debuffEvent[id].last() > 0)
        ]
    else:
        eventPlayer.eventTempId = [
            id for id in mechEventId.exclude(eventPlayer.eventLastId)
            if (mechEvent[id] != 0 and mechEvent[id].last() > 0)
        ]

    if len(eventPlayer.eventTempId) == 0:
        if eventPlayer.eventType == 0:
            eventPlayer.eventTempId = [id for id in buffEventId if (buffEvent[id] != 0 and buffEvent[id].last() > 0)]
        elif eventPlayer.eventType == 1:
            eventPlayer.eventTempId = [id for id in debuffEventId if (debuffEvent[id] != 0 and debuffEvent[id].last() > 0)]
        else:
            eventPlayer.eventTempId = [id for id in mechEventId if (mechEvent[id] != 0 and mechEvent[id].last() > 0)]

    while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
        eventPlayer.eventId = random.choice(eventPlayer.eventTempId)
        if eventPlayer.eventType == 0:
            eventPlayer.eventTempWeight = buffEvent[eventPlayer.eventId][3]
        elif eventPlayer.eventType == 1:
            eventPlayer.eventTempWeight = debuffEvent[eventPlayer.eventId][3]
        else:
            eventPlayer.eventTempWeight = mechEvent[eventPlayer.eventId][3]
        if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
            eventPlayer.eventIsSelected = true
            break
        eventPlayer.eventLoopCount++
