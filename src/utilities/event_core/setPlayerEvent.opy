#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerEvent

def setPlayerEvent():
    @Name "[VishkarEvent]: set player event"
    
    if eventPlayer.eventForceRoll != null:
        eventPlayer.categoryRoll = eventPlayer.eventForceRoll
        if eventPlayer.eventForceCount > 0:
            eventPlayer.eventForceCount--
        else:
            eventPlayer.eventForceRoll = null
    else:
        eventPlayer.categoryRoll = random.randint(0, 100)
    if eventPlayer.categoryRoll <= 45:
        eventPlayer.eventType = 0
        rejecSampling()
        eventPlayer.eventName = buffEvent[eventPlayer.eventId][0]
        eventPlayer.eventDesc = buffEvent[eventPlayer.eventId][1]
        eventPlayer.eventDuration = buffEvent[eventPlayer.eventId][2]
        if eventPlayer.eventId == BuffEventId.OLIVIA_GIFT:
            goto lbl_0
        eventPlayer.eventCount[0]++
        lbl_0:
        eventPlayer.eventLucky = eventPlayer.eventLucky + 1 if eventPlayer.eventLucky > 0 else 1
    elif eventPlayer.categoryRoll <= 80:
        eventPlayer.eventType = 1
        rejecSampling()
        eventPlayer.eventName = debuffEvent[eventPlayer.eventId][0]
        eventPlayer.eventDesc = debuffEvent[eventPlayer.eventId][1]
        eventPlayer.eventDuration = debuffEvent[eventPlayer.eventId][2]
        eventPlayer.eventCount[1]++
        eventPlayer.eventLucky = eventPlayer.eventLucky - 1 if eventPlayer.eventLucky < 0 else -1
    else:
        eventPlayer.eventType = 2
        rejecSampling()
        eventPlayer.eventName = mechEvent[eventPlayer.eventId][0]
        eventPlayer.eventDesc = mechEvent[eventPlayer.eventId][1]
        eventPlayer.eventDuration = mechEvent[eventPlayer.eventId][2]
        eventPlayer.eventCount[2]++
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.eventLastId == null:
        eventPlayer.eventLastId = []
    eventPlayer.eventLastId.append(eventPlayer.eventType * EVT_DEDUP_TYPE_MULTIPLIER + eventPlayer.eventId)
    if len(eventPlayer.eventLastId) > EVT_RECENT_EVENT_DEDUP_COUNT:
        eventPlayer.eventLastId = eventPlayer.eventLastId.slice(len(eventPlayer.eventLastId) - EVT_RECENT_EVENT_DEDUP_COUNT)
    if eventPlayer.eventDesc == null:
        goto lbl_1
    if eventPlayer.eventId == 666:
        goto lbl_2
    smallMessage(
    eventPlayer, 
        STR_MSG_EVENT_TRIGGER.format(
            abilityIconString(Hero.SOMBRA, Button.ULTIMATE), 
            eventPlayer.eventName, 
            STR_MSG_DURATION_SEC.format(eventPlayer.eventDuration) if eventPlayer.eventDuration > 0 else STR_MSG_DURATION_INSTANT
        )
    )

    smallMessage(
        eventPlayer, 
        STR_MSG_EVENT_EFFECT.format(
            abilityIconString(Hero.SOMBRA, Button.ULTIMATE), 
            eventPlayer.eventDesc.replace("\n", "，")
        )
    )
    lbl_2:
    setEventDuration()
    lbl_1:
