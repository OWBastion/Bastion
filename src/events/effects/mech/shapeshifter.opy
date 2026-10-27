#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.SHAPESHIFTER
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
# eventMission 记录当前形态：0 无，1 巨大膨胀，2 迷你形态。

rule "[VishkarEvent]: 变形大师 切换形态":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.eventId == EventId.SHAPESHIFTER,
        eventPlayer.eventEndTime > getTotalTimeElapsed(),
        eventPlayer.isHoldingButton(Button.INTERACT)
    ]) == true

    eventPlayer.eventMission = 2 if eventPlayer.eventMission == 1 else 1
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.stopModifyingVoicelinePitch()
    if eventPlayer.eventMission == 1:
        eventPlayer.sizeHealth = 1 + EVT_MECH_27_GIANT_BONUS_HP / 100
        eventPlayer.mod_dmg_taken = -EVT_MECH_27_GIANT_DMG_REDUCTION
        eventPlayer.mod_speed_event = 0
        eventPlayer.startScalingSize(EVT_MECH_27_GIANT_SCALE, false)
        eventPlayer.startScalingBarriers(EVT_MECH_27_GIANT_SCALE, false)
        eventPlayer.startModifyingVoicelinePitch(EVT_MECH_27_GIANT_VOICE_PITCH, false)
    else:
        eventPlayer.sizeHealth = 1 - EVT_MECH_27_MINI_HP_CUT / 100
        eventPlayer.mod_dmg_taken = 0
        eventPlayer.mod_speed_event = EVT_MECH_27_MINI_SPEED_BOOST
        eventPlayer.startScalingSize(EVT_MECH_27_MINI_SCALE, false)
        eventPlayer.startScalingBarriers(EVT_MECH_27_MINI_SCALE, false)
        eventPlayer.startModifyingVoicelinePitch(EVT_MECH_27_MINI_VOICE_PITCH, false)
    updatePlayerStats()
    setPlayerHP()

rule "[VishkarEvent]: 变形大师 清理形态":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SHAPESHIFTER]) == true

    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    eventPlayer.sizeHealth = 1
    setPlayerHP()
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.stopModifyingVoicelinePitch()
