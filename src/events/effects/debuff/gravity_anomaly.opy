#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.GRAVITY_ANOMALY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 重力异常":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.DEBUFF
    @Condition eventPlayer.eventId == DebuffEventId.GRAVITY_ANOMALY
    @Condition eventPlayer.hasSpawned()
    
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.setGravity(100 + EVT_DEBUFF_0_GRAVITY)
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    wait(eventPlayer.eventDuration)
    eventPlayer.setGravity(100)
