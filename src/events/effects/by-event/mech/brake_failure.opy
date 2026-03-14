# Event: MechEventId.BRAKE_FAILURE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 刹车失灵":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.BRAKE_FAILURE]) == true
    
    eventPlayer.startThrottleInDirection(Vector.FORWARD, 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    wait(eventPlayer.eventDuration)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.hudText = ""

rule "[VishkarEvent]: 刹车失灵":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.BRAKE_FAILURE]) == true
    
    while eventPlayer.mod_speed_event < EVT_MECH_7_MAX_SPEED:
        eventPlayer.mod_speed_event += 5
        if eventPlayer.mod_dmg_taken == EVT_MECH_7_MAX_DMG_TAKEN:
            goto lbl_0
        eventPlayer.mod_dmg_taken -= EVT_MECH_7_DMG_TAKEN_INC
        lbl_0:
        eventPlayer.hudText = "移速+{0}% / 伤害减免 {1}%".format(eventPlayer.mod_speed_event, negToPos(eventPlayer.mod_dmg_taken))
        updatePlayerStats()
        wait(EVT_MECH_7_INTERVAL)
