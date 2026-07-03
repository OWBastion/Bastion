#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.HEALTH_SYNC
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 我和你 (生命同步)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.HEALTH_SYNC]) == true
    @Condition len(getLivingPlayers(Team.1)) > 1
    @Condition eventPlayer.getHealth() != 0
    
    eventPlayer.passiveRegenBlocked = true

    eventPlayer.target = (sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: ratioPercent(i.getHealth(), i.getMaxHealth()))).first()

    if eventPlayer.target != null:
        if ratioPercent(eventPlayer.getHealth(), eventPlayer.getMaxHealth()) > ratioPercent(eventPlayer.target.getHealth(), eventPlayer.target.getMaxHealth()):
        eventPlayer.setHealth(eventPlayer.getMaxHealth().scaledBy(eventPlayer.target.getHealth() / eventPlayer.target.getMaxHealth()))
    wait(1)
    if ruleCondition:
        loop()
    clearEventEffect()
    eventPlayer.target = null
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()
