#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine drawForcedEvent

# 强制类型抽样的掷骰界：去重生效的轮数与总轮数。沿用拒绝采样的有界终止模型，
# 耗尽后采用最后一个合格候选；区间整体不可得时返回 null 交给调用方回落。
#!define EVT_FORCED_SAMPLE_DEDUP_TRIES 8
#!define EVT_FORCED_SAMPLE_TRIES 12

# 强制类型契约：eventForceType 存放显式 EventType（非历史概率阈值）。
# 统一目录槽位按 Buff → Debuff → Mech 连续排布（eventIds.opy 声明顺序即槽位号），
# 因此强制类型只在本类型的数值区间内直接取标量号，不构造按类别过滤的完整数组。
# 每次取号仍须全部满足：注册类型与强制类型一致、属于玩家兼容基础池（构建注册 +
# 结构兼容）、目录权重 > 0、动态硬资格。任一不过即重抽，重试耗尽也不放行。
def drawForcedEvent():
    @Name "[VishkarEvent]: draw forced-type event"

    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    # -1 哨兵：0 是合法事件 ID 且 Workshop 中 0==null，-1 才能区分“无候选”
    eventPlayer.eventCandidateIndex = -1
    while eventPlayer.eventIsSelected == false and eventPlayer.eventLoopCount < EVT_FORCED_SAMPLE_TRIES:
        if eventPlayer.eventLoopCount > 0:
            wait(0.016)
        if eventPlayer.eventForceType == EventType.DEBUFF:
            eventPlayer.eventForceIndex = random.randint(EventId.GRAVITY_ANOMALY, EventId.EXTREME_CHALLENGE - 1)
        elif eventPlayer.eventForceType == EventType.MECH:
            eventPlayer.eventForceIndex = random.randint(EventId.EXTREME_CHALLENGE, EventId.COUNT - 1)
        else:
            eventPlayer.eventForceIndex = random.randint(0, EventId.GRAVITY_ANOMALY - 1)
        eventPlayer.eventLoopCount++
        # 最近事件去重只在去重窗口内且尚无合格候选时生效：
        # 窗口后仍无合格候选等价于“去重致空”，按候选池既有兜底放开去重，但不跨类型
        if eventCatalogType[eventPlayer.eventForceIndex] == eventPlayer.eventForceType and eventPlayer.eventForceIndex in eventPlayer.eventCompatibleBasePool and eventCatalogWeight[eventPlayer.eventForceIndex] > 0:
            eventPlayer.eventTempIndex = [eventPlayer.eventForceIndex]
            filterEventHardEligible()
        else:
            eventPlayer.eventTempIndex = []
        if len(eventPlayer.eventTempIndex) > 0 and (eventPlayer.eventLastId == null or eventPlayer.eventForceIndex not in eventPlayer.eventLastId or (eventPlayer.eventLoopCount > EVT_FORCED_SAMPLE_DEDUP_TRIES and eventPlayer.eventCandidateIndex == -1)):
            eventPlayer.eventCandidateIndex = eventPlayer.eventForceIndex
            if random.uniform(0, eventWeight) < eventCatalogWeight[eventPlayer.eventCandidateIndex]:
                eventPlayer.eventIsSelected = true
                break
    if eventPlayer.eventIsSelected == false:
        eventPlayer.eventIsSelected = true
