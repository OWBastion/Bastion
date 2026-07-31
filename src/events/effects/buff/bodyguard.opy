#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.BODYGUARD
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 保镖 (Bodyguard)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.BODYGUARD, eventPlayer.phaseState == true]) == true
    
    eventPlayer.eventEffectPlayers = getPlayersInRadius(eventPlayer, EVT_20_ALLY_RADIUS, Team.1, LosCheck.SURFACES).exclude(eventPlayer)
    eventPlayer.addHealthPool(EVT_20_HEALTH_TYPE, round(EVT_20_ARMOR_FLAT + eventPlayer.maxHealthPercent(EVT_20_ARMOR_MAXHP_FACTOR * 100)), false, false)
    eventPlayer.hp_data.append([[getTotalTimeElapsed() + EVT_20_ARMOR_DURATION, getLastCreatedHealthPool(), eventPlayer.eventId]])
    playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, Color.WHITE, eventPlayer, EVT_20_VFX_RADIUS)
    wait()
    if len(eventPlayer.eventEffectPlayers) > 0:
        playEffect(getAllPlayers(), DynamicEffect.BRIGITTE_REPAIR_PACK_ARMOR, Color.WHITE, eventPlayer.eventEffectPlayers[0], EVT_20_VFX_RADIUS)
        eventPlayer.eventEffectPlayers[0].addHealthPool(EVT_20_HEALTH_TYPE, round(EVT_20_ARMOR_FLAT + eventPlayer.maxHealthPercent(EVT_20_ARMOR_MAXHP_FACTOR * 100)), false, false)
        eventPlayer.eventEffectPlayers[0].hp_data.append([[getTotalTimeElapsed() + EVT_20_ARMOR_DURATION, getLastCreatedHealthPool()]])
    eventPlayer.eventEffectPlayers = null
    wait(EVT_20_POST_WAIT)
