#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.GRAVITY_ANOMALY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 重力异常":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GRAVITY_ANOMALY, eventPlayer.eventMission == 0]) == true

    # 仅在事件开始时抽取一次效果类型与数值，持续期间不变。
    # eventMission = 抽取结果，兼作重生重复触发的闸门；eventTempIndex = 本事件期望的重力基线
    # （100 = 未接管重力），供禅雅塔悬浮、开发者浮空等外部重力写回时归还到本事件的重力。
    # eventTempIndex 是事件间候选池暂存槽，事件生效期间不被分配流程读写，此处复用为标量。
    eventPlayer.eventMission = random.randint(GravityAnomalyRoll.ZERO_GRAVITY, GravityAnomalyRoll.NO_JUMP)
    if eventPlayer.eventMission == GravityAnomalyRoll.ZERO_GRAVITY:
        eventPlayer.eventTempIndex = 0
        eventPlayer.hudText = "重力 0%，无法跳跃"
    elif eventPlayer.eventMission == GravityAnomalyRoll.LOW_GRAVITY:
        eventPlayer.eventTempIndex = random.uniform(EVT_DEBUFF_0_LOW_GRAVITY_MIN, EVT_DEBUFF_0_LOW_GRAVITY_MAX)
        eventPlayer.hudText = "重力 {0}%".format(round(eventPlayer.eventTempIndex))
    elif eventPlayer.eventMission == GravityAnomalyRoll.HIGH_GRAVITY:
        eventPlayer.eventTempIndex = random.uniform(EVT_DEBUFF_0_HIGH_GRAVITY_MIN, EVT_DEBUFF_0_HIGH_GRAVITY_MAX)
        eventPlayer.hudText = "重力 {0}%".format(round(eventPlayer.eventTempIndex))
    else:
        eventPlayer.eventTempIndex = 100
        eventPlayer.hudText = "无法跳跃"
    createEffect(getAllPlayers() if (eventPlayer.isAlive() and getPlayers(Team.2)[0] != null) else null, Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers() if (eventPlayer.isAlive() and getPlayers(Team.2)[0] != null) else null, Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.eventMission != GravityAnomalyRoll.NO_JUMP:
        eventPlayer.setGravity(eventPlayer.eventTempIndex)
    if eventPlayer.eventMission == GravityAnomalyRoll.ZERO_GRAVITY or eventPlayer.eventMission == GravityAnomalyRoll.NO_JUMP:
        # 零重力禁止跳跃是防漂浮兜底：禁止输入向上速度，玩家只能离地漂浮平移，事件结束即可落地
        eventPlayer.disallowButton(Button.JUMP)
    smallMessage(eventPlayer, "  {0}  重力异常：{1}".format(iconString(Icon.DIAMOND), eventPlayer.hudText))
    waitUntil(eventPlayer.eventId != EventId.GRAVITY_ANOMALY or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    if eventPlayer.eventTempIndex != 100:
        # 禅雅塔悬浮期间归还 100% 会截断其合法悬浮，延后至松开跳跃（上限覆盖悬浮最长时长）
        waitUntil(eventPlayer.getHero() != Hero.ZENYATTA or eventPlayer.isHoldingButton(Button.JUMP) == false, EVT_DEBUFF_0_ZEN_HOVER_WAIT)
        if eventPlayer.isAirWalkEnabled == false:
            eventPlayer.setGravity(100)
    # 菜单打开期间跳跃由菜单持有锁定，跳过归还；菜单关闭时菜单自身统一解除
    if eventPlayer.menu == 0:
        eventPlayer.allowButton(Button.JUMP)
