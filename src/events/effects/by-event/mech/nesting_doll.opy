# Event: MechEventId.NESTING_DOLL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 俄罗斯套娃 (变小复活)":
    @Event playerDied
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.NESTING_DOLL]) == true
    
    eventPlayer.disableRespawn()
    wait(EVT_MECH_15_RESURRECT_DELAY)
    eventPlayer.enableRespawn()
    eventPlayer.resurrect()
    eventPlayer.eventSize++
    eventPlayer.startScalingSize(max(EVT_MECH_15_SIZE_MIN, 1 - EVT_MECH_15_SIZE_STEP * eventPlayer.eventSize), false)
    eventPlayer.startModifyingVoicelinePitch(max(EVT_MECH_15_PITCH_MIN, 1 + EVT_MECH_15_PITCH_STEP * eventPlayer.eventSize), false)
    eventPlayer.mod_speed_event += EVT_MECH_15_SPEED_STEP
    updatePlayerStats()
