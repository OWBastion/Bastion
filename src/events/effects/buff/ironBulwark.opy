#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.IRON_BULWARK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 钢铁防线 (记录基准)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.IRON_BULWARK, eventPlayer.eventMissionGoal == 0]) == true

    eventPlayer.eventMission = eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED)
    eventPlayer.eventMissionGoal = eventPlayer.eventMission + EVT_2_BLOCK_GOAL_BASE + EVT_2_BLOCK_GOAL_PER_BASTION * len(bastionPosition)
    eventPlayer.hudText = "{0}/{1}".format(0, eventPlayer.eventMissionGoal - eventPlayer.eventMission)

rule "[VishkarEvent]: 钢铁防线 (更新 HUD)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.IRON_BULWARK, eventPlayer.eventMissionGoal > 0]) == true

    wait(EVT_2_HUD_INTERVAL, Wait.ABORT_WHEN_FALSE)
    eventPlayer.hudText = "{0}/{1}".format(
        max(0, eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED) - eventPlayer.eventMission),
        eventPlayer.eventMissionGoal - eventPlayer.eventMission
    )
    if ruleCondition:
        loop()

rule "[VishkarEvent]: 钢铁防线 (结束判定)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.IRON_BULWARK, eventPlayer.eventMissionGoal > 0]) == true

    waitUntil(eventPlayer.eventId == -1 or eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED) >= eventPlayer.eventMissionGoal or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    wait(max(0.032, getAverageServerLoad() * 0.00032))
    if eventPlayer.eventId == -1:
        return
    if eventPlayer.getStatistic(Stat.DAMAGE_BLOCKED) >= eventPlayer.eventMissionGoal:
        bigMessage(eventPlayer, "任务：钢铁防线 成功！")
        smallMessage(eventPlayer, "  {0}  奖励：本局永久获得 {1} 点护甲".format(abilityIconString(Hero.REINHARDT, Button.SECONDARY_FIRE), EVT_2_REWARD_ARMOR))
        eventPlayer.bulwarkArmor += EVT_2_REWARD_ARMOR
        requestPlayerEventEnd()
    else:
        bigMessage(eventPlayer, "任务：钢铁防线 失败")
    eventPlayer.hudText = null

# 永久护甲池独立于事件生命周期：单个池，上限随 bulwarkArmor 重估，累加奖励不重建、不补满。
rule "[VishkarEvent]: 钢铁防线 (永久护甲)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.bulwarkArmor > 0]) == true

    eventPlayer.addHealthPool(Health.ARMOR, eventPlayer.bulwarkArmor, false, true)
    eventPlayer.healthId[1] = getLastCreatedHealthPool()
    # Exception: pool teardown is bound to death or progress reset.
    waitUntil(eventPlayer.hasSpawned() == false or eventPlayer.bulwarkArmor == 0, Math.INFINITY)
    removeHealthPool(eventPlayer.healthId[1])
    eventPlayer.healthId[1] = null
