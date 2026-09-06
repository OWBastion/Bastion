#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.VAMPIRE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 吸血鬼":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.VAMPIRE
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()

    eventPlayer.passiveRegenBlocked = true
    eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player != eventPlayer]
    if len(eventPlayer.target) > 0:
        eventPlayer.eventMissionGoal = EVT_MECH_18_DRAIN_FLAT + eventPlayer.maxHealthPercent(EVT_MECH_18_DRAIN_MAXHP_FACTOR * 100)
        damage(eventPlayer.target, eventPlayer, eventPlayer.eventMissionGoal)
        heal(eventPlayer, eventPlayer, len(eventPlayer.target) * eventPlayer.eventMissionGoal)
        eventPlayer.dlcTimeChallenge[0] += len(eventPlayer.target) * eventPlayer.eventMissionGoal
        playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.RED, eventPlayer.target, 200)
    wait(EVT_MECH_18_INTERVAL)
    if ruleCondition:
        loop()
    eventPlayer.target = null
    eventPlayer.eventMissionGoal = 0
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()

rule "[VishkarEvent]: 吸血鬼击杀增益":
    @Event playerDied
    @Team 1
    @Condition attacker.eventType == EventType.MECH
    @Condition attacker.eventId == MechEventId.VAMPIRE
    @Condition attacker.getTeam() == Team.1
    @Condition attacker != eventPlayer
    @Condition attacker.hasSpawned()

    attacker.mod_heal_perma += EVT_MECH_18_KILL_HEAL_PERMA
    attacker.setHealingDealt(100 + attacker.mod_heal_perma + attacker.mod_heal_event)
