# Event: BuffEventId.MORALE_BOOST_PROMAX
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 鼓舞士气 ProMax - 触发器":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.MORALE_BOOST_PROMAX]) == true
    
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_WHIP_SHOT_HEAL_AREA, Color.TEAM_1, eventPlayer, 200)
    getPlayersInRadius(eventPlayer, EVT_23_HEAL_RADIUS, Team.1, LosCheck.SURFACES).startHealingOverTime(eventPlayer, EVT_23_HOT_DURATION, EVT_23_HOT_FLAT + eventPlayer.getMaxHealth() * EVT_23_HOT_MAXHP_FACTOR)
    wait(EVT_23_TICK_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
    clearEventEffect()
