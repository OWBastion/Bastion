#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_WINNER_TAKE_ALL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：赢家通吃":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.GAMBLER_WINNER_TAKE_ALL
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    eventPlayer.hudText = "当前奖池：{0}层".format(round(gamblerHeartsteelJackpot))
    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventMission = max(1, floor(eventPlayer.heart_steel[HeartSteelData.STACKS] * EVT_MECH_24_STAKE_RATIO))
    eventPlayer.heart_steel[HeartSteelData.STACKS] -= eventPlayer.eventMission
    gamblerHeartsteelJackpot += eventPlayer.eventMission
    eventPlayer.hudText = "当前奖池：{0}层".format(round(gamblerHeartsteelJackpot))
    if random.randint(0, 99) < EVT_MECH_24_WIN_RATE:
        eventPlayer.temp = gamblerHeartsteelJackpot
        eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.temp
        gamblerHeartsteelJackpot = 0
        smallMessage(getAllPlayers(), "  {0}  {1} 清空奖池，获得 {2} 层心之钢".format(iconString(Icon.CLUB), eventPlayer, eventPlayer.temp))
    else:
        smallMessage(eventPlayer, "  {0}  {1} 层心之钢已进入奖池".format(iconString(Icon.DIAMOND), eventPlayer.eventMission))
    wait()
    setPlayerHP()
    wait()
    eventPlayer.hudText = ""
    eventPlayer.eventMission = 0
    eventPlayer.eventDuration = 0
