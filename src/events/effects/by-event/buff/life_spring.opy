# Event: BuffEventId.LIFE_SPRING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 生命源泉":
    @Event eachPlayer
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.LIFE_SPRING]) == true
    
    wait(0.032)
    createEffect(getAllPlayers(), Effect.HEAL_TARGET_ACTIVE, Color.YELLOW, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.startHealingOverTime(eventPlayer, 20, eventPlayer.getMaxHealth() * EVT_4_HEAL_PERCENT)
    wait(eventPlayer.eventDuration)
    clearEventEffect()
