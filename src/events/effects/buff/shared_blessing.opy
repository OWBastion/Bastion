#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/有福同享"

# Event: BuffEventId.SHARED_BLESSING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# eventMissionGoal 兼作阶段标记：0=未初始化，1=等待绑定，2=已绑定。
# 绑定采用"最近友方+交互"：EVT_34_BIND_RADIUS 内最近的未通关友方按住 INTERACT 满 EVT_INTERACT_HOLD_TIME 即绑定。
# 完成判定同钢化你心：绑定时记录双方 heroNumber 基准（eventMission=自己，eventLoopCount=友方），双方各推进一格即双双过线。

rule "[VishkarEvent]: 有福同享（提示）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 0, eventPlayer.eventDuration > 0]) == true

    eventPlayer.eventMissionGoal = 1
    if len([player for player in getPlayers(Team.1) if player != eventPlayer and player.hasSpawned() and not player.isWinner]) == 0:
        bigMessage(eventPlayer, "有福同享 失败")
        smallMessage(eventPlayer, "  {0}  没有可绑定的有效友方".format(iconString(Icon.WARNING)))
        eventPlayer.eventDuration = 0
    else:
        smallMessage(getPlayers(Team.1), STR_EVT_BUFF_34_BIND.format(eventPlayer, EVT_34_BIND_RADIUS, Button.INTERACT, EVT_INTERACT_HOLD_TIME))
        waitUntil(eventPlayer.eventId != BuffEventId.SHARED_BLESSING or eventPlayer.eventMissionGoal != 1, eventPlayer.eventDuration)
        if eventPlayer.eventId == BuffEventId.SHARED_BLESSING and eventPlayer.eventMissionGoal == 1:
            bigMessage(eventPlayer, "有福同享 失败")
            smallMessage(eventPlayer, "  {0}  时限内没有友方完成绑定".format(iconString(Icon.WARNING)))
            eventPlayer.eventDuration = 0

rule "[VishkarEvent]: 有福同享（绑定）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 1, eventPlayer.eventDuration > 0]) == true
    @Condition all([getRealClosestPlayer(eventPlayer, Team.1) != eventPlayer, not getRealClosestPlayer(eventPlayer, Team.1).isWinner, distance(getRealClosestPlayer(eventPlayer, Team.1), eventPlayer) <= EVT_34_BIND_RADIUS, getRealClosestPlayer(eventPlayer, Team.1).isHoldingButton(Button.INTERACT)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        eventPlayer.eventMissionGoal = 2
        eventPlayer.target = getRealClosestPlayer(eventPlayer, Team.1)
        eventPlayer.eventMission = eventPlayer.heroNumber
        eventPlayer.eventLoopCount = eventPlayer.target.heroNumber
        smallMessage(eventPlayer, "  {0}  与 {1}（{2}）绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer.target, eventPlayer.target.getHero()))
        smallMessage(eventPlayer.target, "  {0}  {1}（{2}）与你绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer, eventPlayer.getHero()))

rule "[VishkarEvent]: 有福同享（结算）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 2, eventPlayer.target != null, eventPlayer.eventDuration > 0]) == true

    waitUntil(eventPlayer.eventId != BuffEventId.SHARED_BLESSING or eventPlayer.target == null or not eventPlayer.target in getPlayers(Team.1) or all([eventPlayer.heroNumber - eventPlayer.eventMission >= 1, eventPlayer.target.heroNumber - eventPlayer.eventLoopCount >= 1]), eventPlayer.eventDuration)
    if eventPlayer.eventId == BuffEventId.SHARED_BLESSING and eventPlayer.target != null and all([eventPlayer.heroNumber - eventPlayer.eventMission >= 1, eventPlayer.target.heroNumber - eventPlayer.eventLoopCount >= 1]):
        bigMessage(eventPlayer, "有福同享 成功！")
        smallMessage(eventPlayer, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS))
        smallMessage(eventPlayer.target, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS))
        eventPlayer.target.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS
        eventPlayer.target.setPlayerHP = true
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS
        setPlayerHP()
        eventPlayer.eventDuration = 0
    elif eventPlayer.eventId == BuffEventId.SHARED_BLESSING:
        bigMessage(eventPlayer, "有福同享 失败")
        eventPlayer.eventDuration = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.eventMission = 0
    eventPlayer.eventLoopCount = 0
    eventPlayer.target = null
