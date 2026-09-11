#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: DebuffEventId.ADLERSBRUNN_WRAITH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 阿德勒斯布鲁恩的冤魂":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.ADLERSBRUNN_WRAITH]) == true

    eventPlayer.eventMission = EVT_DEBUFF_21_TOTAL_STACK
    eventPlayer.mod_heal_perma += eventPlayer.eventMission * EVT_DEBUFF_21_HEAL_DELTA_PER_STACK
    eventPlayer.hudText = "诅咒：{0}层".format(eventPlayer.eventMission)
    updatePlayerStats()
    wait(eventPlayer.eventDuration)
    eventPlayer.hudText = ""

rule "[VishkarEvent]: 阿德勒斯布鲁恩的冤魂 (抵消层数)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.DEBUFF, eventPlayer.eventId == DebuffEventId.ADLERSBRUNN_WRAITH,  eventPlayer.eventMission > 0, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    damage(eventPlayer, null, eventPlayer.maxHealthPercent(EVT_DEBUFF_21_HP_COST_RATIO * 100))
    eventPlayer.eventMission--
    eventPlayer.mod_heal_perma += negToPos(EVT_DEBUFF_21_HEAL_DELTA_PER_STACK)
    eventPlayer.hudText = "诅咒：{0}层".format(eventPlayer.eventMission)
    updatePlayerStats()
    wait(10)
