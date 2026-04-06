# Event: MechEventId.GAMBLER_HEART_OF_STEEL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：心之钢":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_HEART_OF_STEEL, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_MECH_16_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_16_WIN_RATE:
        eventPlayer.heart_steel *= EVT_MECH_16_WIN_MULTIPLIER
        smallMessage(eventPlayer, "  {0}  赢！心之钢层数变为 {1} 倍".format(iconString(Icon.CLUB), EVT_MECH_16_WIN_MULTIPLIER))
    elif eventPlayer.heart_steel > 0:
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢层数（{2}%）".format(iconString(Icon.DIAMOND), (eventPlayer.heart_steel + 1) / 2, ((eventPlayer.heart_steel + 1) / 2) * EVT_8_HP_PERCENT_PER_STACK))
        eventPlayer.heart_steel -= (eventPlayer.heart_steel + 1) / 2
    else:
        smallMessage(eventPlayer, "  {0}  输！失去 25 层心之钢层数（{1}%）".format(iconString(Icon.DIAMOND), 25 * EVT_8_HP_PERCENT_PER_STACK))
        eventPlayer.heart_steel -= 25
    wait()
    setPlayerHP()
    wait()
    eventPlayer.eventDuration = 0
