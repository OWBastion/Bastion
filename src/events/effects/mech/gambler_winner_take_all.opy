#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_WINNER_TAKE_ALL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：赢家通吃":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.GAMBLER_WINNER_TAKE_ALL, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventMission = max(1, floor(eventPlayer.heart_steel[HeartSteelData.STACKS] * EVT_MECH_24_STAKE_RATIO))
    eventPlayer.heart_steel[HeartSteelData.STACKS] -= eventPlayer.eventMission
    gamblerHeartsteelJackpot += eventPlayer.eventMission
    if random.randint(0, 99) < EVT_MECH_24_WIN_RATE:
        eventPlayer.temp = gamblerHeartsteelJackpot
        eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.temp
        gamblerHeartsteelJackpot = 0
        eventPlayer.dlcTimeChallenge[3]++
        smallMessage(eventPlayer, "  {0}  赢！清空奖池并获得 {1} 层心之钢".format(iconString(Icon.CLUB), eventPlayer.temp))
    else:
        eventPlayer.dlcTimeChallenge[4]++
        smallMessage(eventPlayer, "  {0}  输！奖池保留，你失去 {1} 层心之钢".format(iconString(Icon.DIAMOND), eventPlayer.eventMission))
    wait()
    setPlayerHP()
    wait()
    eventPlayer.eventMission = 0
    eventPlayer.eventDuration = 0
