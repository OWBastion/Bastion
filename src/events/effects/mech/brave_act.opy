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
        eventPlayer.eventType == 2,
        eventPlayer.eventId == MechEventId.BRAVE_ACT,
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] != PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
    ]) == true

    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] == PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_NEW:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_DRAWN
    if any([
        eventPlayer.altFormTrigger == true,
        eventPlayer.isHoldingButton(Button.RELOAD) == false,
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] != PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_DRAWN
    ]):
        return
    wait(EVT_MECH_21_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.altFormTrigger = true
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
    eventPlayer.temp = random.randint(0, 5)
    if eventPlayer.temp == 0:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HP] = true
        eventPlayer.heart_steel += EVT_MECH_21_HP_BONUS_HEART_STEEL
        setPlayerHP()
        smallMessage(eventPlayer, "  获得 1000% 最大生命值，后续不再触发随机事件")
    elif eventPlayer.temp == 1:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_DMG_REDUCTION] = true
        eventPlayer.mod_dmg_perma += EVT_MECH_21_DMG_REDUCTION_PERMA
        updatePlayerStats()
        smallMessage(eventPlayer, "  获得 65% 伤害减免，后续不再触发随机事件")
    elif eventPlayer.temp == 2:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_SPEED] = true
        eventPlayer.mod_speed_perma += EVT_MECH_21_SPEED_PERMA
        updatePlayerStats()
        smallMessage(eventPlayer, "  获得 100% 移速加成，后续不再触发随机事件")
    elif eventPlayer.temp == 3:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HEALING] = true
        eventPlayer.mod_heal_perma += EVT_MECH_21_HEALING_PERMA
        updatePlayerStats()
        smallMessage(eventPlayer, "  获得 750% 治疗强度，后续不再触发随机事件")
    elif eventPlayer.temp == 4:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_REGEN] = true
        smallMessage(eventPlayer, "  获得每秒 150+50% 最大生命值回复，后续不再触发随机事件")
    else:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_ULT] = true
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
        len(eventPlayer.playerOnceEventState) > PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_REGEN,
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_REGEN] == true
    ]) == true

    heal(eventPlayer, eventPlayer, EVT_MECH_21_REGEN_FLAT + eventPlayer.getMaxHealth() * EVT_MECH_21_REGEN_MAXHP_FACTOR)
    wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()

rule "[VishkarEvent]: 勇敢举动 (终极技能充能)":
    @Event eachPlayer
    @Team 1
    @Condition all([
        eventPlayer.hasSpawned(),
        eventPlayer.playerOnceEventState != null,
        len(eventPlayer.playerOnceEventState) > PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_ULT,
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_ULT] == true,
        (eventPlayer.getHero() == Hero.DVA and eventPlayer.isInAlternateForm()) == false
    ]) == true

    wait(EVT_MECH_21_ULT_CHARGE_INTERVAL, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(min(100, eventPlayer.getUltCharge() + EVT_MECH_21_ULT_CHARGE_GAIN))
    if ruleCondition:
        loop()
