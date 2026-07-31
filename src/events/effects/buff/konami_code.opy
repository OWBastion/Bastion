#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.KONAMI_CODE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: ↑↑↓↓←→←→BABA":
    @Event playerDied
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.KONAMI_CODE]) == true
    @Condition eventPlayer.isWinner != true

    eventPlayer.controlPlayerRespawnPosition = [eventPlayer.getPosition(), eventPlayer.getFacingDirection(), eventPlayer.getHero()]
    bigMessage(eventPlayer, "↑↑↓↓←→←→BABA")
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_DISAPPEAR, Color.TEAM_1, eventPlayer, 200)
    eventPlayer.disableRespawn()
    wait(EVT_11_RESPAWN_DELAY)
    eventPlayer.enableRespawn()
    eventPlayer.resurrect()
    eventPlayer.teleport(eventPlayer.controlPlayerRespawnPosition[0])
    eventPlayer.setFacing(eventPlayer.controlPlayerRespawnPosition[1], Relativity.TO_WORLD)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, Color.TEAM_1, eventPlayer, 200)
    wait(0.5)
    eventPlayer.controlPlayerRespawnPosition = null
    eventPlayer.eventDuration = 0
