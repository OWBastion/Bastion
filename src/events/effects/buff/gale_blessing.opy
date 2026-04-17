# Event: BuffEventId.GALE_BLESSING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "未经原作者许可，任何人不得将以下代码进行二次创作与发布":
    @Disabled
    @Delimiter

rule "[VishkarEvent]: 疾风祝福":
    @Event eachPlayer
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.GALE_BLESSING]) == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.mod_speed_event = EVT_1_SPEED_BOOST
    updatePlayerStats()
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()
