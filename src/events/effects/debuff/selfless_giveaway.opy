#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/舍己为人"

# Event: EventId.SELFLESS_GIVEAWAY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "Resolve giveaway":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SELFLESS_GIVEAWAY]) == true
    
    if eventPlayer.getMaxHealth() <= EVT_DEBUFF_14_MIN_MAX_HP:
        eventPlayer.eventDuration = 0
    else:
        # 每名接收者按自己的获得倍率结算，不能统一固定值
        eventPlayer.target = getPlayers(Team.1).exclude(eventPlayer)
        for eventPlayer.temp in range(len(eventPlayer.target)):
            eventPlayer.target[eventPlayer.temp].heart_steel[HeartSteelData.STACKS] += EVT_DEBUFF_14_STACKS_GIVE * eventPlayer.target[eventPlayer.temp].heart_steel[HeartSteelData.GAIN_MULTIPLIER]
            eventPlayer.target[eventPlayer.temp].setPlayerHP = true
        eventPlayer.target = null
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_DEBUFF_14_STACKS_TAKE * len(getPlayers(Team.1).exclude(eventPlayer))
        setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION, Color.TEAM_1, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 100)
    wait(eventPlayer.eventDuration)

rule "Rebuild max health":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.setPlayerHP]) == true
    
    if eventPlayer.eventId == EventId.HEART_OF_STEEL_PRO:
        eventPlayer.temp = eventPlayer.getNormalizedHealth()
        eventPlayer.setMaxHealth(100 + eventPlayer.heart_steel[HeartSteelData.STACKS] * EVT_16_HP_MULTIPLIER)
        wait(getAverageServerLoad() / 100 * 0.032)
        eventPlayer.setHealth(eventPlayer.getMaxHealth().scaledBy(eventPlayer.temp))
    else:
        setPlayerHP()
    eventPlayer.setPlayerHP = false
