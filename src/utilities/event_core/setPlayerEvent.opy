#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerEvent
subroutine commitPlayerEventCategory
subroutine rerollNextEvent

# 承诺槽模型：eventNextIndex 记录“已确定的下一个事件”，由先知观测坍缩或
# 待掷旗标变更路径（窃贼/赌徒等 rerollNextEvent 调用点）按需写入，不做常态预取；
# 下一次 setPlayerEvent 直接消费该承诺——预览与实发恒等。无承诺时正常走候选池掷骰。
# 资格门槛只在掷骰当时判定；承诺一旦作出，即使门槛随后失效（如心之钢层数
# 被花掉）也不再重验——以这种可接受的滞后换取“权威真实 next event”。
# eventNextIndex 必须跨 clearPlayerEvent 存活到下一次分配，因此不能在那里清零；
# 生命周期终点 = 消费、玩家重置、离开/重进。

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
        # 周年挑战 66：对局已被先知观测后才累计减益抽取
        if prophetObserved == true:
            eventPlayer.dlcTimeChallenge[1]++
    elif eventPlayer.eventType == EventType.MECH:
        eventPlayer.eventCount[EventType.MECH]++
        # 周年挑战 65：先知实发计数
        if eventPlayer.eventId == EventId.PROPHET:
            eventPlayer.dlcTimeChallenge[0]++
    else:
        return
    eventPlayer.eventCategoryCommitted = true

def setPlayerEvent():
    @Name "[VishkarEvent]: set player event"

    if eventPlayer.eventNextIndex != null:
        eventPlayer.eventCandidateIndex = eventPlayer.eventNextIndex
        eventPlayer.eventNextIndex = null
        eventPlayer.eventIsSelected = true
        # Unique 兜底：承诺先知在先，他人在此期间先一步成为先知。
        # 唯一性优先于承诺——按候选池（Unique 门控已剔除先知）重掷。
        if eventPlayer.eventCandidateIndex == EventId.PROPHET and len(getPlayers(Team.2).filter(lambda other: other != eventPlayer and other.eventType == EventType.MECH and other.eventId == EventId.PROPHET)) > 0:
            buildCandidatePool()
            wait(getAverageServerLoad() / 100 * 0.032)
            rejecSampling()
    else:
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

def rerollNextEvent():
    @Name "[VishkarEvent]: reroll committed next event"

    # 供先知观测坍缩及事件效果在改写 eventForceRoll / thiefBuffStolen 等待掷旗标后调用：
    # 已承诺的 eventNextIndex 立刻按最新旗标重取，保证预览与实发一致。
    # 旗标变更路径的调用约定：仅当 eventNextIndex != null 时才调用（无承诺不浪费掷骰）。
    buildCandidatePool()
    wait(getAverageServerLoad() / 100 * 0.032)
    rejecSampling()
    eventPlayer.eventNextIndex = eventPlayer.eventCandidateIndex
