# Event: DebuffEventId.HEALTH_SYNC
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 我和你 (生命同步)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.HEALTH_SYNC]) == true
    @Condition len(getLivingPlayers(Team.1)) > 1
    @Condition eventPlayer.getHealth() != 0
    
    eventPlayer.passiveRegenBlocked = true

    eventPlayer.target = (sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: i.getHealth() / i.getMaxHealth()))[0]

    if eventPlayer.target != null:
        if eventPlayer.getHealth() / eventPlayer.getMaxHealth() > eventPlayer.target.getHealth() / eventPlayer.target.getMaxHealth():
        eventPlayer.setHealth(eventPlayer.getMaxHealth() * (eventPlayer.target.getHealth() / eventPlayer.target.getMaxHealth()))
    wait(1)
    if ruleCondition:
        loop()
    clearEventEffect()
    eventPlayer.target = null
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()
