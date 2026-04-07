# Event: MechEventId.GAMBLER_ALL_IN_ART_5
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：梭哈艺术 5.0 (下注)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_ALL_IN_ART_5, eventPlayer.eventDuration > 0, eventPlayer.eventMissionGoal < EVT_MECH_17_MAX_BETS, eventPlayer.altFormTrigger != true, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    eventPlayer.altFormTrigger = true
    if eventPlayer.heart_steel <= 0:
        smallMessage(eventPlayer, "  {0}  心之钢层数不足".format(iconString(Icon.DIAMOND)))
    else:
        eventPlayer.eventMission += eventPlayer.heart_steel * EVT_MECH_17_STAKE_RATIO
        eventPlayer.eventMissionGoal++
        eventPlayer.hudText = "已 下 注：{0}层（{1}%）".format(eventPlayer.eventMission, eventPlayer.eventMissionGoal * 25)
        smallMessage(eventPlayer, "  {0}  已 下 注 {1} 层".format(iconString(Icon.CLUB), max(1, floor(eventPlayer.heart_steel * EVT_MECH_17_STAKE_RATIO))))
    waitUntil(any([eventPlayer.isHoldingButton(Button.RELOAD) == false, eventPlayer.eventType != 2, eventPlayer.eventId != MechEventId.GAMBLER_ALL_IN_ART_5, eventPlayer.eventDuration <= 0]), eventPlayer.eventDuration)
    eventPlayer.altFormTrigger = false

rule "[VishkarEvent]: 赌徒：梭哈艺术 5.0 (结算)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_ALL_IN_ART_5]) == true

    # wait(eventDuration, Wait.IGNORE_CONDITION)
    waitUntil(false, eventPlayer.eventDuration - 1)
    if eventPlayer.eventMission <= 0 :
        goto lbl_1
    if random.randint(0, 99) < EVT_MECH_17_WIN_RATE:
        eventPlayer.heart_steel += eventPlayer.eventMission * EVT_MECH_17_WIN_MULTIPLIER
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（{2}%）".format(iconString(Icon.CLUB), eventPlayer.eventMission * EVT_MECH_17_WIN_MULTIPLIER, eventPlayer.eventMission * EVT_MECH_17_WIN_MULTIPLIER * EVT_8_HP_PERCENT_PER_STACK))
    else:
        eventPlayer.heart_steel -= eventPlayer.eventMission
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢（{2}%）".format(iconString(Icon.DIAMOND), eventPlayer.eventMission, eventPlayer.eventMission * EVT_8_HP_PERCENT_PER_STACK))
    wait()
    setPlayerHP()
    lbl_1:
    wait(1)
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.hudText = ""
    eventPlayer.eventDuration = 0
