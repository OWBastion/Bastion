#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.IM_DEVELOPING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 任务：我在发育 (记录基准)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.IM_DEVELOPING, eventPlayer.eventMission == null]) == true

    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.IM_DEVELOPING] != TemperHeartState.COMPLETED:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.IM_DEVELOPING] = TemperHeartState.DRAWN
    eventPlayer.eventMission = eventPlayer.heroNumber

rule "[VishkarEvent]: 任务：我在发育 (结束判定)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.IM_DEVELOPING, eventPlayer.eventMission != null]) == true

    waitUntil(eventPlayer.heroNumber - eventPlayer.eventMission >= EVT_33_HERO_GOAL or eventPlayer.isWinner == true, eventPlayer.eventDuration)
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.heroNumber - eventPlayer.eventMission >= EVT_33_HERO_GOAL or eventPlayer.isWinner:
        bigMessage(eventPlayer, "任务：我在发育 成功！")
        smallMessage(eventPlayer, "  {0}  每{1}分钟永久获得1层发育层数，最多{2}层".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_33_GROWTH_INTERVAL / 60, EVT_33_GROWTH_STACK_CAP))
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.IM_DEVELOPING] = TemperHeartState.COMPLETED
        eventPlayer.eventDuration = 0
    else:
        bigMessage(eventPlayer, "任务：我在发育 失败")

rule "[VishkarEvent]: 任务：我在发育 (永久成长)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.playerOnceEventState != null, len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.IM_DEVELOPING, eventPlayer.playerOnceEventState[PlayerOnceEventSlot.IM_DEVELOPING] == TemperHeartState.COMPLETED, eventPlayer.developmentStackCount < EVT_33_GROWTH_STACK_CAP]) == true

    wait(EVT_33_GROWTH_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.developmentStackCount >= EVT_33_GROWTH_STACK_CAP:
        return
    eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_33_HEARTSTEEL_PER_STACK * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
    eventPlayer.mod_speed_perma += EVT_33_SPEED_PER_STACK
    eventPlayer.mod_heal_perma += EVT_33_HEAL_PER_STACK
    eventPlayer.developmentStackCount++
    smallMessage(eventPlayer, "  {0}  发育层数 +1（{1}/{2}）".format(abilityIconString(Hero.LUCIO, Button.ABILITY_1), eventPlayer.developmentStackCount, EVT_33_GROWTH_STACK_CAP))
    setPlayerHP()
    updatePlayerStats()
    if ruleCondition and eventPlayer.developmentStackCount < EVT_33_GROWTH_STACK_CAP:
        loop()
