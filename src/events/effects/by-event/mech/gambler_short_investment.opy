# Event: MechEventId.GAMBLER_SHORT_INVESTMENT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 屁动力 eff":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SHORT_INVESTMENT, eventPlayer.nanoEffect == null]) == true
    
    createEffect(getAllPlayers() if eventPlayer.isHoldingButton(Button.JUMP) else null, Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.nanoEffect = getLastCreatedEntity()
    
    waitUntil(eventPlayer.eventDuration == 0, EVT_MECH_12_DURATION)
    
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.nanoEffect = null

rule "[VishkarEvent]: 赌徒：短期投资 (交易)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SHORT_INVESTMENT, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_12_WIN_CHANCE:
        eventPlayer.heart_steel += EVT_MECH_12_REWARD_STACKS
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（{2}% 最大生命值）".format(iconString(Icon.CLUB), EVT_MECH_12_REWARD_STACKS, EVT_MECH_12_REWARD_STACKS * EVT_8_HP_PERCENT_PER_STACK))
        setPlayerHP()
    else:
        smallMessage(eventPlayer, "  {0}  输！祝你好运".format(iconString(Icon.DIAMOND)))
    eventPlayer.eventForceRoll = EVT_MECH_12_FORCE_ROLL
    eventPlayer.eventForceCount = EVT_MECH_12_FORCE_COUNT
    smallMessage(eventPlayer, "  {0}  合约已生效：未来 3 个事件为 减益".format(iconString(Icon.DIAMOND)))   
    clearPlayerEvent()
