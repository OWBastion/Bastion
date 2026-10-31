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
    # 已承诺的下一个事件（eventNextIndex，先知观测坍缩/旗标变更重取产生）优先于
    # 一切掷骰路径——预览与实发恒等；承诺在作出时已带全部旗标与门控。
    eventPlayer.eventCandidateIndex = -1
    if eventPlayer.eventNextIndex != -1:
        eventPlayer.eventCandidateIndex = eventPlayer.eventNextIndex
        eventPlayer.eventNextIndex = -1
        eventPlayer.eventIsSelected = true
        # Unique 兜底：承诺先知在先，他人在此期间先一步成为先知。
        # 唯一性优先于承诺——作废承诺，改走正常契约/候选池路径（Unique 门控已剔除先知）。
        if eventPlayer.eventCandidateIndex == EventId.PROPHET and len(getPlayers(Team.1).filter(lambda other: other != eventPlayer and other.eventId == EventId.PROPHET)) > 0:
            eventPlayer.eventCandidateIndex = -1
    if eventPlayer.eventCandidateIndex == -1 and eventPlayer.eventForceType != -1:
        drawForcedEvent()
        waitLoadBrief()
    if eventPlayer.eventCandidateIndex == -1:
        buildCandidatePool()
        waitLoadBrief()
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
    setEventDuration()
    commitPlayerEventCategory()
    waitLoadBrief()
    if eventPlayer.eventLastId == null:
        eventPlayer.eventLastId = []
    # 强制契约按实际兑现消费：分配未落在声明类型上（区间暂不可得而回落）不扣次数
    if eventPlayer.eventForceType != -1 and eventPlayer.eventType == eventPlayer.eventForceType:
        # ？？？连锁：兑现对 = 旗标来源事件 → 实际分配事件。暗箱→验牌 武装连锁，验牌→奥利维娅的礼物 达成
        if eventPlayer.eventForceSourceId == EventId.CHEAT_BACKROOM_DEAL and eventPlayer.eventCandidateIndex == EventId.CHEAT_CARD_COUNTING:
            eventPlayer.dlcTimeChallenge[1] = 1
        elif eventPlayer.dlcTimeChallenge[1] == 1:
            eventPlayer.dlcTimeChallenge[1] = 2 if (eventPlayer.eventForceSourceId == EventId.CHEAT_CARD_COUNTING and eventPlayer.eventCandidateIndex == EventId.OLIVIA_GIFT) else 0
        if eventPlayer.eventForceCount > 0:
            eventPlayer.eventForceCount--
        else:
            eventPlayer.eventForceType = -1
            eventPlayer.eventForceSourceId = -1
    elif eventPlayer.dlcTimeChallenge[1] == 1 and eventPlayer.eventForceSourceId != EventId.CHEAT_CARD_COUNTING:
        # 连锁待决期间：仅当验牌的强制增益旗标仍挂起（回落分配）时连锁存活，其余分配使其失效
        eventPlayer.dlcTimeChallenge[1] = 0
    eventPlayer.eventLastId.append(eventPlayer.eventCandidateIndex)
    if len(eventPlayer.eventLastId) > EVT_RECENT_EVENT_DEDUP_COUNT:
        eventPlayer.eventLastId = eventPlayer.eventLastId.slice(len(eventPlayer.eventLastId) - EVT_RECENT_EVENT_DEDUP_COUNT)
    if eventPlayer.eventType == EventType.BUFF:
        playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENADE_INCREASED_HEALING_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    elif eventPlayer.eventType == EventType.DEBUFF:
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    else:
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Color.WHITE, eventPlayer.getPosition(), 200)
    if eventPlayer.eventDesc != null:
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
                eventPlayer.eventDesc
            )
        )


def rerollNextEvent():
    @Name "[VishkarEvent]: reroll committed next event"

    # 供先知观测坍缩及事件效果在改写 eventForceType / thiefBuffStolen 等待掷旗标后调用：
    # 已承诺的 eventNextIndex 立刻按最新旗标重取，保证预览与实发一致。
    # 旗标变更路径的调用约定：仅当 eventNextIndex != -1 时才调用（无承诺不浪费掷骰）。
    # 掷骰顺序与 setPlayerEvent 一致：强制类型契约优先，无契约或契约暂不可兑现时回落候选池。
    eventPlayer.eventCandidateIndex = -1
    if eventPlayer.eventForceType != -1:
        drawForcedEvent()
        waitLoadBrief()
    if eventPlayer.eventCandidateIndex == -1:
        buildCandidatePool()
        waitLoadBrief()
        rejecSampling()
    eventPlayer.eventNextIndex = eventPlayer.eventCandidateIndex
