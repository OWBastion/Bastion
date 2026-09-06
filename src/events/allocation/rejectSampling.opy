#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine rejecSampling

def rejecSampling():
    @Name "[VishkarEvent]: set player event"
    
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < 8:
        if eventPlayer.eventLoopCount > 0:
            wait(0.016)
        eventPlayer.eventCandidateIndex = random.choice(eventPlayer.eventTempIndex)
        eventPlayer.eventTempWeight = eventPoolWeight[eventPlayer.eventCandidateIndex]
        if random.uniform(0, eventWeight) < eventPlayer.eventTempWeight:
            eventPlayer.eventIsSelected = true
            break
        eventPlayer.eventLoopCount++
    if eventPlayer.eventIsSelected == false:
        eventPlayer.eventIsSelected = true
