#!mainFile "../devMain.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "initialize event array":
    @Condition vishkarEventActivated == true

    eventWeight = EVT_INIT_EVENT_WEIGHT
    
    # ================================================
    # 增益事件 (Buff Events)
    # ================================================
    buffEvent = []
    buffEventId = []
    
    # Pack 0 - Special
    buffEvent[BuffEventId.OLIVIA_GIFT] = [STR_EVT_BUFF_0_TITLE, STR_EVT_BUFF_0_DESC, EVT_BUFF_0_DURATION, EVT_BUFF_0_WEIGHT]
    buffEventId.append(BuffEventId.OLIVIA_GIFT)
    
    # ================================================
    # Pack 1: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_1_TITLE, true, 1):
        goto lbl_0
    buffEvent[BuffEventId.GALE_BLESSING] = [STR_EVT_BUFF_1_TITLE, STR_EVT_BUFF_1_DESC.format(EVT_1_SPEED_BOOST), EVT_BUFF_1_DURATION, EVT_BUFF_1_WEIGHT]
    buffEventId.append(BuffEventId.GALE_BLESSING)
    lbl_0:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_2_TITLE, true, 2):
        goto lbl_1
    buffEvent[BuffEventId.IRON_BULWARK] = [STR_EVT_BUFF_2_TITLE, STR_EVT_BUFF_2_DESC.format(EVT_2_ARMOR_AMOUNT, negToPos(EVT_2_DMG_TAKEN)), EVT_BUFF_2_DURATION, EVT_BUFF_2_WEIGHT]
    buffEventId.append(BuffEventId.IRON_BULWARK)
    lbl_1:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_3_TITLE, true, 3):
        goto lbl_2
    buffEvent[BuffEventId.ADRENALINE] = [STR_EVT_BUFF_3_TITLE, STR_EVT_BUFF_3_DESC.format(negToPos(EVT_3_DMG_TAKEN), EVT_3_HEAL_BOOST), EVT_BUFF_3_DURATION, EVT_BUFF_3_WEIGHT]
    buffEventId.append(BuffEventId.ADRENALINE)
    lbl_2:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_4_TITLE, true, 4):
        goto lbl_3
    buffEvent[BuffEventId.LIFE_SPRING] = [STR_EVT_BUFF_4_TITLE, STR_EVT_BUFF_4_DESC.format(EVT_4_HEAL_PERCENT * 100), EVT_BUFF_4_DURATION, EVT_BUFF_4_WEIGHT]
    buffEventId.append(BuffEventId.LIFE_SPRING)
    lbl_3:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_5_TITLE, true, 5):
        goto lbl_4
    buffEvent[BuffEventId.BLACK_FANS_ASSAULT] = [STR_EVT_BUFF_5_TITLE, STR_EVT_BUFF_5_DESC.format(EVT_5_HEALTH_FLAT, percent(EVT_5_HEALTH_MAXHP_FACTOR)), EVT_BUFF_5_DURATION, EVT_BUFF_5_WEIGHT]
    buffEventId.append(BuffEventId.BLACK_FANS_ASSAULT)
    lbl_4:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_6_TITLE, true, 6):
        goto lbl_5
    buffEvent[BuffEventId.SPEED_STACK] = [STR_EVT_BUFF_6_TITLE, STR_EVT_BUFF_6_DESC.format(EVT_6_SPEED_INC_PER_SEC), EVT_BUFF_6_DURATION, EVT_BUFF_6_WEIGHT]
    buffEventId.append(BuffEventId.SPEED_STACK)
    lbl_5:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_7_TITLE, true, 7):
        goto lbl_6
    buffEvent[BuffEventId.FLESH_REGEN] = [STR_EVT_BUFF_7_TITLE, STR_EVT_BUFF_7_DESC.format(EVT_7_BASE_HEALTH, EVT_7_HEALTH_PERCENT * 100, EVT_7_REGEN_INTERVAL), EVT_BUFF_7_DURATION, EVT_BUFF_7_WEIGHT]
    buffEventId.append(BuffEventId.FLESH_REGEN)
    lbl_6:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_8_TITLE, true, 8):
        goto lbl_7
    buffEvent[BuffEventId.HEART_OF_STEEL] = [STR_EVT_BUFF_8_TITLE, STR_EVT_BUFF_8_DESC.format(EVT_8_HP_LAYER_PER_DEATH, EVT_8_HP_PERCENT_PER_STACK), EVT_BUFF_8_DURATION, EVT_BUFF_8_WEIGHT]
    buffEventId.append(BuffEventId.HEART_OF_STEEL)
    lbl_7:

    # ================================================
    # Pack 2: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_11_TITLE, true, 11):
        goto lbl_10
    buffEvent[BuffEventId.DEATH_DELAY] = [STR_EVT_BUFF_11_TITLE, STR_EVT_BUFF_11_DESC, EVT_BUFF_11_DURATION, EVT_BUFF_11_WEIGHT]
    buffEventId.append(BuffEventId.DEATH_DELAY)
    lbl_10:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_12_TITLE, true, 12):
        goto lbl_11
    buffEvent[BuffEventId.SYMBIOSIS] = [STR_EVT_BUFF_12_TITLE, STR_EVT_BUFF_12_DESC.format(Button.INTERACT), EVT_BUFF_12_DURATION, EVT_BUFF_12_WEIGHT]
    buffEventId.append(BuffEventId.SYMBIOSIS)
    lbl_11:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_13_TITLE, true, 13):
        goto lbl_12
    buffEvent[BuffEventId.KONAMI_CODE] = [STR_EVT_BUFF_13_TITLE, STR_EVT_BUFF_13_DESC.format(EVT_13_CHECKPOINT_INTERVAL), EVT_BUFF_13_DURATION, EVT_BUFF_13_WEIGHT]
    buffEventId.append(BuffEventId.KONAMI_CODE)
    lbl_12:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_14_TITLE, true, 14):
        goto lbl_13
    buffEvent[BuffEventId.PHOTON_SHIELD] = [STR_EVT_BUFF_14_TITLE, STR_EVT_BUFF_14_DESC.format(EVT_14_SHIELD_PERCENT * 100), EVT_BUFF_14_DURATION, EVT_BUFF_14_WEIGHT]
    buffEventId.append(BuffEventId.PHOTON_SHIELD)
    lbl_13:

    # ================================================
    # Pack 3: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_16_TITLE, true, 16):
        goto lbl_15
    buffEvent[BuffEventId.REGROUP_CALL] = [STR_EVT_BUFF_16_TITLE, STR_EVT_BUFF_16_DESC.format(EVT_16_CHECK_INTERVAL, EVT_16_INVINCIBLE_DURATION), EVT_BUFF_16_DURATION, EVT_BUFF_16_WEIGHT]
    buffEventId.append(BuffEventId.REGROUP_CALL)
    lbl_15:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_18_TITLE, true, 18):
        goto lbl_17
    buffEvent[BuffEventId.RESOLVE] = [STR_EVT_BUFF_18_TITLE, STR_EVT_BUFF_18_DESC.format(negToPos(EVT_18_KNOCKBACK_RESISTANCE), EVT_18_DMG_REDUCE_PER_STACK, EVT_18_HEAL_PERCENT * 100), EVT_BUFF_18_DURATION, EVT_BUFF_18_WEIGHT]
    buffEventId.append(BuffEventId.RESOLVE)
    lbl_17:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_19_TITLE, true, 19):
        goto lbl_18
    buffEvent[BuffEventId.WILL_TO_WIN] = [STR_EVT_BUFF_19_TITLE, STR_EVT_BUFF_19_DESC.format(EVT_19_TRIGGER_HP_PERCENT * 100, EVT_19_INVINCIBLE_DURATION), EVT_BUFF_19_DURATION, EVT_BUFF_19_WEIGHT]
    buffEventId.append(BuffEventId.WILL_TO_WIN)
    lbl_18:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_20_TITLE, true, 20):
        goto lbl_19
    buffEvent[BuffEventId.PHEIDIPPIDES_TRIAL] = [STR_EVT_BUFF_20_TITLE, STR_EVT_BUFF_20_DESC.format(EVT_20_DISTANCE_GOAL, EVT_20_REWARD_SPEED), EVT_BUFF_20_DURATION, EVT_BUFF_20_WEIGHT]
    buffEventId.append(BuffEventId.PHEIDIPPIDES_TRIAL)
    lbl_19:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_21_TITLE, true, 21):
        goto lbl_20
    buffEvent[BuffEventId.HEART_OF_STEEL_PRO] = [STR_EVT_BUFF_21_TITLE, STR_EVT_BUFF_21_DESC.format(EVT_21_HP_GAIN_FLAT, EVT_21_HP_MULTIPLIER), EVT_BUFF_21_DURATION, EVT_BUFF_21_WEIGHT]
    buffEventId.append(BuffEventId.HEART_OF_STEEL_PRO)
    lbl_20:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_22_TITLE, true, 22):
        goto lbl_21
    buffEvent[BuffEventId.STAT_POWER] = [STR_EVT_BUFF_22_TITLE, STR_EVT_BUFF_22_DESC.format(EVT_22_HEAL_BOOST), EVT_BUFF_22_DURATION, EVT_BUFF_22_WEIGHT]
    buffEventId.append(BuffEventId.STAT_POWER)
    lbl_21:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_23_TITLE, true, 23):
        goto lbl_22
    buffEvent[BuffEventId.ULT_MOMENTUM] = [STR_EVT_BUFF_23_TITLE, STR_EVT_BUFF_23_DESC.format(EVT_23_DMG_REDUCTION_DURING_ULT), EVT_BUFF_23_DURATION, EVT_BUFF_23_WEIGHT]
    buffEventId.append(BuffEventId.ULT_MOMENTUM)
    lbl_22:
    
    # ================================================
    # Pack 4: Buffs
    # ================================================
    buffEvent[BuffEventId.PHASE_SURGE] = [STR_EVT_BUFF_24_TITLE, STR_EVT_BUFF_24_DESC.format(EVT_24_SPEED_BOOST), EVT_BUFF_24_DURATION, EVT_BUFF_24_WEIGHT]
    buffEventId.append(BuffEventId.PHASE_SURGE)

    buffEvent[BuffEventId.BODYGUARD] = [STR_EVT_BUFF_25_TITLE, STR_EVT_BUFF_25_DESC, EVT_BUFF_25_DURATION, EVT_BUFF_25_WEIGHT]
    buffEventId.append(BuffEventId.BODYGUARD)

    buffEvent[BuffEventId.MARTYR_TRIAL] = [STR_EVT_BUFF_26_TITLE, STR_EVT_BUFF_26_DESC.format(EVT_26_REWARD_DMG_PERMA), EVT_BUFF_26_DURATION, EVT_BUFF_26_WEIGHT]
    buffEventId.append(BuffEventId.MARTYR_TRIAL)

    buffEvent[BuffEventId.HYPERACTIVE_HEAL] = [STR_EVT_BUFF_27_TITLE, STR_EVT_BUFF_27_DESC.format(EVT_27_HOT_FLAT, percent(EVT_27_HOT_MAXHP_FACTOR)), EVT_BUFF_27_DURATION, EVT_BUFF_27_WEIGHT]
    buffEventId.append(BuffEventId.HYPERACTIVE_HEAL)

    buffEvent[BuffEventId.MORALE_BOOST_PROMAX] = [STR_EVT_BUFF_28_TITLE, STR_EVT_BUFF_28_DESC.format(EVT_28_HEAL_RADIUS, EVT_28_HOT_FLAT, percent(EVT_28_HOT_MAXHP_FACTOR)), EVT_BUFF_28_DURATION, EVT_BUFF_28_WEIGHT]
    buffEventId.append(BuffEventId.MORALE_BOOST_PROMAX)

    buffEvent[BuffEventId.F5_REFRESH] = [STR_EVT_BUFF_30_TITLE, STR_EVT_BUFF_30_DESC.format(EVT_30_REFRESH_INTERVAL), EVT_BUFF_30_DURATION, EVT_BUFF_30_WEIGHT]
    buffEventId.append(BuffEventId.F5_REFRESH)

    buffEvent[BuffEventId.HEALING_TOWER_PROMAX] = [STR_EVT_BUFF_31_TITLE, STR_EVT_BUFF_31_DESC.format(EVT_31_HEAL_FLAT, percent(EVT_31_HEAL_MAXHP_FACTOR)), EVT_BUFF_31_DURATION, EVT_BUFF_31_WEIGHT]
    buffEventId.append(BuffEventId.HEALING_TOWER_PROMAX)

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_32_TITLE, true, 32):
        goto lbl_32
    buffEvent[BuffEventId.SUPER_TRANSFORM] = [STR_EVT_BUFF_32_TITLE, STR_EVT_BUFF_32_DESC.format(EVT_32_HP_FLAT, percent(EVT_32_HP_MAXHP_FACTOR), EVT_32_OVERHEALTH_DURATION), EVT_BUFF_32_DURATION, EVT_BUFF_32_WEIGHT]
    buffEventId.append(BuffEventId.SUPER_TRANSFORM)
    lbl_32:

    buffEvent[BuffEventId.DRAW_FIRE] = [STR_EVT_BUFF_33_TITLE, STR_EVT_BUFF_33_DESC.format(EVT_33_ARMOR_AMOUNT, negToPos(EVT_33_DMG_TAKEN)), EVT_BUFF_33_DURATION, EVT_BUFF_33_WEIGHT]
    buffEventId.append(BuffEventId.DRAW_FIRE)

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_34_TITLE, true, 34):
        goto lbl_33
    buffEvent[BuffEventId.TENACITY] = [STR_EVT_BUFF_34_TITLE, STR_EVT_BUFF_34_DESC.format(percent(EVT_34_TRIGGER_HP_PERCENT), percent(EVT_34_HEAL_MAXHP_FACTOR), EVT_34_TRIGGER_COOLDOWN), EVT_BUFF_34_DURATION, EVT_BUFF_34_WEIGHT]
    buffEventId.append(BuffEventId.TENACITY)
    lbl_33:
    
    # ================================================
    # 减益事件 (Debuff Events)
    # ================================================
    debuffEvent = []
    debuffEventId = []
    
    # ================================================
    # Pack 1: Debuffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_0_TITLE, true):
        goto lbl_33
    debuffEvent[DebuffEventId.GRAVITY_ANOMALY] = [
        STR_EVT_DEBUFF_0_TITLE,
        STR_EVT_DEBUFF_0_DESC.format(negToPos(EVT_DEBUFF_0_SPEED), EVT_DEBUFF_0_GRAVITY),
        EVT_DEBUFF_0_DURATION,
        EVT_DEBUFF_0_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRAVITY_ANOMALY)
    lbl_33:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_1_TITLE, true, 1):
        goto lbl_34
    # 注：常量里没有 EVT_DEBUFF_1_DURATION，通常用 HACK_DURATION 作为该事件持续时间
    debuffEvent[DebuffEventId.EMP] = [
        STR_EVT_DEBUFF_1_TITLE,
        STR_EVT_DEBUFF_1_DESC,
        EVT_DEBUFF_1_HACK_DURATION,
        EVT_DEBUFF_1_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.EMP)
    lbl_34:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_2_TITLE, true, 2):
        goto lbl_35
    debuffEvent[DebuffEventId.SACRIFICE] = [
        STR_EVT_DEBUFF_2_TITLE,
        STR_EVT_DEBUFF_2_DESC.format(percent(EVT_DEBUFF_2_DMG_PERCENT)),
        EVT_DEBUFF_2_DURATION,
        EVT_DEBUFF_2_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SACRIFICE)
    lbl_35:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_3_TITLE, true, 3):
        goto lbl_36
    debuffEvent[DebuffEventId.VULNERABLE] = [
        STR_EVT_DEBUFF_3_TITLE,
        STR_EVT_DEBUFF_3_DESC.format(EVT_DEBUFF_3_DMG_TAKEN),
        EVT_DEBUFF_3_DURATION,
        EVT_DEBUFF_3_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.VULNERABLE)
    lbl_36:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_4_TITLE, true, 4):
        goto lbl_37
    debuffEvent[DebuffEventId.SPEED_LIMIT_40] = [
        STR_EVT_DEBUFF_4_TITLE,
        STR_EVT_DEBUFF_4_DESC.format(EVT_DEBUFF_4_DMG_BASE, percent(EVT_DEBUFF_4_DMG_PERCENT)),
        EVT_DEBUFF_4_DURATION,
        EVT_DEBUFF_4_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SPEED_LIMIT_40)
    lbl_37:

    # ================================================
    # Pack 2: Debuffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_5_TITLE, true, 5):
        goto lbl_38
    debuffEvent[DebuffEventId.GRAVITY_PULL] = [
        STR_EVT_DEBUFF_5_TITLE,
        STR_EVT_DEBUFF_5_DESC.format(EVT_DEBUFF_5_SPEED_REDUCTION),
        EVT_DEBUFF_5_DURATION,
        EVT_DEBUFF_5_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRAVITY_PULL)
    lbl_38:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_6_TITLE, true, 5):
        goto lbl_39
    debuffEvent[DebuffEventId.OSTEOPOROSIS] = [
        STR_EVT_DEBUFF_6_TITLE,
        STR_EVT_DEBUFF_6_DESC.format(negToPos(EVT_DEBUFF_6_MAX_SPEED_DEC)),
        EVT_DEBUFF_6_DURATION,
        EVT_DEBUFF_6_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.OSTEOPOROSIS)
    lbl_39:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_7_TITLE, true, 7):
        goto lbl_40
    debuffEvent[DebuffEventId.EMP_PROMAX] = [
        STR_EVT_DEBUFF_7_TITLE,
        STR_EVT_DEBUFF_7_DESC.format(EVT_DEBUFF_7_RADIUS),
        EVT_DEBUFF_7_DURATION,
        EVT_DEBUFF_7_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.EMP_PROMAX)
    lbl_40:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_8_TITLE, true, 8):
        goto lbl_41
    debuffEvent[DebuffEventId.ENERGY_LEAK] = [
        STR_EVT_DEBUFF_8_TITLE,
        STR_EVT_DEBUFF_8_DESC.format(percent(EVT_DEBUFF_8_DMG_PERCENT)),
        EVT_DEBUFF_8_DURATION,
        EVT_DEBUFF_8_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.ENERGY_LEAK)
    lbl_41:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_10_TITLE, true, 10):
        goto lbl_43
    debuffEvent[DebuffEventId.SHARE_THE_PAIN] = [
        STR_EVT_DEBUFF_10_TITLE,
        STR_EVT_DEBUFF_10_DESC.format(percent(EVT_DEBUFF_10_DMG_FACTOR), EVT_DEBUFF_10_RADIUS),
        EVT_DEBUFF_10_DURATION,
        EVT_DEBUFF_10_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SHARE_THE_PAIN)
    lbl_43:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_11_TITLE, true, 11):
        goto lbl_44
    debuffEvent[DebuffEventId.FEAST_FRENZY] = [
        STR_EVT_DEBUFF_11_TITLE,
        STR_EVT_DEBUFF_11_DESC.format(EVT_DEBUFF_11_BERSERK_ADD),
        EVT_DEBUFF_11_DURATION,
        EVT_DEBUFF_11_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.FEAST_FRENZY)
    lbl_44:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_12_TITLE, true, 12):
        goto lbl_45
    debuffEvent[DebuffEventId.POWERLESS_SPOUSE] = [
        STR_EVT_DEBUFF_12_TITLE,
        STR_EVT_DEBUFF_12_DESC.format(EVT_DEBUFF_12_KNOCKDOWN_DURATION),
        EVT_DEBUFF_12_DURATION,
        EVT_DEBUFF_12_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.POWERLESS_SPOUSE)
    lbl_45:

    # ================================================
    # Pack 3: Debuffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_13_TITLE, true, 13):
        goto lbl_46
    debuffEvent[DebuffEventId.GRIEVOUS_WOUNDS] = [
        STR_EVT_DEBUFF_13_TITLE,
        STR_EVT_DEBUFF_13_DESC.format(negToPos(EVT_DEBUFF_13_HEAL_DEALT_RED)),
        EVT_DEBUFF_13_DURATION,
        EVT_DEBUFF_13_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRIEVOUS_WOUNDS)
    lbl_46:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_14_TITLE, true, 14):
        goto lbl_47
    debuffEvent[DebuffEventId.HALVED] = [
        STR_EVT_DEBUFF_14_TITLE,
        STR_EVT_DEBUFF_14_DESC.format(EVT_DEBUFF_14_INTERVAL, percent(EVT_DEBUFF_14_DAMAGE_PERCENT), percent(EVT_DEBUFF_14_EXECUTE_THRESHOLD)),
        EVT_DEBUFF_14_DURATION,
        EVT_DEBUFF_14_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.HALVED)
    lbl_47:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_15_TITLE, true, 15):
        goto lbl_48
    debuffEvent[DebuffEventId.SELFLESS_GIVEAWAY] = [
        STR_EVT_DEBUFF_15_TITLE,
        STR_EVT_DEBUFF_15_DESC.format(EVT_DEBUFF_15_STACKS_TAKE),
        EVT_DEBUFF_15_DURATION,
        EVT_DEBUFF_15_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SELFLESS_GIVEAWAY)
    lbl_48:
    
    # ================================================
    # Pack 4: Debuffs
    # ================================================
    debuffEvent[DebuffEventId.KEEP_DISTANCE_AURA] = [STR_EVT_DEBUFF_16_TITLE, STR_EVT_DEBUFF_16_DESC, EVT_DEBUFF_16_DURATION, EVT_DEBUFF_16_WEIGHT]
    debuffEventId.append(DebuffEventId.KEEP_DISTANCE_AURA)

    debuffEvent[DebuffEventId.ERROR_404] = [STR_EVT_DEBUFF_17_TITLE, STR_EVT_DEBUFF_17_DESC, EVT_DEBUFF_17_DURATION, EVT_DEBUFF_17_WEIGHT]
    debuffEventId.append(DebuffEventId.ERROR_404)

    debuffEvent[DebuffEventId.CHAIN_OVERLOAD] = [STR_EVT_DEBUFF_18_TITLE, STR_EVT_DEBUFF_18_DESC, EVT_DEBUFF_18_DURATION, EVT_DEBUFF_18_WEIGHT]
    debuffEventId.append(DebuffEventId.CHAIN_OVERLOAD)

    debuffEvent[DebuffEventId.HEALTH_SYNC] = [STR_EVT_DEBUFF_19_TITLE, STR_EVT_DEBUFF_19_DESC, EVT_DEBUFF_19_DURATION, EVT_DEBUFF_19_WEIGHT]
    debuffEventId.append(DebuffEventId.HEALTH_SYNC)

    debuffEvent[DebuffEventId.VAMPIRE] = [STR_EVT_DEBUFF_20_TITLE, STR_EVT_DEBUFF_20_DESC, EVT_DEBUFF_20_DURATION, EVT_DEBUFF_20_WEIGHT]
    debuffEventId.append(DebuffEventId.VAMPIRE)

    debuffEvent[DebuffEventId.MOON_ROCKET] = [STR_EVT_DEBUFF_22_TITLE, STR_EVT_DEBUFF_22_DESC, EVT_DEBUFF_22_DURATION, EVT_DEBUFF_22_WEIGHT]
    debuffEventId.append(DebuffEventId.MOON_ROCKET)
    
    # ================================================
    # 机制事件 (Mech Events)
    # ================================================
    mechEvent = []
    mechEventId = []
    
    # ================================================
    # Pack 3: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_MECH, STR_EVT_MECH_0_TITLE, true):
        goto lbl_55
    mechEvent[MechEventId.EXTREME_CHALLENGE] = [
        STR_EVT_MECH_0_TITLE,
        STR_EVT_MECH_0_DESC.format(negToPos(EVT_MECH_0_DMG_TAKEN), percent(EVT_MECH_0_HP_PERCENT)),
        EVT_MECH_0_DURATION,
        EVT_MECH_0_WEIGHT
    ]
    mechEventId.append(MechEventId.EXTREME_CHALLENGE)
    lbl_55:

    # ================================================
    # Pack 1: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_1_TITLE, true, 1):
        goto lbl_56
    mechEvent[MechEventId.NANO_ARMOR] = [
        STR_EVT_MECH_1_TITLE,
        STR_EVT_MECH_1_DESC.format(percent(EVT_MECH_1_HP_MULTIPLIER), negToPos(EVT_MECH_1_SPEED_PENALTY)),
        EVT_MECH_1_DURATION,
        EVT_MECH_1_WEIGHT
    ]
    mechEventId.append(MechEventId.NANO_ARMOR)
    lbl_56:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_2_TITLE, true, 2):
        goto lbl_57
    mechEvent[MechEventId.GAMBLER] = [STR_EVT_MECH_2_TITLE, STR_EVT_MECH_2_DESC.format(Button.RELOAD, EVT_MECH_2_WIN_RATE, EVT_MECH_2_STAKE), EVT_MECH_2_DURATION, EVT_MECH_2_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER)
    lbl_57:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_3_TITLE, true, 3):
        goto lbl_58
    mechEvent[MechEventId.CHILL_MODE] = [STR_EVT_MECH_3_TITLE, STR_EVT_MECH_3_DESC, EVT_MECH_3_DURATION, EVT_MECH_3_WEIGHT]
    mechEventId.append(MechEventId.CHILL_MODE)
    lbl_58:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_4_TITLE, true, 4):
        goto lbl_59
    mechEvent[MechEventId.MINI_FORM] = [STR_EVT_MECH_4_TITLE, STR_EVT_MECH_4_DESC.format(percent(1 - EVT_MECH_4_MODEL_SCALE), percent(1 - EVT_MECH_4_HP_SCALE), EVT_MECH_4_SPEED_BOOST), EVT_MECH_4_DURATION, EVT_MECH_4_WEIGHT]
    mechEventId.append(MechEventId.MINI_FORM)
    lbl_59:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_5_TITLE, true, 5):
        goto lbl_60
    mechEvent[MechEventId.STEALTH_CROUCH] = [STR_EVT_MECH_5_TITLE, STR_EVT_MECH_5_DESC.format(EVT_MECH_5_SPEED_PENALTY), EVT_MECH_5_DURATION, EVT_MECH_5_WEIGHT]
    mechEventId.append(MechEventId.STEALTH_CROUCH)
    lbl_60:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_6_TITLE, true, 6):
        goto lbl_61
    mechEvent[MechEventId.EMERGENCY_EVASION] = [STR_EVT_MECH_6_TITLE, STR_EVT_MECH_6_DESC.format(EVT_MECH_6_SPEED_DURATION, EVT_MECH_6_SPEED_BOOST), EVT_MECH_6_DURATION, EVT_MECH_6_WEIGHT]
    mechEventId.append(MechEventId.EMERGENCY_EVASION)
    lbl_61:

    # ================================================
    # Pack 2: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_MECH, STR_EVT_MECH_7_TITLE, true, 7):
        goto lbl_62
    mechEvent[MechEventId.BRAKE_FAILURE] = [STR_EVT_MECH_7_TITLE, STR_EVT_MECH_7_DESC.format(100 + EVT_MECH_7_MAX_SPEED), EVT_MECH_7_DURATION, EVT_MECH_7_WEIGHT]
    mechEventId.append(MechEventId.BRAKE_FAILURE)
    lbl_62:

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_MECH, STR_EVT_MECH_8_TITLE, true, 8):
        goto lbl_67
    mechEvent[MechEventId.JUMP_THRUST] = [
        STR_EVT_MECH_8_TITLE,
        STR_EVT_MECH_8_DESC.format(Button.JUMP, negToPos(EVT_MECH_8_DMG_TAKEN)),
        EVT_MECH_8_DURATION,
        EVT_MECH_8_WEIGHT
    ]
    mechEventId.append(MechEventId.JUMP_THRUST)
    lbl_67:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_MECH, STR_EVT_MECH_9_TITLE, true, 9):
        goto lbl_68
    mechEvent[MechEventId.GAMBLER_SPEED_CHALLENGE] = [
        STR_EVT_MECH_9_TITLE,
        STR_EVT_MECH_9_DESC.format(Button.RELOAD, percent(EVT_MECH_9_HP_PENALTY), EVT_MECH_9_PROB_LOSE_NORMAL - EVT_MECH_9_PROB_WIN_NORMAL, EVT_MECH_9_VAL_NORMAL, 100 - EVT_MECH_9_PROB_LOSE_NORMAL, EVT_MECH_9_VAL_RARE),
        EVT_MECH_9_DURATION,
        EVT_MECH_9_WEIGHT
    ]
    mechEventId.append(MechEventId.GAMBLER_SPEED_CHALLENGE)
    lbl_68:

    # ================================================
    # Pack 4: Mechanics
    # ================================================
    mechEvent[MechEventId.CHEAT_CARD_COUNTING] = [STR_EVT_MECH_10_TITLE, STR_EVT_MECH_10_DESC.format(Button.RELOAD, EVT_MECH_10_HEART_STEEL_COST, EVT_MECH_10_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK), EVT_MECH_10_DURATION, EVT_MECH_10_WEIGHT]
    mechEventId.append(MechEventId.CHEAT_CARD_COUNTING)

    mechEvent[MechEventId.GAMBLER_SHORT_INVESTMENT] = [STR_EVT_MECH_12_TITLE, STR_EVT_MECH_12_DESC.format(Button.RELOAD, EVT_MECH_12_CONTRACT_EVENTS, EVT_MECH_12_WIN_CHANCE, EVT_MECH_12_REWARD_STACKS), EVT_MECH_12_DURATION, EVT_MECH_12_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_SHORT_INVESTMENT)

    mechEvent[MechEventId.FATE_SYNC] = [STR_EVT_MECH_13_TITLE, STR_EVT_MECH_13_DESC, EVT_MECH_13_DURATION, EVT_MECH_13_WEIGHT]
    mechEventId.append(MechEventId.FATE_SYNC)

    mechEvent[MechEventId.CHEAT_SKIP_HERO] = [STR_EVT_MECH_14_TITLE, STR_EVT_MECH_14_DESC.format(Button.RELOAD), EVT_MECH_14_DURATION, EVT_MECH_14_WEIGHT]
    mechEventId.append(MechEventId.CHEAT_SKIP_HERO)

    mechEvent[MechEventId.NESTING_DOLL] = [STR_EVT_MECH_15_TITLE, STR_EVT_MECH_15_DESC.format(EVT_MECH_15_RESURRECT_DELAY, percent(EVT_MECH_15_SIZE_STEP), EVT_MECH_15_SPEED_STEP), EVT_MECH_15_DURATION, EVT_MECH_15_WEIGHT]
    mechEventId.append(MechEventId.NESTING_DOLL)

    mechEvent[MechEventId.GAMBLER_LONG_INVESTMENT] = [STR_EVT_MECH_17_TITLE, STR_EVT_MECH_17_DESC.format(Button.RELOAD, EVT_MECH_17_CONTRACT_EVENTS, EVT_MECH_17_WIN_CHANCE, EVT_MECH_17_REWARD_STACKS), EVT_MECH_17_DURATION, EVT_MECH_17_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_LONG_INVESTMENT)

    mechEvent[MechEventId.VALKYRIE_DESCENT] = [STR_EVT_MECH_18_TITLE, STR_EVT_MECH_18_DESC.format(EVT_MECH_18_SIZE_HEALTH * 100, percent(EVT_MECH_18_HEAL_SMOOTHING)), EVT_MECH_18_DURATION, EVT_MECH_18_WEIGHT]
    mechEventId.append(MechEventId.VALKYRIE_DESCENT)

    mechEvent[MechEventId.TRINITY_SSR] = [STR_EVT_MECH_19_TITLE, STR_EVT_MECH_19_DESC.format(100 / EVT_MECH_19_DMG_REDUCE_DIVISOR, EVT_MECH_19_SPEED_FACTOR, EVT_MECH_19_INTERVAL / EVT_MECH_19_HEART_STEEL_PER_TICK), EVT_MECH_19_DURATION, EVT_MECH_19_WEIGHT]
    mechEventId.append(MechEventId.TRINITY_SSR)
