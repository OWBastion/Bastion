#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/有福同享"

# Event: BuffEventId.SHARED_BLESSING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "Bind ally":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 0, eventPlayer.eventDuration > 0]) == true

    # eventMissionGoal>0 兼作初始化标记，防止 clearPlayerEvent 前条件残留导致重复触发
    eventPlayer.eventMissionGoal = 1
    # 有效友方：已在场的 Team 1 队友，排除自身与已通关者
    eventPlayer.temp = [player for player in getPlayers(Team.1) if player != eventPlayer and player.hasSpawned() and not player.isWinner]
    if len(eventPlayer.temp) == 0:
        bigMessage(eventPlayer, "有福同享 失败")
        smallMessage(eventPlayer, "  {0}  没有可绑定的有效友方".format(iconString(Icon.WARNING)))
        eventPlayer.eventDuration = 0
    else:
        eventPlayer.target = random.choice(eventPlayer.temp)
        smallMessage(eventPlayer, "  {0}  与 {1}（{2}）绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer.target, eventPlayer.target.getHero()))
        smallMessage(eventPlayer.target, "  {0}  {1}（{2}）与你绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer, eventPlayer.getHero()))
    eventPlayer.temp = null

rule "Resolve mission":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.SHARED_BLESSING, eventPlayer.eventMissionGoal > 0, eventPlayer.target != null, eventPlayer.eventDuration > 0]) == true

    # 完成条件：双方 isWinner（不要求同时过线）；目标离开/失效即失败；超时由 eventDuration 兜底
    waitUntil(eventPlayer.eventId != BuffEventId.SHARED_BLESSING or eventPlayer.target == null or not eventPlayer.target in getPlayers(Team.1) or (eventPlayer.isWinner == true and eventPlayer.target.isWinner == true), eventPlayer.eventDuration)
    if eventPlayer.eventId == BuffEventId.SHARED_BLESSING and eventPlayer.target != null and eventPlayer.isWinner == true and eventPlayer.target.isWinner == true:
        bigMessage(eventPlayer, "有福同享 成功！")
        smallMessage(eventPlayer, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS))
        smallMessage(eventPlayer.target, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_STACKS))
        eventPlayer.target.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS
        eventPlayer.target.setPlayerHP = true
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_STACKS
        setPlayerHP()
        eventPlayer.eventDuration = 0
    elif eventPlayer.eventId == BuffEventId.SHARED_BLESSING:
        # 超时或目标失效；事件仍属本事件时播报失败并提前收尾
        bigMessage(eventPlayer, "有福同享 失败")
        eventPlayer.eventDuration = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.target = null
