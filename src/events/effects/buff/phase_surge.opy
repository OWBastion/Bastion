# Event: BuffEventId.PHASE_SURGE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 4.0":
    @Disabled
    @Delimiter

rule "[VishkarEvent]: 相位猛冲 (智能检测版)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.PHASE_SURGE, eventPlayer.phase_trigger == true, eventPlayer.mod_speed_event == 0]) == true
    
    createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.mod_speed_event += EVT_19_SPEED_BOOST
    updatePlayerStats()
    wait(EVT_19_DURATION)
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()
    wait(0.5)
