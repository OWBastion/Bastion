# Event: MechEventId.GAMBLER_LONG_INVESTMENT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：长期投资 (豪赌)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_LONG_INVESTMENT, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_17_WIN_CHANCE:
        eventPlayer.heart_steel += 20
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（{2}% 最大生命值）".format(iconString(Icon.CLUB), EVT_MECH_17_REWARD_STACKS, EVT_MECH_17_REWARD_STACKS * EVT_8_HP_PERCENT_PER_STACK))
        setPlayerHP()
    else:
        smallMessage(eventPlayer, "  {0}  输！祝你好运".format(iconString(Icon.DIAMOND)))
    eventPlayer.eventForceRoll = EVT_MECH_17_FORCE_ROLL
    eventPlayer.eventForceCount = EVT_MECH_17_FORCE_COUNT
    smallMessage(eventPlayer, "  {0}  合约已生效：未来 5 个事件为 减益".format(iconString(Icon.DIAMOND)))
    clearPlayerEvent()
