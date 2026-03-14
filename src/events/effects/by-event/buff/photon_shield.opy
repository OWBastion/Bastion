# Event: BuffEventId.PHOTON_SHIELD
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 费斯卡光子护盾":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.PHOTON_SHIELD]) == true
    
    wait()
    getPlayers(Team.1).target = eventPlayer
    # Exception: shield ownership syncs to death/event end boundary.
    waitUntil(eventPlayer.isDead(), eventPlayer.eventDuration)
    eventPlayer.eventDuration = 0
    getPlayers(Team.1).target = null

rule "[VishkarEvent]: 费斯卡光子护盾":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.target != null]) == true
    
    wait()
    eventPlayer.addHealthPool(Health.SHIELDS, eventPlayer.target.getMaxHealth() * EVT_14_SHIELD_PERCENT if eventPlayer.target.getMaxHealth() * EVT_14_SHIELD_PERCENT > EVT_14_MIN_SHIELD else EVT_14_MIN_SHIELD, true, false)
    eventPlayer.healthId[2] = getLastCreatedHealthPool()
    # Exception: bonded target shield must track target lifecycle directly.
    waitUntil(not eventPlayer.target.isAlive() or eventPlayer.target == null, eventPlayer.target.eventDuration)
    removeHealthPool(eventPlayer.healthId[2])
    eventPlayer.healthId[2] = null
