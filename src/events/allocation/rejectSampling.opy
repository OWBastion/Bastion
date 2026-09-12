#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine rejecSampling

macro eventSamplingWeight(baseWeight):
    min(eventWeight, baseWeight + (eventWeight - baseWeight) * eventWeightBias)

rule "Update event weight bias":
    @Condition vishkarEventActivated == true
    @Condition getTotalTimeElapsed() > EVT_EVENT_WEIGHT_COMPRESSION_START_SEC
    @Condition eventWeightBias < EVT_EVENT_WEIGHT_COMPRESSION_MAX

    switch 1 if getTotalTimeElapsed() <= EVT_EVENT_WEIGHT_COMPRESSION_MID_SEC else 2 if getTotalTimeElapsed() <= EVT_EVENT_WEIGHT_COMPRESSION_END_SEC else 3:
        case 1:
            eventWeightBias = EVT_EVENT_WEIGHT_COMPRESSION_MID * (getTotalTimeElapsed() - EVT_EVENT_WEIGHT_COMPRESSION_START_SEC) / (EVT_EVENT_WEIGHT_COMPRESSION_MID_SEC - EVT_EVENT_WEIGHT_COMPRESSION_START_SEC)
            break
        case 2:
            eventWeightBias = EVT_EVENT_WEIGHT_COMPRESSION_MID + (EVT_EVENT_WEIGHT_COMPRESSION_MAX - EVT_EVENT_WEIGHT_COMPRESSION_MID) * (getTotalTimeElapsed() - EVT_EVENT_WEIGHT_COMPRESSION_MID_SEC) / (EVT_EVENT_WEIGHT_COMPRESSION_END_SEC - EVT_EVENT_WEIGHT_COMPRESSION_MID_SEC)
            break
        case 3:
            eventWeightBias = EVT_EVENT_WEIGHT_COMPRESSION_MAX

    wait(60)

def rejecSampling():
    @Name "[VishkarEvent]: set player event"
    
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
        if eventPlayer.eventLoopCount > 0:
            wait(0.016)
        eventPlayer.eventCandidateIndex = random.choice(eventPlayer.eventTempIndex)
        eventPlayer.eventTempWeight = eventSamplingWeight(eventCatalogWeight[eventPlayer.eventCandidateIndex])
        if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
            eventPlayer.eventIsSelected = true
            break
        eventPlayer.eventLoopCount++
    if eventPlayer.eventIsSelected == false:
        eventPlayer.eventIsSelected = true
