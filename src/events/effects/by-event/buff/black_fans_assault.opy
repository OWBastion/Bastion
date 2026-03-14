# Event: BuffEventId.BLACK_FANS_ASSAULT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 黑粉来袭":
    @Event eachPlayer
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.BLACK_FANS_ASSAULT]) == true
    @Condition len([player for player in getPlayers(Team.2) if player.target == eventPlayer]) > 0
   
    # eventPlayer.hudText = "{0}/{1}".format(len([player for player in getPlayers(Team.2) if player.target == eventPlayer]), len(bastionPosition))
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.addHealthPool(EVT_5_HEALTH_TYPE, round(EVT_5_HEALTH_FLAT + eventPlayer.getMaxHealth() * EVT_5_HEALTH_MAXHP_FACTOR), false, false)
    eventPlayer.hp_data.append([[getTotalTimeElapsed() + 2, getLastCreatedHealthPool()]])
    wait(1.96, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
    # eventPlayer.hudText = ""
