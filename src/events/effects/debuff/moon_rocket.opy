#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.MOON_ROCKET
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 登月火箭":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.MOON_ROCKET]) == true

    eventPlayer.dlcTimeChallenge[10]++
    playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Team.2, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Team.1, eventPlayer, 200)
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.setGravity(EVT_DEBUFF_20_GRAVITY)
    wait(EVT_DEBUFF_20_LAUNCH_DELAY)
    eventPlayer.applyImpulse(Vector.UP, EVT_DEBUFF_20_UPWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(eventPlayer.eventDuration)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
