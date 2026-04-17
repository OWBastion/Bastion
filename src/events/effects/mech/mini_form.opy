# Event: MechEventId.MINI_FORM
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 迷你形态":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.MINI_FORM]) == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.sizeHealth = EVT_MECH_2_HP_SCALE
    eventPlayer.startScalingSize(EVT_MECH_2_MODEL_SCALE, false)
    eventPlayer.startScalingBarriers(EVT_MECH_2_MODEL_SCALE, false)
    eventPlayer.startModifyingVoicelinePitch(EVT_MECH_2_VOICE_PITCH, false)
    eventPlayer.mod_speed_event = EVT_MECH_2_SPEED_BOOST
    updatePlayerStats()
    setPlayerHP()
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)
    eventPlayer.sizeHealth = 1
    setPlayerHP()
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.stopModifyingVoicelinePitch()
