# Event: BuffEventId.HEALING_TOWER_PROMAX
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 治疗光塔 ProMax (全图奶)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.HEALING_TOWER_PROMAX]) == true
    
    if eventPlayer.getNormalizedHealth() == 1:
        goto lbl_0
        smallMessage(getPlayers(Team.1).exclude(eventPlayer), "  {0}  受到来自 {1}（{2}） 治疗光塔 ProMax 的治疗效果".format(abilityIconString(Hero.ILLARI, Button.ABILITY_2), eventPlayer, eventPlayer.getHero()))
    lbl_0:
    getPlayers(Team.1).startHealingOverTime(eventPlayer, EVT_25_HOT_DURATION, round(EVT_25_HEAL_FLAT + eventPlayer.getMaxHealth() * EVT_25_HEAL_MAXHP_FACTOR))
    wait(EVT_25_HOT_DURATION, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
    clearEventEffect()
