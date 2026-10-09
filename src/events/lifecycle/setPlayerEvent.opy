#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerEvent
subroutine commitPlayerEventCategory

def commitPlayerEventCategory():
    @Name "[VishkarEvent]: commit player event category"

    if eventPlayer.eventCategoryCommitted == true or eventPlayer.eventIsSelected == false:
        return
    if eventPlayer.eventType == EventType.BUFF:
        if eventPlayer.eventId == EventId.OLIVIA_GIFT:
            goto lbl_0
        eventPlayer.eventCount[EventType.BUFF]++
        lbl_0:
        eventPlayer.eventLucky = eventPlayer.eventLucky + 1 if eventPlayer.eventLucky > 0 else 1
    elif eventPlayer.eventType == EventType.DEBUFF:
        eventPlayer.eventCount[EventType.DEBUFF]++
        eventPlayer.eventLucky = eventPlayer.eventLucky - 1 if eventPlayer.eventLucky < 0 else -1
    elif eventPlayer.eventType == EventType.MECH:
        eventPlayer.eventCount[EventType.MECH]++
    else:
        return
    eventPlayer.eventCategoryCommitted = true

def setPlayerEvent():
    @Name "[VishkarEvent]: set player event"

    buildCandidatePool()
    wait(getAverageServerLoad() / 100 * 0.032)
    rejecSampling()
    if eventPlayer.thiefBuffStolen == true:
        eventPlayer.thiefBuffStolen = false
    eventPlayer.eventCategoryCommitted = false
    eventPlayer.eventType = eventCatalogType[eventPlayer.eventCandidateIndex]
    eventPlayer.eventId = eventPlayer.eventCandidateIndex
    # 逐事件哨兵在分配时强制归零：上一事件的规则可能有越过 clearPlayerEvent 的迟到写入
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.eventName = eventName[eventPlayer.eventCandidateIndex]
    eventPlayer.eventDesc = eventDesc[eventPlayer.eventCandidateIndex]
    eventPlayer.eventDuration = eventDuration[eventPlayer.eventCandidateIndex]
    commitPlayerEventCategory()
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.eventLastId == null:
        eventPlayer.eventLastId = []
    if eventPlayer.eventForceRoll != null:
        if eventPlayer.eventForceCount > 0:
            eventPlayer.eventForceCount--
        else:
            eventPlayer.eventForceRoll = null
    eventPlayer.eventLastId.append(eventPlayer.eventCandidateIndex)
    if len(eventPlayer.eventLastId) > EVT_RECENT_EVENT_DEDUP_COUNT:
        eventPlayer.eventLastId = eventPlayer.eventLastId.slice(len(eventPlayer.eventLastId) - EVT_RECENT_EVENT_DEDUP_COUNT)
    if eventPlayer.eventDesc == null:
        goto lbl_1
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
    setEventDuration()
    lbl_1:
