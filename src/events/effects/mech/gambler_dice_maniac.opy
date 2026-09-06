#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_DICE_MANIAC
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：掷骰狂人":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.GAMBLER_DICE_MANIAC
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.temp = random.randint(1, 6)
    if eventPlayer.temp == 1:
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_MECH_15_HEART_STEEL_DELTA_LOSS
        gamblerHeartsteelJackpot += EVT_MECH_15_HEART_STEEL_DELTA_LOSS
        setPlayerHP()
        smallMessage(eventPlayer, "  1点：永久损失 {0} 层心之钢（{1}%）".format(EVT_MECH_15_HEART_STEEL_DELTA_LOSS, EVT_MECH_15_HEART_STEEL_DELTA_LOSS * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
        playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Team.2, eventPlayer, 200)
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Team.2, eventPlayer, 200)
    elif eventPlayer.temp == 2:
        eventPlayer.mod_speed_perma -= EVT_MECH_15_SPEED_DELTA
        smallMessage(eventPlayer, "  2点：永久损失 {0}% 移速加成".format(EVT_MECH_15_SPEED_DELTA))
        playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Team.2, eventPlayer, 200)
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Team.2, eventPlayer, 200)
    elif eventPlayer.temp == 3:
        eventPlayer.mod_speed_perma += EVT_MECH_15_SPEED_DELTA
        smallMessage(eventPlayer, "  4点：永久获得 {0}% 移速加成".format(EVT_MECH_15_SPEED_DELTA))
        playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Team.1, eventPlayer, 200)
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Team.2, eventPlayer, 200)
    elif eventPlayer.temp == 4:
        eventPlayer.mod_dmg_perma += EVT_MECH_15_DMG_HEAL_DELTA
        eventPlayer.mod_heal_perma -= EVT_MECH_15_DMG_HEAL_DELTA
        smallMessage(eventPlayer, "  3点：永久损失 {0}% 伤害减免与治疗强度".format(EVT_MECH_15_DMG_HEAL_DELTA))
        playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Team.2, eventPlayer, 200)
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Team.2, eventPlayer, 200)
    elif eventPlayer.temp == 5:
        eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_MECH_15_HEART_STEEL_DELTA * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
        setPlayerHP()
        smallMessage(eventPlayer, "  5点：永久获得 {0} 层心之钢（+{1}%）".format(EVT_MECH_15_HEART_STEEL_DELTA * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER], EVT_MECH_15_HEART_STEEL_DELTA * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER] * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
        playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Team.1, eventPlayer, 200)
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Team.2, eventPlayer, 200)
    else:
        eventPlayer.mod_dmg_perma -= EVT_MECH_15_DMG_HEAL_DELTA
        eventPlayer.mod_heal_perma += EVT_MECH_15_DMG_HEAL_DELTA
        smallMessage(eventPlayer, "  6点：永久获得 {0}% 伤害减免与治疗强度".format(EVT_MECH_15_DMG_HEAL_DELTA))
        playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Team.1, eventPlayer, 200)
        playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Team.2, eventPlayer, 200)
    updatePlayerStats()
    wait(EVT_MECH_15_ROLL_INTERVAL, Wait.ABORT_WHEN_FALSE)
