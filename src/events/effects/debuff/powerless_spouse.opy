#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.POWERLESS_SPOUSE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 归于大地":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.DEBUFF
    @Condition eventPlayer.eventId == DebuffEventId.POWERLESS_SPOUSE
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()

    wait(EVT_DEBUFF_11_DELAY, Wait.ABORT_WHEN_FALSE)
    ([player for player in getLivingPlayers(Team.1) if distance(eventPlayer, player) <= EVT_DEBUFF_11_RADIUS and eventPlayer != player]).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, EVT_DEBUFF_11_KNOCKDOWN_DURATION)
