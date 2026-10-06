#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.LIFE_SPRING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 生命源泉":
    @Event eachPlayer
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.LIFE_SPRING]) == true
    
    wait(0.032)
    if eventPlayer.healthId[3] == null:
        goto lbl_0
    removeHealthPool(eventPlayer.healthId[3])
    lbl_0:
    eventPlayer.addHealthPool(Health.NORMAL, round(eventPlayer.maxHealthPercent(EVT_4_HEALTH_MAXHP_FACTOR * 100)), false, false)
    eventPlayer.healthId[3] = getLastCreatedHealthPool()
    createEffect(getAllPlayers(), Effect.HEAL_TARGET_ACTIVE, Color.YELLOW, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.startHealingOverTime(eventPlayer, 20, eventPlayer.maxHealthPercent(EVT_4_HEAL_PERCENT * 100))
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)
    removeHealthPool(eventPlayer.healthId[3])
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.healthId[3] = null
