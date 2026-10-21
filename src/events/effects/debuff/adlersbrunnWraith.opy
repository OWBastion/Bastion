#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.ADLERSBRUNN_WRAITH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 阿德勒斯布鲁恩的冤魂":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventId == EventId.ADLERSBRUNN_WRAITH]) == true

    eventPlayer.passiveRegenBlocked = true
    eventPlayer.eventMissionGoal = eventPlayer.maxHealthPercent(EVT_DEBUFF_21_DRAIN_MAXHP_FACTOR * 100 * eventPlayer.getStatistic(Stat.ELIMINATIONS))
    eventPlayer.hudText = "冤魂缠身：-{0}/秒".format(round(eventPlayer.eventMissionGoal))
    if eventPlayer.eventMissionGoal > 0:
        eventPlayer.target = getLivingPlayers(Team.1).exclude(eventPlayer)
        eventPlayer.temp = eventPlayer.getHealth()
        damage(eventPlayer, null, eventPlayer.eventMissionGoal)
        eventPlayer.temp -= eventPlayer.getHealth()
        if len(eventPlayer.target) > 0 and eventPlayer.temp > 0:
            heal(eventPlayer.target, null, eventPlayer.temp / len(eventPlayer.target))
    wait(EVT_DEBUFF_21_DRAIN_INTERVAL)
    if ruleCondition:
        loop()
    eventPlayer.hudText = ""
    eventPlayer.target = null
    eventPlayer.eventMissionGoal = 0
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()

rule "[VishkarEvent]: 阿德勒斯布鲁恩的冤魂 (阵亡结算)":
    @Event playerDied
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.ADLERSBRUNN_WRAITH, eventPlayer.eventMission == 0]) == true

    eventPlayer.eventMission = 1
    eventPlayer.mod_heal_perma += EVT_DEBUFF_21_DEATH_HEAL_PERMA
    updatePlayerStats()
    eventPlayer.target = getPlayers(Team.1).exclude(eventPlayer)
    for eventPlayer.temp in range(len(eventPlayer.target)):
        eventPlayer.target[eventPlayer.temp].mod_heal_perma += negToPos(EVT_DEBUFF_21_DEATH_HEAL_PERMA) / len(eventPlayer.target)
        eventPlayer.target[eventPlayer.temp].setHealingDealt(100 + eventPlayer.target[eventPlayer.temp].mod_heal_perma + eventPlayer.target[eventPlayer.temp].mod_heal_event)
    eventPlayer.target = null
