# Event: BuffEventId.MARTYR_TRIAL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 任务：殉道者 (初始化)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.MARTYR_TRIAL]) == true
    
    eventPlayer.eventMissionGoal = max(
        EVT_21_GOAL_MIN,
        min(
            round(
                EVT_21_GOAL_MIN
                + ((random.uniform(0, 1) + random.uniform(0, 1)) / 2)
                * (MARTYR_GOAL_MAX - EVT_21_GOAL_MIN)
            ),
            MARTYR_GOAL_MAX
        )
    )

    eventPlayer.hudText = "{0}/{1}".format(
        len(eventPlayer.eventMission),
        eventPlayer.eventMissionGoal
    )
    wait(eventPlayer.eventDuration)

rule "[VishkarEvent]: 任务：殉道者 (进度检测)":
    @Event playerDied
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.MARTYR_TRIAL]) == true
    @Condition attacker.getTeam() == Team.2
    @Condition (not attacker in eventPlayer.eventMission) == true
    
    eventPlayer.eventMission.append(attacker)
    eventPlayer.hudText = "{0}/{1}".format(
        len(eventPlayer.eventMission),
        eventPlayer.eventMissionGoal
    )
    if len(eventPlayer.eventMission) == eventPlayer.eventMissionGoal:
        waitUntil(eventPlayer.isAlive(), EVT_21_WAITUNTIL_TIMEOUT)
        bigMessage(eventPlayer, "任务：殉道者 完成！")
        smallMessage(eventPlayer, "  {0}  任务奖励：永久获得 {1}% 伤害减免".format(abilityIconString(Hero.HAZARD, Button.SECONDARY_FIRE), negToPos(EVT_21_REWARD_DMG_PERMA)))
        eventPlayer.mod_dmg_perma += EVT_21_REWARD_DMG_PERMA
        updatePlayerStats()
        eventPlayer.eventDuration = 0
