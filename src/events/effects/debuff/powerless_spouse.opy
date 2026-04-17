# Event: DebuffEventId.POWERLESS_SPOUSE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 无能的丈夫/妻子":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.POWERLESS_SPOUSE]) == true
    @Condition getLivingPlayers(Team.1)[1] != null
    
    ([player for player in getLivingPlayers(Team.1) if distance(eventPlayer, player) <= EVT_DEBUFF_11_RADIUS and eventPlayer != player]).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, EVT_DEBUFF_11_KNOCKDOWN_DURATION)
    wait(2)
