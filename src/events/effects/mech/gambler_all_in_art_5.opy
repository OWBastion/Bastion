# Event: MechEventId.GAMBLER_ALL_IN_ART_5
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：梭哈艺术 5.0 (下注)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_ALL_IN_ART_5, eventPlayer.eventDuration > 0, eventPlayer.isHoldingButton(Button.RELOAD), eventPlayer.altFormTrigger != true, eventPlayer.eventMissionGoal < EVT_MECH_17_MAX_BETS]) == true

    if eventPlayer.hudText == "":
        eventPlayer.eventMission = 0
        eventPlayer.eventMissionGoal = 0
        eventPlayer.altFormTrigger = false
        eventPlayer.hudText = "总下注：{0}层（{1}/{2}）".format(eventPlayer.eventMission, eventPlayer.eventMissionGoal, EVT_MECH_17_MAX_BETS)
    eventPlayer.altFormTrigger = true
    if eventPlayer.heart_steel <= 0:
        smallMessage(eventPlayer, "  {0}  心之钢层数不足，无法下注".format(iconString(Icon.DIAMOND)))
    else:
        eventPlayer.eventMission += max(1, floor(eventPlayer.heart_steel * EVT_MECH_17_STAKE_RATIO))
        eventPlayer.eventMissionGoal++
        eventPlayer.hudText = "总下注：{0}层（{1}/{2}）".format(eventPlayer.eventMission, eventPlayer.eventMissionGoal, EVT_MECH_17_MAX_BETS)
        smallMessage(eventPlayer, "  {0}  已下注 {1} 层（累计 {2} 层）".format(iconString(Icon.CLUB), max(1, floor(eventPlayer.heart_steel * EVT_MECH_17_STAKE_RATIO)), eventPlayer.eventMission))
    waitUntil(any([eventPlayer.isHoldingButton(Button.RELOAD) == false, eventPlayer.eventType != 2, eventPlayer.eventId != MechEventId.GAMBLER_ALL_IN_ART_5]), eventPlayer.eventDuration)
    eventPlayer.altFormTrigger = false

rule "[VishkarEvent]: 赌徒：梭哈艺术 5.0 (结算)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_ALL_IN_ART_5, eventPlayer.eventDuration <= 0]) == true

    eventPlayer.eventType = null
    if eventPlayer.eventMission <= 0:
        smallMessage(eventPlayer, "  {0}  未下注，本局作废".format(iconString(Icon.DIAMOND)))
    elif random.randint(0, 99) < EVT_MECH_17_WIN_RATE:
        eventPlayer.heart_steel += eventPlayer.eventMission * EVT_MECH_17_WIN_MULTIPLIER
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（总注 {2} × {3}）".format(iconString(Icon.CLUB), eventPlayer.eventMission * EVT_MECH_17_WIN_MULTIPLIER, eventPlayer.eventMission, EVT_MECH_17_WIN_MULTIPLIER))
    else:
        eventPlayer.heart_steel -= eventPlayer.eventMission
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢".format(iconString(Icon.DIAMOND), eventPlayer.eventMission))
    wait()
    setPlayerHP()
    wait()
    eventPlayer.hudText = ""
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.altFormTrigger = false
    eventPlayer.eventDuration = 0
