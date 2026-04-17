# Event: BuffEventId.FLESH_REGEN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 血肉再生":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.FLESH_REGEN]) == true
    
    wait(0.032)
    removeHealthPool(eventPlayer.healthId[0])
    eventPlayer.addHealthPool(Health.NORMAL, round(EVT_7_BASE_HEALTH + eventPlayer.getMaxHealth() * EVT_7_HEALTH_PERCENT), false, false)
    eventPlayer.healthId[0] = getLastCreatedHealthPool()
    wait(EVT_7_REGEN_INTERVAL)
    if ruleCondition:
        loop()
    removeHealthPool(eventPlayer.healthId[0])
    eventPlayer.healthId[0] = null
