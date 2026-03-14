# Event: BuffEventId.BODYGUARD
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 保镖 (Bodyguard)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.BODYGUARD, eventPlayer.phase_trigger == true]) == true
    
    eventPlayer.target = getPlayersInRadius(eventPlayer, EVT_25_ALLY_RADIUS, Team.1, LosCheck.SURFACES).exclude(eventPlayer)
    eventPlayer.addHealthPool(EVT_25_HEALTH_TYPE, round(EVT_25_ARMOR_FLAT + eventPlayer.getMaxHealth() * EVT_25_ARMOR_MAXHP_FACTOR), false, false)
    eventPlayer.hp_data.append([[getTotalTimeElapsed() + EVT_25_ARMOR_DURATION, getLastCreatedHealthPool()]])
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, Color.WHITE, eventPlayer, EVT_25_VFX_RADIUS)
    wait()
    if len(eventPlayer.target) > 0:
        playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, Color.WHITE, eventPlayer.target[0], EVT_25_VFX_RADIUS)
        eventPlayer.target[0].addHealthPool(EVT_25_HEALTH_TYPE, round(EVT_25_ARMOR_FLAT + eventPlayer.getMaxHealth() * EVT_25_ARMOR_MAXHP_FACTOR), false, false)
        eventPlayer.target[0].hp_data.append([[getTotalTimeElapsed() + EVT_25_ARMOR_DURATION, getLastCreatedHealthPool()]])
    wait(EVT_25_POST_WAIT)
