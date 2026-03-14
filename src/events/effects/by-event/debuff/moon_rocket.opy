# Event: DebuffEventId.MOON_ROCKET
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 登月火箭":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.MOON_ROCKET]) == true

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.setGravity(EVT_DEBUFF_22_GRAVITY)
    eventPlayer.applyImpulse(Vector.UP, EVT_DEBUFF_22_UPWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(eventPlayer.eventDuration)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
