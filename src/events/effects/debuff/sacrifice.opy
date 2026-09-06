#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.SACRIFICE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

#!define SACRIFICE_SCAN_DT 0.5

rule "[VishkarEvent]: 献祭":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.DEBUFF
    @Condition eventPlayer.eventId == DebuffEventId.SACRIFICE
    @Condition eventPlayer.hasSpawned()

    eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player.isUsingAbility1() or player.isUsingAbility2()]
    if len(eventPlayer.target) > 0:
        eventPlayer.passiveRegenBlocked = true
        playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.TEAM_2, eventPlayer, 200)
        if len(eventPlayer.target) > 1:
            eventPlayer.target = sorted(eventPlayer.target, lambda i: distance(eventPlayer, i))[0]
        elif eventPlayer.target[0] != null:
            eventPlayer.target = eventPlayer.target[0]
        else:
            eventPlayer.target = null
        if eventPlayer.target != null:
            damage(eventPlayer, eventPlayer.target, eventPlayer.maxHealthPercent(EVT_DEBUFF_2_DMG_PERCENT * 100))
    wait(SACRIFICE_SCAN_DT)
    if ruleCondition:
        loop()
    eventPlayer.target = null
    startCombatRegen()
