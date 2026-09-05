#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.HALVED
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 减半":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.DEBUFF
    @Condition eventPlayer.eventId == DebuffEventId.HALVED
    @Condition eventPlayer.getHealth() != 0
    
    eventPlayer.passiveRegenBlocked = true
    
    if eventPlayer.healthAtMostPercent(EVT_DEBUFF_13_EXECUTE_THRESHOLD * 100):
        kill(eventPlayer, eventPlayer)
        playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.TEAM_2, eventPlayer, 200)
    else:
        wait(EVT_DEBUFF_13_INTERVAL)
        eventPlayer.startDamageOverTime(null, 1, eventPlayer.getHealth() * EVT_DEBUFF_13_DAMAGE_PERCENT)
        playEffect(getAllPlayers(), DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, Color.TEAM_2, eventPlayer, 3)
    if ruleCondition:
        loop()
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()
