# Event: DebuffEventId.OSTEOPOROSIS
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 骨质疏松 Effect":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.OSTEOPOROSIS, eventPlayer.eventEffect == null]) == true

    createEffect(getAllPlayers(), Effect.MEI_FROZEN, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    wait(eventPlayer.eventDuration, Wait.IGNORE_CONDITION)
    clearEventEffect()
    eventPlayer.hudText = ""

rule "[VishkarEvent]: 骨质疏松":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.OSTEOPOROSIS]) == true
    
    while eventPlayer.mod_speed_event != EVT_DEBUFF_6_MAX_SPEED_DEC:
        eventPlayer.mod_speed_event -= EVT_DEBUFF_6_SPEED_DEC_PER_SEC
        eventPlayer.hudText = "移速{0}%".format(eventPlayer.mod_speed_event)
        updatePlayerStats()
        wait(1)
    updatePlayerStats()
