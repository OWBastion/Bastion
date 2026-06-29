#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.TEMPER_HEART
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 任务：钢化你心 (记录基准)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.TEMPER_HEART, eventPlayer.eventMission == null]) == true

    # 记录事件开始时的 heroNumber 基准（借用 eventMission 存基准，结束时比较增量）。
    # clearPlayerEvent() 会在事件结束后统一把 eventMission 清零，本规则不重复清理。
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] = true
    eventPlayer.eventMission = eventPlayer.heroNumber

rule "[VishkarEvent]: 任务：钢化你心 (结束判定)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.TEMPER_HEART, eventPlayer.eventMission != null]) == true

    # 等事件到期或玩家通关。此刻 assignPlayerEvent 的 waitUntil 刚返回、clearPlayerEvent 尚未运行，
    # eventMission 基准仍有效，可在 clearPlayerEvent 之前发奖励并刷新最大生命值。
    waitUntil(eventPlayer.heroNumber - eventPlayer.eventMission >= EVT_31_HERO_GOAL or eventPlayer.isWinner == true, eventPlayer.eventDuration)
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.heroNumber - eventPlayer.eventMission >= EVT_31_HERO_GOAL or eventPlayer.isWinner:
        bigMessage(eventPlayer, "钢化你心 成功！")
        smallMessage(eventPlayer, "  {0}  心之钢层数×{1}，每层生命值永久提升至 {2}%".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_31_STACK_MULTIPLIER, EVT_8_HP_PERCENT_PER_STACK + EVT_31_PERCENT_PER_STACK_BONUS))
        eventPlayer.heart_steel *= EVT_31_STACK_MULTIPLIER
        eventPlayer.heart_steel_percent_perma += EVT_31_PERCENT_PER_STACK_BONUS
        setPlayerHP()
        eventPlayer.eventDuration = 0
    else:
        bigMessage(eventPlayer, "钢化你心 失败")
