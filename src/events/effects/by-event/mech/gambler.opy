# Event: MechEventId.GAMBLER
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 100) <= EVT_MECH_2_WIN_RATE:
        eventPlayer.heart_steel -= EVT_MECH_2_STAKE
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢层数（{2}%）".format(iconString(Icon.DIAMOND), EVT_MECH_2_STAKE, EVT_MECH_2_STAKE * EVT_8_HP_PERCENT_PER_STACK))
    else:
        eventPlayer.heart_steel += EVT_MECH_2_STAKE
        eventPlayer.dlcTimeChallenge[0]++
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢层数（{2}%）".format(iconString(Icon.CLUB), EVT_MECH_2_STAKE, EVT_MECH_2_STAKE * EVT_8_HP_PERCENT_PER_STACK))
    wait()
    setPlayerHP()
    wait()
    eventPlayer.eventDuration = 0
