#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# 自选事件：玩家获得的选择次数（eventPickPending）兑换为一次三选一，确认结果写入承诺槽 eventNextIndex，
# 由 assignPlayerEvent 经 setPlayerEvent 原路消费；系统不再自行掷骰分配事件。
# 候选沿用统一候选池（兼容池、权重、硬资格、先知唯一性、近期去重），不另设资格规则。

# 同一时间全队至多一名持有者的事件：候选池只排除生成时已被占用的，确认时必须再校验一次
#!define EVENT_GROUP_UNIQUE [EventId.PROPHET, EventId.SHARE_THE_PAIN]

rule "[VishkarEvent]: build event offer":
    @Event eachPlayer
    @Team 1
    @Condition getNumberOfPlayers(Team.2) == len(bastionPosition)
    @Condition all([vishkarEventActivated, eventPlayer.hasSpawned(), eventPlayer.eventId == -1, eventPlayer.eventPickPending > 0, eventPlayer.eventPickReady == false, len(eventPlayer.eventOffer) == 0]) == true
    @Condition eventPlayer.eventCompatibleBasePool != null
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer)

    # eventAssigning 覆盖整个生成过程：eventCandidateIndex / eventTempIndex 被本流程占用，先知坍缩不得并发重掷
    eventPlayer.eventAssigning = true
    buildCandidatePool()
    # 窃贼标记只在其实际过滤了候选池的一次生成上消耗（与 setPlayerEvent 的候选池路径一致）
    if eventPlayer.thiefBuffStolen == true:
        eventPlayer.thiefBuffStolen = false
    # 强制类型契约把候选限定在声明类型内；该类型暂无候选时回落统一池，契约保留
    if eventPlayer.eventForceType != -1:
        eventPlayer.eventCandidateIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] == eventPlayer.eventForceType)
        if len(eventPlayer.eventCandidateIndex) > 0:
            eventPlayer.eventTempIndex = eventPlayer.eventCandidateIndex
    while len(eventPlayer.eventOffer) < EVT_PICK_OFFER_COUNT and len(eventPlayer.eventTempIndex) > 0:
        wait(getAverageServerLoad() * 0.00032)
        rejecSampling()
        eventPlayer.eventOffer.append(eventPlayer.eventCandidateIndex)
        eventPlayer.eventTempIndex.remove(eventPlayer.eventCandidateIndex)
    eventPlayer.eventAssigning = false
    # 候选池为空时间隔重试：此时 eventOffer 仍为空，规则条件持续成立
    wait(2)
    if ruleCondition:
        loop()


# 按住互动键再按选项键确认：互动键在正常游戏中几乎不会被长按，不占用英雄技能键，也不需要锁定按键
rule "[VishkarEvent]: confirm event pick":
    @Event eachPlayer
    @Team 1
    @Condition len(eventPlayer.eventOffer) > 0
    @Condition eventPlayer.eventPickReady == false
    @Condition eventPlayer.menu == 0
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition any([eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), eventPlayer.isHoldingButton(Button.SECONDARY_FIRE), eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_PICK_CONFIRM_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventPickIndex = 0 if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) else 1 if eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) else 2
    if eventPlayer.eventPickIndex >= len(eventPlayer.eventOffer):
        return
    if eventPlayer.eventOffer[eventPlayer.eventPickIndex] in EVENT_GROUP_UNIQUE and len(getPlayers(Team.1).filter(lambda other: other != eventPlayer and (other.eventId == eventPlayer.eventOffer[eventPlayer.eventPickIndex] or other.eventNextIndex == eventPlayer.eventOffer[eventPlayer.eventPickIndex]))) > 0:
        smallMessage(eventPlayer, STR_MSG_EVENT_PICK_TAKEN.format(iconString(Icon.WARNING)))
        eventPlayer.eventOffer = []
        return
    eventPlayer.eventNextIndex = eventPlayer.eventOffer[eventPlayer.eventPickIndex]
    eventPlayer.eventOffer = []
    eventPlayer.eventPickPending--
    eventPlayer.eventPickReady = true
