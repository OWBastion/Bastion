# Event: MechEventId.VAMPIRE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 吸血鬼":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VAMPIRE]) == true
    @Condition getLivingPlayers(Team.1)[1] != null

    eventPlayer.passiveRegenBlocked = true
    eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player != eventPlayer]
    if len(eventPlayer.target) > 0:
        eventPlayer.eventMissionGoal = EVT_MECH_18_DRAIN_FLAT + eventPlayer.getMaxHealth() * EVT_MECH_18_DRAIN_MAXHP_FACTOR
        damage(eventPlayer.target, eventPlayer, eventPlayer.eventMissionGoal)
        heal(eventPlayer, eventPlayer, len(eventPlayer.target) * eventPlayer.eventMissionGoal)
        eventPlayer.dlcTimeChallenge[4] += len(eventPlayer.target) * eventPlayer.eventMissionGoal
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
    @Condition all([dlcVishkarEvent, attacker.getTeam() == Team.1, attacker != eventPlayer, attacker.hasSpawned(), attacker.eventType == 2, attacker.eventId == MechEventId.VAMPIRE]) == true

    attacker.mod_heal_perma += EVT_MECH_18_KILL_HEAL_PERMA
    attacker.setHealingDealt(100 + attacker.mod_heal_perma + attacker.mod_heal_event)
