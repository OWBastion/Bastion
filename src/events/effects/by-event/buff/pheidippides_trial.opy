# Event: BuffEventId.PHEIDIPPIDES_TRIAL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 任务：菲迪皮德斯之力":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.PHEIDIPPIDES_TRIAL, eventPlayer.getSpeed() != 0, eventPlayer.eventMission <= EVT_20_DISTANCE_GOAL]) == true
    
    wait(EVT_20_DISTANCE_INC, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventMission += 0.5
    eventPlayer.hudText = "{0}/{1}".format(eventPlayer.eventMission, EVT_20_DISTANCE_GOAL)
    if ruleCondition:
        loop()

rule "[VishkarEvent]: 任务：菲迪皮德斯之力":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.PHEIDIPPIDES_TRIAL]) == true
    
    waitUntil(eventPlayer.eventMission >= EVT_20_DISTANCE_GOAL or eventPlayer.eventId == null, eventPlayer.eventDuration + 1.5)
    wait()
    if eventPlayer.eventMission >= EVT_20_DISTANCE_GOAL:
        bigMessage(eventPlayer, "任务：菲迪皮德斯之力 成功！")
        smallMessage(eventPlayer, "  {0}  任务奖励：永久获得 {1}% 移动速度加成".format(abilityIconString(Hero.SOLDIER, Button.ABILITY_1), EVT_20_REWARD_SPEED))
        eventPlayer.mod_speed_perma += EVT_20_REWARD_SPEED
        updatePlayerStats()
    else:
        bigMessage(eventPlayer, "任务：菲迪皮德斯之力 失败")
    eventPlayer.eventMission = 0
    eventPlayer.eventDuration = 0
