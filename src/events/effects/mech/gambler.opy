#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.GAMBLER, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_1_WIN_RATE:
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_MECH_1_STAKE * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
        eventPlayer.dlcTimeChallenge[0]++
        eventPlayer.dlcTimeChallenge[3]++
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢层数（{2}%）".format(iconString(Icon.CLUB), EVT_MECH_1_STAKE * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER], EVT_MECH_1_STAKE * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER] * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
    else:
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_MECH_1_STAKE
        gamblerHeartsteelJackpot += EVT_MECH_1_STAKE
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        eventPlayer.dlcTimeChallenge[4]++
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢层数（{2}%）".format(iconString(Icon.DIAMOND), EVT_MECH_1_STAKE, EVT_MECH_1_STAKE * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
    wait()
    setPlayerHP()
    wait()
    eventPlayer.eventDuration = 0
