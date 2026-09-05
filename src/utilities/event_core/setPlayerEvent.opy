#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerEvent

def setPlayerEvent():
    @Name "[VishkarEvent]: set player event"
    
    if eventPlayer.eventForceRoll != null:
        eventPlayer.temp = eventPlayer.eventForceRoll
    else:
        eventPlayer.temp = eventPlayer.categoryRoll if eventPlayer.categoryRoll != null else random.uniform(0, 100)
    if eventPlayer.temp < 42.5:
        eventPlayer.eventType = EventType.BUFF
        buildCandidatePool()
        wait(getAverageServerLoad() / 100 * 0.032)
        rejecSampling()
        eventPlayer.eventName = buffEventName[eventPlayer.eventId]
        eventPlayer.eventDesc = buffEventDesc[eventPlayer.eventId]
        eventPlayer.eventDuration = buffEventDuration[eventPlayer.eventId]
        if eventPlayer.eventId == BuffEventId.OLIVIA_GIFT:
            goto lbl_0
        eventPlayer.eventCount[EventType.BUFF]++
        lbl_0:
        eventPlayer.eventLucky = eventPlayer.eventLucky + 1 if eventPlayer.eventLucky > 0 else 1
    elif eventPlayer.temp < 80:
        eventPlayer.eventType = EventType.DEBUFF
        buildCandidatePool()
        wait(getAverageServerLoad() / 100 * 0.032)
        rejecSampling()
        eventPlayer.eventName = debuffEventName[eventPlayer.eventId]
        eventPlayer.eventDesc = debuffEventDesc[eventPlayer.eventId]
        eventPlayer.eventDuration = debuffEventDuration[eventPlayer.eventId]
        eventPlayer.eventCount[EventType.DEBUFF]++
        eventPlayer.eventLucky = eventPlayer.eventLucky - 1 if eventPlayer.eventLucky < 0 else -1
    else:
        eventPlayer.eventType = EventType.MECH
        buildCandidatePool()
        wait(getAverageServerLoad() / 100 * 0.032)
        rejecSampling()
        eventPlayer.eventName = mechEventName[eventPlayer.eventId]
        eventPlayer.eventDesc = mechEventDesc[eventPlayer.eventId]
        eventPlayer.eventDuration = mechEventDuration[eventPlayer.eventId]
        eventPlayer.eventCount[EventType.MECH]++
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.eventLastId == null:
        eventPlayer.eventLastId = []
    if eventPlayer.eventForceRoll != null:
        if eventPlayer.eventForceCount > 0:
            eventPlayer.eventForceCount--
        else:
            eventPlayer.eventForceRoll = null
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
