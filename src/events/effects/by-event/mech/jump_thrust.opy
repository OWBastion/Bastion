# Event: MechEventId.JUMP_THRUST
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 屁动力":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.JUMP_THRUST, eventPlayer.isHoldingButton(Button.JUMP)]) == true
    
    eventPlayer.mod_dmg_taken = EVT_MECH_8_DMG_TAKEN
    updatePlayerStats()

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), EVT_MECH_8_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
