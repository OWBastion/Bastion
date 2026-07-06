#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_HEART_OF_STEEL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：心之钢":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.GAMBLER_HEART_OF_STEEL, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_16_WIN_RATE:
        eventPlayer.heart_steel[HeartSteelData.STACKS] *= EVT_MECH_16_WIN_MULTIPLIER
        eventPlayer.dlcTimeChallenge[3]++
        smallMessage(eventPlayer, "  {0}  赢！心之钢层数变为 {1} 倍".format(iconString(Icon.CLUB), EVT_MECH_16_WIN_MULTIPLIER))
    elif eventPlayer.heart_steel[HeartSteelData.STACKS] > 0:
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢层数（{2}%）".format(iconString(Icon.DIAMOND), eventPlayer.heart_steel[HeartSteelData.STACKS], eventPlayer.heart_steel[HeartSteelData.STACKS] * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
        eventPlayer.temp = (eventPlayer.heart_steel[HeartSteelData.STACKS] + 1) / 2
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= eventPlayer.temp
        gamblerHeartsteelJackpot += eventPlayer.temp
        eventPlayer.dlcTimeChallenge[4]++
    else:
        smallMessage(eventPlayer, "  {0}  输！失去 25 层心之钢层数（{1}%）".format(iconString(Icon.DIAMOND), 25 * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= 25
        gamblerHeartsteelJackpot += 25
        eventPlayer.dlcTimeChallenge[4]++
    wait()
    setPlayerHP()
    wait()
    eventPlayer.eventDuration = 0
