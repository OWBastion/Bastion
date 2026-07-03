#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.BRAVE_ACT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 勇敢举动":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.eventType == EventType.MECH,
        eventPlayer.eventId == MechEventId.BRAVE_ACT,
        (
            len(eventPlayer.playerOnceEventState) <= PlayerOnceEventSlot.BRAVE_ACT_REWARD
            or eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.NONE
        )
    ]) == true

    while len(eventPlayer.playerOnceEventState) < PLAYER_ONCE_EVENT_SLOT_COUNT:
        eventPlayer.playerOnceEventState.append(DEFAULT_PLAYER_ONCE_EVENT_STATE[len(eventPlayer.playerOnceEventState)])
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SEEN] != true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SEEN] = true
    if any([
        eventPlayer.altFormActive == true,
        eventPlayer.isHoldingButton(Button.RELOAD) == false,
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] != BraveActReward.NONE
    ]):
        return
    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.altFormActive = true
    eventPlayer.temp = random.randint(1, 6)
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] = eventPlayer.temp
    if eventPlayer.temp == BraveActReward.HP:
        eventPlayer.heart_steel += EVT_MECH_21_HP_BONUS_HEART_STEEL * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1)
        setPlayerHP()
        smallMessage(eventPlayer, "  获得 {0} 层心之钢（{1}% 最大生命值），后续不再触发随机事件".format(EVT_MECH_21_HP_BONUS_HEART_STEEL * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1), EVT_MECH_21_HP_BONUS_HEART_STEEL * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1) * (EVT_8_HP_PERCENT_PER_STACK + (EVT_31_PERCENT_PER_STACK_BONUS if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 0))))
    elif eventPlayer.temp == BraveActReward.DMG_REDUCTION:
        eventPlayer.mod_dmg_perma += EVT_MECH_21_DMG_REDUCTION_PERMA
        updatePlayerStats()
        smallMessage(eventPlayer, "  获得 65% 伤害减免，后续不再触发随机事件")
    elif eventPlayer.temp == BraveActReward.SPEED:
        eventPlayer.mod_speed_perma += EVT_MECH_21_SPEED_PERMA
        updatePlayerStats()
        smallMessage(eventPlayer, "  获得 100% 移速加成，后续不再触发随机事件")
    elif eventPlayer.temp == BraveActReward.HEALING:
        eventPlayer.mod_heal_perma += EVT_MECH_21_HEALING_PERMA
        updatePlayerStats()
        smallMessage(eventPlayer, "  获得 750% 治疗强度，后续不再触发随机事件")
    elif eventPlayer.temp == BraveActReward.REGEN:
        smallMessage(eventPlayer, "  获得每秒 150+50% 最大生命值回复，后续不再触发随机事件")
    else:
        smallMessage(eventPlayer, "  获得每5秒 5% 终极技能充能，且禁用跳过")
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Team.1, eventPlayer, 200)
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Team.2, eventPlayer, 200)
    eventPlayer.eventDuration = 0
    clearPlayerEvent()

rule "[VishkarEvent]: 勇敢举动 (生命恢复)":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.isAlive(),
        eventPlayer.playerOnceEventState != null,
        len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_REWARD,
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.REGEN
    ]) == true

    heal(eventPlayer, eventPlayer, EVT_MECH_21_REGEN_FLAT + eventPlayer.maxHealthPercent(EVT_MECH_21_REGEN_MAXHP_FACTOR * 100))
    wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()

rule "[VishkarEvent]: 勇敢举动 (终极技能充能)":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.playerOnceEventState != null,
        len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_REWARD,
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.ULT,
        (eventPlayer.getHero() == Hero.DVA and eventPlayer.isInAlternateForm()) == false
    ]) == true

    wait(EVT_MECH_21_ULT_CHARGE_INTERVAL, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(min(100, eventPlayer.getUltCharge() + EVT_MECH_21_ULT_CHARGE_GAIN))
    if ruleCondition:
        loop()
