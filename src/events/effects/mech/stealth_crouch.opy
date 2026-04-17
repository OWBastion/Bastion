# Event: MechEventId.STEALTH_CROUCH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 悄悄地进村":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.STEALTH_CROUCH, eventPlayer.eventEffect == null]) == true
    
    createEffect(getAllPlayers() if eventPlayer.isHoldingButton(Button.CROUCH) == true else null, Effect.REAPER_WRAITH_FORM, Color.TEAM_1, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != MechEventId.STEALTH_CROUCH or eventPlayer.eventType != 2, eventPlayer.eventDuration)
    clearEventEffect()


rule "[VishkarEvent]: 悄悄地进村":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.STEALTH_CROUCH]) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.targetSilence = true
    eventPlayer.mod_speed_event -= EVT_MECH_3_SPEED_PENALTY
    updatePlayerStats()
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) == false, eventPlayer.eventDuration)
    eventPlayer.targetSilence = false
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    wait(0.25)
