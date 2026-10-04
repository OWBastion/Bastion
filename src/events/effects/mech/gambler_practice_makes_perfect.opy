#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_PRACTICE_MAKES_PERFECT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：唯手熟尔":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.GAMBLER_PRACTICE_MAKES_PERFECT, getTotalTimeElapsed() >= eventPlayer.eventMissionGoal, eventPlayer.isHoldingButton(Button.ABILITY_1)]) == true

    # eventMissionGoal 借用为"下次可结算时间戳"：按下即锁 0.5 秒，连按/长按都不能提前结算
    eventPlayer.eventMissionGoal = getTotalTimeElapsed() + EVT_MECH_29_ROLL_COOLDOWN
    if random.randint(0, 99) < EVT_MECH_29_WIN_RATE:
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_MECH_29_REWARD_STACKS * EVT_MECH_29_WIN_MULTIPLIER * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢层数（{2}%）".format(iconString(Icon.CLUB), EVT_MECH_29_REWARD_STACKS * EVT_MECH_29_WIN_MULTIPLIER * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER], EVT_MECH_29_REWARD_STACKS * EVT_MECH_29_WIN_MULTIPLIER * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER] * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
    else:
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_MECH_29_STAKE
        gamblerHeartsteelJackpot += EVT_MECH_29_STAKE
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢层数（{2}%）".format(iconString(Icon.DIAMOND), EVT_MECH_29_STAKE, EVT_MECH_29_STAKE * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
    setPlayerHP()
    # 边沿语义：按住期间不重复结算；松开后规则按冷却时间戳重新开火
    waitUntil(any([eventPlayer.isHoldingButton(Button.ABILITY_1) == false, eventPlayer.eventType != EventType.MECH, eventPlayer.eventId != MechEventId.GAMBLER_PRACTICE_MAKES_PERFECT]), eventPlayer.eventDuration)
