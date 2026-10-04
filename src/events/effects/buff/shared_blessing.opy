#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/有福同享"

# Event: BuffEventId.SHARED_BLESSING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 绑定：持有者按住 INTERACT 满 EVT_INTERACT_HOLD_TIME、EVT_34_BIND_RADIUS 内存在未通关友方即绑定最近者
#（描述文案为持有者"长按互动与最近的队友绑定"，按键主体是持有者而非队友）。
# 判定同钢化你心：绑定时记录双方 heroNumber 基准（eventMission=自己，eventLoopCount=友方），双方各推进一格即双双过线。
# eventMissionGoal>0 兼作"已绑定"标记，防止条件残留导致重复触发；未绑定到期由事件自然到期处理。

# 绑定候选：半径内未通关的存活友方（排除自己）
macro Player.bindCandidates():
    getLivingPlayers(Team.2).filter(lambda p: p != self and p.hasSpawned() and not p.isWinner and distance(p, self) <= EVT_34_BIND_RADIUS)

rule "[VishkarEvent]: 有福同享（绑定）":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 0, eventPlayer.eventDuration > 0, eventPlayer.isHoldingButton(Button.INTERACT)]) == true
    @Condition len(eventPlayer.bindCandidates()) > 0

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        eventPlayer.eventMissionGoal = 1
        eventPlayer.target = sorted(eventPlayer.bindCandidates(), lambda p: distance(p, eventPlayer)).first()
        eventPlayer.eventMission = eventPlayer.heroNumber
        eventPlayer.eventLoopCount = eventPlayer.target.heroNumber
        smallMessage(eventPlayer, "  {0}  与 {1}（{2}）绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer.target, eventPlayer.target.getHero()))
        smallMessage(eventPlayer.target, "  {0}  {1}（{2}）与你绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer, eventPlayer.getHero()))

rule "[VishkarEvent]: 有福同享（结算）":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal > 0, eventPlayer.target != null, eventPlayer.eventDuration > 0]) == true

    waitUntil(eventPlayer.eventId != BuffEventId.SHARED_BLESSING or eventPlayer.target == null or not eventPlayer.target in getPlayers(Team.2) or all([eventPlayer.heroNumber - eventPlayer.eventMission >= 1, eventPlayer.target.heroNumber - eventPlayer.eventLoopCount >= 1]) or eventPlayer.isWinner == true, eventPlayer.eventDuration)
    wait()
    if eventPlayer.eventId == BuffEventId.SHARED_BLESSING and (eventPlayer.isWinner or (eventPlayer.target != null and all([eventPlayer.heroNumber - eventPlayer.eventMission >= 1, eventPlayer.target.heroNumber - eventPlayer.eventLoopCount >= 1]))):
        bigMessage(eventPlayer, "有福同享 成功！")
        smallMessage(eventPlayer, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]))
        if eventPlayer.target != null and eventPlayer.target in getPlayers(Team.2):
            smallMessage(eventPlayer.target, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS * eventPlayer.target.heart_steel[HeartSteelData.GAIN_MULTIPLIER]))
            eventPlayer.target.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS * eventPlayer.target.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
            eventPlayer.target.setPlayerHP = true
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
        setPlayerHP()
        eventPlayer.dlcTimeChallenge[6] = 1
        eventPlayer.eventDuration = 0
    elif eventPlayer.eventId == BuffEventId.SHARED_BLESSING:
        bigMessage(eventPlayer, "有福同享 失败")
        eventPlayer.eventDuration = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.eventMission = 0
    eventPlayer.eventLoopCount = 0
    eventPlayer.target = null

rule "[VishkarEvent]: 有福同享（通关结算·未绑定）":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 0, eventPlayer.isWinner == true, eventPlayer.eventDuration > 0]) == true

    # 未绑定时不产生队友奖励，仅结算持有者本人任务
    bigMessage(eventPlayer, "有福同享 成功！")
    smallMessage(eventPlayer, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]))
    eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
    setPlayerHP()
    eventPlayer.dlcTimeChallenge[6] = 1
    eventPlayer.eventDuration = 0
