#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/舍己为人"

# Event: DebuffEventId.SELFLESS_GIVEAWAY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "Resolve giveaway":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.SELFLESS_GIVEAWAY]) == true
    
    eventPlayer.dlcTimeChallenge[1]++
    if eventPlayer.getMaxHealth() <= EVT_DEBUFF_14_MIN_MAX_HP:
        eventPlayer.eventDuration = 0
    else:
        getPlayers(Team.1).exclude(eventPlayer).heart_steel[HeartSteelData.STACKS] += EVT_DEBUFF_14_STACKS_GIVE
        getPlayers(Team.1).exclude(eventPlayer).setPlayerHP = true
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_DEBUFF_14_STACKS_TAKE * len(getPlayers(Team.1).exclude(eventPlayer))
        setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION, Color.TEAM_1, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 100)
    wait(eventPlayer.eventDuration)

rule "Rebuild max health":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.setPlayerHP]) == true
    
    if all([eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.HEART_OF_STEEL_PRO]) == true:
        eventPlayer.temp = eventPlayer.getNormalizedHealth()
        eventPlayer.setMaxHealth(100 + eventPlayer.heart_steel[HeartSteelData.STACKS] * EVT_16_HP_MULTIPLIER)
        wait(getAverageServerLoad() / 100 * 0.032)
        eventPlayer.setHealth(eventPlayer.getMaxHealth().scaledBy(eventPlayer.temp))
    else:
        setPlayerHP()
    eventPlayer.setPlayerHP = false
