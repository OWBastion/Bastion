#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/有福同享"

# Event: EventId.SHARED_BLESSING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 绑定：持有者按住 INTERACT 满 EVT_INTERACT_HOLD_TIME、EVT_34_BIND_RADIUS 内存在未通关友方即绑定最近者
#（描述文案为持有者"长按互动与最近的队友绑定"，按键主体是持有者而非队友）。
# 判定同钢化你心：绑定时记录双方 heroNumber 基准（eventMission=自己，eventLoopCount=友方），双方各推进一格即双双过线；
# 末位英雄（堡垒）过线只置 isWinner 不推进 heroNumber，故两侧完成判定均以 heroNumber 增量或 isWinner 任一成立为准。
# eventMissionGoal>0 兼作"已绑定"标记，防止条件残留导致重复触发；未绑定到期由事件自然到期处理。
# 任务奖励 = EVT_34_REWARD_BASE + EVT_34_REWARD_PER_BASTION × 当前地图堡垒数（len(bastionPosition)）；
# 持有者按自己的心之钢获得倍率结算，其他获得者固定基础值（不计入钢化你心加成）；
# 队友血量重建走公共 setPlayerHP 旗标路径（见 debuff/selfless_giveaway.opy）。
# 持有者为通关玩家（isWinner）时无法完成绑定，由 "Settle on finish without bind" 直接判成功并向全队发放：
# 持有者把待领名单发布到共享队列 sharedBlessingPayout（规则内禁批量循环），由 "Grant shared blessing"
# 逐人在各自上下文中结算；入队名单以结算时刻 getPlayers(Team.1) 快照为准，发布前过滤已离队残留项。

# 绑定候选：半径内未通关的存活友方（排除自己）
macro Player.bindCandidates():
    getLivingPlayers(Team.1).filter(lambda p: p != self and p.hasSpawned() and not p.isWinner and distance(p, self) <= EVT_34_BIND_RADIUS)

rule "Bind nearest teammate":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 0, eventPlayer.eventEndTime > getTotalTimeElapsed(), eventPlayer.isHoldingButton(Button.INTERACT)]) == true
    @Condition len(eventPlayer.bindCandidates()) > 0

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        eventPlayer.eventMissionGoal = 1
        eventPlayer.target = sorted(eventPlayer.bindCandidates(), lambda p: distance(p, eventPlayer)).first()
        eventPlayer.eventMission = eventPlayer.heroNumber
        eventPlayer.eventLoopCount = eventPlayer.target.heroNumber
        smallMessage(eventPlayer, "  {0}  与 {1}（{2}）绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer.target, eventPlayer.target.getHero()))
        smallMessage(eventPlayer.target, "  {0}  {1}（{2}）与你绑定：双双通过终点即完成".format(iconString(Icon.FLAG), eventPlayer, eventPlayer.getHero()))

rule "Settle":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SHARED_BLESSING, eventPlayer.eventMissionGoal > 0, eventPlayer.target != null, eventPlayer.eventEndTime > getTotalTimeElapsed()]) == true

    waitUntil(eventPlayer.eventId != EventId.SHARED_BLESSING or eventPlayer.target == null or not eventPlayer.target in getPlayers(Team.1) or all([eventPlayer.heroNumber - eventPlayer.eventMission >= 1, eventPlayer.target.heroNumber - eventPlayer.eventLoopCount >= 1 or eventPlayer.target.isWinner == true]) or eventPlayer.isWinner == true or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    wait()
    if eventPlayer.eventId == EventId.SHARED_BLESSING and (eventPlayer.isWinner or (eventPlayer.target != null and all([eventPlayer.heroNumber - eventPlayer.eventMission >= 1, eventPlayer.target.heroNumber - eventPlayer.eventLoopCount >= 1 or eventPlayer.target.isWinner == true]))):
        eventPlayer.temp = EVT_34_REWARD_BASE + EVT_34_REWARD_PER_BASTION * len(bastionPosition)
        bigMessage(eventPlayer, "有福同享 成功！")
        smallMessage(eventPlayer, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), eventPlayer.temp * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]))
        if eventPlayer.target != null and eventPlayer.target in getPlayers(Team.1):
            smallMessage(eventPlayer.target, "  {0}  任务奖励：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), eventPlayer.temp))
            eventPlayer.target.heart_steel[HeartSteelData.STACKS] += eventPlayer.temp
            eventPlayer.target.setPlayerHP = true
        eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.temp * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
        setPlayerHP()
        requestPlayerEventEnd()
    elif eventPlayer.eventId == EventId.SHARED_BLESSING:
        bigMessage(eventPlayer, "有福同享 失败")
        requestPlayerEventEnd()
    eventPlayer.eventMissionGoal = 0
    eventPlayer.eventMission = 0
    eventPlayer.eventLoopCount = 0
    eventPlayer.target = null

rule "Settle on finish without bind":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SHARED_BLESSING, eventPlayer.eventMissionGoal == 0, eventPlayer.isWinner == true, eventPlayer.eventEndTime > getTotalTimeElapsed()]) == true

    # 通关持有者无法绑定：发布待领名单，由 "Grant shared blessing" 逐人结算（规则内禁批量循环）
    sharedBlessingPayout = sharedBlessingPayout.filter(lambda p: p in getPlayers(Team.1)).concat(getPlayers(Team.1).exclude(eventPlayer))
    bigMessage(eventPlayer, "有福同享 成功！")
    smallMessage(eventPlayer, "  {0}  任务奖励：与全队分享，获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), (EVT_34_REWARD_BASE + EVT_34_REWARD_PER_BASTION * len(bastionPosition)) * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]))
    eventPlayer.heart_steel[HeartSteelData.STACKS] += (EVT_34_REWARD_BASE + EVT_34_REWARD_PER_BASTION * len(bastionPosition)) * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
    setPlayerHP()
    requestPlayerEventEnd()

rule "Grant shared blessing":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer in sharedBlessingPayout]) == true

    smallMessage(eventPlayer, "  {0}  有福同享：获得 {1} 层心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_34_REWARD_BASE + EVT_34_REWARD_PER_BASTION * len(bastionPosition)))
    eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_34_REWARD_BASE + EVT_34_REWARD_PER_BASTION * len(bastionPosition)
    eventPlayer.setPlayerHP = true
    sharedBlessingPayout.remove(eventPlayer)
