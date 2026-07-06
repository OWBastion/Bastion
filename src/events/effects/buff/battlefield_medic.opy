#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.BATTLEFIELD_MEDIC
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 战地医生 (记录基准)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.BATTLEFIELD_MEDIC, eventPlayer.eventMissionGoal == 0]) == true

    eventPlayer.eventMission = eventPlayer.getStatistic(Stat.HEALING_DEALT)
    eventPlayer.eventMissionGoal = eventPlayer.eventMission + EVT_32_HEAL_GOAL
    eventPlayer.hudText = "{0}/{1}".format(
        max(0, eventPlayer.getStatistic(Stat.HEALING_DEALT) - eventPlayer.eventMission),
        EVT_32_HEAL_GOAL
    )

rule "[VishkarEvent]: 战地医生 (更新 HUD)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.BATTLEFIELD_MEDIC, eventPlayer.eventMissionGoal > 0]) == true

    wait(EVT_32_HUD_INTERVAL, Wait.ABORT_WHEN_FALSE)
    eventPlayer.hudText = "{0}/{1}".format(
        max(0, eventPlayer.getStatistic(Stat.HEALING_DEALT) - eventPlayer.eventMission),
        EVT_32_HEAL_GOAL
    )
    if ruleCondition:
        loop()

rule "[VishkarEvent]: 战地医生 (结束判定)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.BATTLEFIELD_MEDIC, eventPlayer.eventMissionGoal > 0]) == true

    waitUntil(eventPlayer.getStatistic(Stat.HEALING_DEALT) >= eventPlayer.eventMissionGoal or eventPlayer.isWinner == true, eventPlayer.eventDuration)
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.getStatistic(Stat.HEALING_DEALT) >= eventPlayer.eventMissionGoal or eventPlayer.isWinner:
        bigMessage(eventPlayer, "战地医生 成功！")
        smallMessage(eventPlayer, "  {0}  任务奖励：永久获得 {1}% 治疗强度".format(abilityIconString(Hero.MERCY, Button.PRIMARY_FIRE), EVT_32_REWARD_HEAL_PERMA))
        eventPlayer.mod_heal_perma += EVT_32_REWARD_HEAL_PERMA
        updatePlayerStats()
        eventPlayer.eventDuration = 0
    else:
        bigMessage(eventPlayer, "战地医生 失败")
