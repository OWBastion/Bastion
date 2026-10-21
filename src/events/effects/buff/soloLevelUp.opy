#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/我独自升级"

# Event: EventId.SOLO_LEVEL_UP
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 判定同有福同享：eventMission 记录事件开始时的 heroNumber 基准，通关推进后按增量结算；
# 增量一次性消费（基准即时对齐 heroNumber），同帧通关与到期只结算一次。
# eventMissionGoal 记录累计奖励次数用于 HUD；clearPlayerEvent 统一清零。

rule "Track hero finishes":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SOLO_LEVEL_UP]) == true

    eventPlayer.eventMission = eventPlayer.heroNumber
    eventPlayer.hudText = "已强化 {0} 次".format(eventPlayer.eventMissionGoal)
    waitUntil(eventPlayer.eventId == -1 or eventPlayer.heroNumber > eventPlayer.eventMission or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed():
        return
    if eventPlayer.heroNumber > eventPlayer.eventMission:
        eventPlayer.temp = eventPlayer.heroNumber - eventPlayer.eventMission
        eventPlayer.eventMission = eventPlayer.heroNumber
        eventPlayer.eventMissionGoal += eventPlayer.temp
        eventPlayer.hudText = "已强化 {0} 次".format(eventPlayer.eventMissionGoal)
        bigMessage(eventPlayer, "我独自升级：通关奖励 ×{0}".format(eventPlayer.temp))
        smallMessage(eventPlayer, "  {0}  获得 {1} 层心之钢、{2}% 伤害减免、{3}% 移速、{4}% 治疗强度，当前事件延长 {5} 秒".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_37_REWARD_HEARTSTEEL * eventPlayer.temp * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER], EVT_37_REWARD_DMG_REDUCTION * eventPlayer.temp, EVT_37_REWARD_SPEED * eventPlayer.temp, EVT_37_REWARD_HEAL * eventPlayer.temp, EVT_37_EXTEND_SECONDS * eventPlayer.temp))
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_37_REWARD_HEARTSTEEL * eventPlayer.temp * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
        eventPlayer.mod_dmg_perma -= EVT_37_REWARD_DMG_REDUCTION * eventPlayer.temp
        eventPlayer.mod_speed_perma += EVT_37_REWARD_SPEED * eventPlayer.temp
        eventPlayer.mod_heal_perma += EVT_37_REWARD_HEAL * eventPlayer.temp
        eventPlayer.eventEndTime += EVT_37_EXTEND_SECONDS * eventPlayer.temp
        setPlayerHP()
        updatePlayerStats()
    if ruleCondition:
        loop()
