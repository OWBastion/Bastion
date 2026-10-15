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

    # 强制类型契约优先于候选池：付费/契约声明的下一个事件类型在自身 ID 区间内直接
    # 抽样（drawForcedEvent），窃贼窃取等普通候选修饰不生效。强制类型暂无可满足
    # 候选时回落统一池，旗标保留待后续兑现。eventCandidateIndex 用 -1 表示无候选，
    # 因为 0 是合法事件 ID 且 Workshop 中 0==null。
    eventPlayer.eventCandidateIndex = -1
    if eventPlayer.eventForceType != -1:
        drawForcedEvent()
        wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.eventCandidateIndex == -1:
        buildCandidatePool()
        wait(getAverageServerLoad() / 100 * 0.032)
        rejecSampling()
        # 窃贼标记只在其实际过滤了候选池的分配上消耗；强制非增益分配不消耗挂起状态
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
    # 强制契约按实际兑现消费：分配未落在声明类型上（区间暂不可得而回落）不扣次数
    if eventPlayer.eventForceType != -1 and eventPlayer.eventType == eventPlayer.eventForceType:
        if eventPlayer.eventForceCount > 0:
            eventPlayer.eventForceCount--
        else:
            eventPlayer.eventForceType = -1
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
