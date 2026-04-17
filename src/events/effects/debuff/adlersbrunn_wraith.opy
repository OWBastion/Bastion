# Event: DebuffEventId.ADLERSBRUNN_WRAITH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 阿德勒斯布鲁恩的冤魂":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.ADLERSBRUNN_WRAITH]) == true

    eventPlayer.eventMission++
    eventPlayer.mod_heal_event = eventPlayer.eventMission * EVT_DEBUFF_21_HEAL_DELTA_PER_STACK
    eventPlayer.hudText = "诅咒：{0}层".format(eventPlayer.eventMission)
    updatePlayerStats()
    wait(10)
    if ruleCondition:
        loop()
    eventPlayer.mod_heal_perma += eventPlayer.eventMission * EVT_DEBUFF_21_HEAL_DELTA_PER_STACK
    eventPlayer.mod_heal_event = 0
    eventPlayer.hudText = ""
    updatePlayerStats()

rule "[VishkarEvent]: 阿德勒斯布鲁恩的冤魂 (抵消层数)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.ADLERSBRUNN_WRAITH,  eventPlayer.eventMission > 0, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_DEBUFF_21_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    damage(eventPlayer, null, eventPlayer.getMaxHealth() * EVT_DEBUFF_21_HP_COST_RATIO)
    eventPlayer.eventMission--
    eventPlayer.mod_heal_event = eventPlayer.eventMission * EVT_DEBUFF_21_HEAL_DELTA_PER_STACK
    eventPlayer.hudText = "诅咒：{0}层".format(eventPlayer.eventMission)
    updatePlayerStats()
    wait(5)
