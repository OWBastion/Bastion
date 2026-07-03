#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_SHORT_INVESTMENT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。



rule "[VishkarEvent]: 赌徒：短期投资 (交易)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.GAMBLER_SHORT_INVESTMENT, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_8_WIN_CHANCE:
        eventPlayer.heart_steel += EVT_MECH_8_REWARD_STACKS * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1)
        eventPlayer.dlcTimeChallenge[3]++
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（{2}% 最大生命值）".format(iconString(Icon.CLUB), EVT_MECH_8_REWARD_STACKS * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1), EVT_MECH_8_REWARD_STACKS * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1) * (EVT_8_HP_PERCENT_PER_STACK + (EVT_31_PERCENT_PER_STACK_BONUS if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 0))))
        setPlayerHP()
    else:
        eventPlayer.dlcTimeChallenge[4]++
        smallMessage(eventPlayer, "  {0}  输！祝你好运".format(iconString(Icon.DIAMOND)))
    eventPlayer.eventForceRoll = EVT_MECH_8_FORCE_ROLL
    eventPlayer.eventForceCount = EVT_MECH_8_FORCE_COUNT
    smallMessage(eventPlayer, "  {0}  合约已生效：未来 3 个事件为 减益".format(iconString(Icon.DIAMOND)))   
    clearPlayerEvent()
