#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/等价交换"

# Event: MechEventId.EQUIVALENT_EXCHANGE (Composite)
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 变量分工（均由 clearPlayerEvent 统一清零，本事件无需额外清理）：
#   eventMissionGoal — 本事件随机提供的兑换方向（EquivalentExchangeOffer；NONE=未掷骰哨兵）
#   eventMission     — 成交闩锁（0=未成交，1=已成交；一次事件最多成交一次）
#   hudText          — 持续展示本次报价，成交/超时后随事件结束清空
#
# 可执行边界：来源属性必须真实持有才允许成交——
#   STACKS_TO_SPEED      需 heart_steel 层数 >= EVT_MECH_27_EXCHANGE_STACKS
#   SPEED_TO_REDUCTION   需 mod_speed_perma >= EVT_MECH_27_EXCHANGE_PERCENT
#   REDUCTION_TO_HEALING 需 mod_dmg_perma <= -EVT_MECH_27_EXCHANGE_PERCENT（即当前持有 ≥4% 伤害减免）
#   HEALING_TO_STACKS    需 mod_heal_perma >= EVT_MECH_27_EXCHANGE_PERCENT
# 来源不足时不置闩、不成交，仅提示，事件自然超时结束。

rule "[VishkarEvent]: 等价交换 (报价)":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.EQUIVALENT_EXCHANGE, eventPlayer.eventMissionGoal == EquivalentExchangeOffer.NONE]) == true

    # 每次事件只从固定四臂表中随机提供一条兑换方向
    eventPlayer.eventMissionGoal = random.randint(EquivalentExchangeOffer.STACKS_TO_SPEED, EquivalentExchangeOffer.HEALING_TO_STACKS)
    if eventPlayer.eventMissionGoal == EquivalentExchangeOffer.STACKS_TO_SPEED:
        eventPlayer.hudText = STR_EVT_MECH_27_OFFER_STACKS_TO_SPEED.format(EVT_MECH_27_EXCHANGE_STACKS, EVT_MECH_27_EXCHANGE_PERCENT)
    elif eventPlayer.eventMissionGoal == EquivalentExchangeOffer.SPEED_TO_REDUCTION:
        eventPlayer.hudText = STR_EVT_MECH_27_OFFER_SPEED_TO_REDUCTION.format(EVT_MECH_27_EXCHANGE_PERCENT)
    elif eventPlayer.eventMissionGoal == EquivalentExchangeOffer.REDUCTION_TO_HEALING:
        eventPlayer.hudText = STR_EVT_MECH_27_OFFER_REDUCTION_TO_HEALING.format(EVT_MECH_27_EXCHANGE_PERCENT)
    elif eventPlayer.eventMissionGoal == EquivalentExchangeOffer.HEALING_TO_STACKS:
        eventPlayer.hudText = STR_EVT_MECH_27_OFFER_HEALING_TO_STACKS.format(EVT_MECH_27_EXCHANGE_PERCENT, EVT_MECH_27_EXCHANGE_STACKS)


rule "[VishkarEvent]: 等价交换 (成交)":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.EQUIVALENT_EXCHANGE, eventPlayer.eventMission == 0, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.eventMissionGoal == EquivalentExchangeOffer.STACKS_TO_SPEED and eventPlayer.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_27_EXCHANGE_STACKS:
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_MECH_27_EXCHANGE_STACKS
        eventPlayer.mod_speed_perma += EVT_MECH_27_EXCHANGE_PERCENT
        eventPlayer.eventMission = 1
    elif eventPlayer.eventMissionGoal == EquivalentExchangeOffer.SPEED_TO_REDUCTION and eventPlayer.mod_speed_perma >= EVT_MECH_27_EXCHANGE_PERCENT:
        eventPlayer.mod_speed_perma -= EVT_MECH_27_EXCHANGE_PERCENT
        eventPlayer.mod_dmg_perma -= EVT_MECH_27_EXCHANGE_PERCENT
        eventPlayer.eventMission = 1
    elif eventPlayer.eventMissionGoal == EquivalentExchangeOffer.REDUCTION_TO_HEALING and eventPlayer.mod_dmg_perma <= -EVT_MECH_27_EXCHANGE_PERCENT:
        eventPlayer.mod_dmg_perma += EVT_MECH_27_EXCHANGE_PERCENT
        eventPlayer.mod_heal_perma += EVT_MECH_27_EXCHANGE_PERCENT
        eventPlayer.eventMission = 1
    elif eventPlayer.eventMissionGoal == EquivalentExchangeOffer.HEALING_TO_STACKS and eventPlayer.mod_heal_perma >= EVT_MECH_27_EXCHANGE_PERCENT:
        eventPlayer.mod_heal_perma -= EVT_MECH_27_EXCHANGE_PERCENT
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_MECH_27_EXCHANGE_STACKS
        eventPlayer.eventMission = 1

    if eventPlayer.eventMission == 1:
        updatePlayerStats()
        setPlayerHP()
        smallMessage(eventPlayer, "  {0}  等价交换已成交：{1}".format(iconString(Icon.CHECKMARK), eventPlayer.hudText))
        eventPlayer.eventDuration = 0
        clearPlayerEvent()
    else:
        smallMessage(eventPlayer, "  {0}  来源属性不足，本次交换不可执行".format(iconString(Icon.DIAMOND)))
