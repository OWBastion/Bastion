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
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_1_TITLE, true, BuffEventId.GALE_BLESSING):
        goto lbl_0
    buffEvent[BuffEventId.GALE_BLESSING] = [STR_EVT_BUFF_1_TITLE, STR_EVT_BUFF_1_DESC.format(EVT_1_SPEED_BOOST), EVT_BUFF_1_DURATION, EVT_BUFF_1_WEIGHT]
    buffEventId.append(BuffEventId.GALE_BLESSING)
    lbl_0:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_2_TITLE, true, BuffEventId.IRON_BULWARK):
        goto lbl_1
    buffEvent[BuffEventId.IRON_BULWARK] = [STR_EVT_BUFF_2_TITLE, STR_EVT_BUFF_2_DESC.format(EVT_2_ARMOR_AMOUNT, negToPos(EVT_2_DMG_TAKEN)), EVT_BUFF_2_DURATION, EVT_BUFF_2_WEIGHT]
    buffEventId.append(BuffEventId.IRON_BULWARK)
    lbl_1:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_3_TITLE, true, BuffEventId.ADRENALINE):
        goto lbl_2
    buffEvent[BuffEventId.ADRENALINE] = [STR_EVT_BUFF_3_TITLE, STR_EVT_BUFF_3_DESC.format(negToPos(EVT_3_DMG_TAKEN), EVT_3_HEAL_BOOST), EVT_BUFF_3_DURATION, EVT_BUFF_3_WEIGHT]
    buffEventId.append(BuffEventId.ADRENALINE)
    lbl_2:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_4_TITLE, true, BuffEventId.LIFE_SPRING):
        goto lbl_3
    buffEvent[BuffEventId.LIFE_SPRING] = [STR_EVT_BUFF_4_TITLE, STR_EVT_BUFF_4_DESC.format(EVT_4_HEAL_PERCENT * 100), EVT_BUFF_4_DURATION, EVT_BUFF_4_WEIGHT]
    buffEventId.append(BuffEventId.LIFE_SPRING)
    lbl_3:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_5_TITLE, true, BuffEventId.BLACK_FANS_ASSAULT):
        goto lbl_4
    buffEvent[BuffEventId.BLACK_FANS_ASSAULT] = [STR_EVT_BUFF_5_TITLE, STR_EVT_BUFF_5_DESC.format(EVT_5_HEALTH_FLAT, percent(EVT_5_HEALTH_MAXHP_FACTOR), EVT_5_SPEED_BOOST), EVT_BUFF_5_DURATION, EVT_BUFF_5_WEIGHT]
    buffEventId.append(BuffEventId.BLACK_FANS_ASSAULT)
    lbl_4:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_6_TITLE, true, BuffEventId.SPEED_STACK):
        goto lbl_5
    buffEvent[BuffEventId.SPEED_STACK] = [STR_EVT_BUFF_6_TITLE, STR_EVT_BUFF_6_DESC.format(EVT_6_SPEED_INC_PER_SEC), EVT_BUFF_6_DURATION, EVT_BUFF_6_WEIGHT]
    buffEventId.append(BuffEventId.SPEED_STACK)
    lbl_5:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_7_TITLE, true, BuffEventId.FLESH_REGEN):
        goto lbl_6
    buffEvent[BuffEventId.FLESH_REGEN] = [STR_EVT_BUFF_7_TITLE, STR_EVT_BUFF_7_DESC.format(EVT_7_BASE_HEALTH, EVT_7_HEALTH_PERCENT * 100, EVT_7_REGEN_INTERVAL), EVT_BUFF_7_DURATION, EVT_BUFF_7_WEIGHT]
    buffEventId.append(BuffEventId.FLESH_REGEN)
    lbl_6:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_BUFF, STR_EVT_BUFF_8_TITLE, true, BuffEventId.HEART_OF_STEEL):
        goto lbl_7
    buffEvent[BuffEventId.HEART_OF_STEEL] = [STR_EVT_BUFF_8_TITLE, STR_EVT_BUFF_8_DESC.format(EVT_8_HP_LAYER_PER_DEATH, EVT_8_HP_PERCENT_PER_STACK), EVT_BUFF_8_DURATION, EVT_BUFF_8_WEIGHT]
    buffEventId.append(BuffEventId.HEART_OF_STEEL)
    lbl_7:

    # ================================================
    # Pack 2: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_9_TITLE, true, BuffEventId.DEATH_DELAY):
        goto lbl_10
    buffEvent[BuffEventId.DEATH_DELAY] = [STR_EVT_BUFF_9_TITLE, STR_EVT_BUFF_9_DESC, EVT_BUFF_9_DURATION, EVT_BUFF_9_WEIGHT]
    buffEventId.append(BuffEventId.DEATH_DELAY)
    lbl_10:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_10_TITLE, true, BuffEventId.SYMBIOSIS):
        goto lbl_11
    buffEvent[BuffEventId.SYMBIOSIS] = [STR_EVT_BUFF_10_TITLE, STR_EVT_BUFF_10_DESC.format(Button.INTERACT), EVT_BUFF_10_DURATION, EVT_BUFF_10_WEIGHT]
    buffEventId.append(BuffEventId.SYMBIOSIS)
    lbl_11:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_11_TITLE, true, BuffEventId.KONAMI_CODE):
        goto lbl_12
    buffEvent[BuffEventId.KONAMI_CODE] = [STR_EVT_BUFF_11_TITLE, STR_EVT_BUFF_11_DESC.format(EVT_11_CHECKPOINT_INTERVAL), EVT_BUFF_11_DURATION, EVT_BUFF_11_WEIGHT]
    buffEventId.append(BuffEventId.KONAMI_CODE)
    lbl_12:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_BUFF, STR_EVT_BUFF_12_TITLE, true, BuffEventId.PHOTON_SHIELD):
        goto lbl_13
    buffEvent[BuffEventId.PHOTON_SHIELD] = [STR_EVT_BUFF_12_TITLE, STR_EVT_BUFF_12_DESC.format(EVT_12_SHIELD_PERCENT * 100), EVT_BUFF_12_DURATION, EVT_BUFF_12_WEIGHT]
    buffEventId.append(BuffEventId.PHOTON_SHIELD)
    lbl_13:

    # ================================================
    # Pack 3: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_13_TITLE, true, BuffEventId.REGROUP_CALL):
        goto lbl_15
    buffEvent[BuffEventId.REGROUP_CALL] = [STR_EVT_BUFF_13_TITLE, STR_EVT_BUFF_13_DESC.format(EVT_13_CHECK_INTERVAL, EVT_13_INVINCIBLE_DURATION), EVT_BUFF_13_DURATION, EVT_BUFF_13_WEIGHT]
    buffEventId.append(BuffEventId.REGROUP_CALL)
    lbl_15:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_14_TITLE, true, BuffEventId.WILL_TO_WIN):
        goto lbl_18
    buffEvent[BuffEventId.WILL_TO_WIN] = [STR_EVT_BUFF_14_TITLE, STR_EVT_BUFF_14_DESC.format(EVT_14_TRIGGER_HP_PERCENT * 100, EVT_14_INVINCIBLE_DURATION), EVT_BUFF_14_DURATION, EVT_BUFF_14_WEIGHT]
    buffEventId.append(BuffEventId.WILL_TO_WIN)
    lbl_18:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_15_TITLE, true, BuffEventId.PHEIDIPPIDES_TRIAL):
        goto lbl_19
    buffEvent[BuffEventId.PHEIDIPPIDES_TRIAL] = [STR_EVT_BUFF_15_TITLE, STR_EVT_BUFF_15_DESC.format(EVT_15_DISTANCE_GOAL, EVT_15_REWARD_SPEED), EVT_BUFF_15_DURATION, EVT_BUFF_15_WEIGHT]
    buffEventId.append(BuffEventId.PHEIDIPPIDES_TRIAL)
    lbl_19:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_16_TITLE, true, BuffEventId.HEART_OF_STEEL_PRO):
        goto lbl_20
    buffEvent[BuffEventId.HEART_OF_STEEL_PRO] = [STR_EVT_BUFF_16_TITLE, STR_EVT_BUFF_16_DESC.format(EVT_16_HP_GAIN_FLAT, EVT_16_HP_MULTIPLIER), EVT_BUFF_16_DURATION, EVT_BUFF_16_WEIGHT]
    buffEventId.append(BuffEventId.HEART_OF_STEEL_PRO)
    lbl_20:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_17_TITLE, true, BuffEventId.STAT_POWER):
        goto lbl_21
    buffEvent[BuffEventId.STAT_POWER] = [STR_EVT_BUFF_17_TITLE, STR_EVT_BUFF_17_DESC.format(EVT_17_HEAL_BOOST), EVT_BUFF_17_DURATION, EVT_BUFF_17_WEIGHT]
    buffEventId.append(BuffEventId.STAT_POWER)
    lbl_21:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_BUFF, STR_EVT_BUFF_18_TITLE, true, BuffEventId.ULT_MOMENTUM):
        goto lbl_22
    buffEvent[BuffEventId.ULT_MOMENTUM] = [STR_EVT_BUFF_18_TITLE, STR_EVT_BUFF_18_DESC.format(EVT_18_DMG_REDUCTION_DURING_ULT), EVT_BUFF_18_DURATION, EVT_BUFF_18_WEIGHT]
    buffEventId.append(BuffEventId.ULT_MOMENTUM)
    lbl_22:
    
    # ================================================
    # Pack 4: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_19_TITLE, true, BuffEventId.PHASE_SURGE):
        goto lbl_101
    buffEvent[BuffEventId.PHASE_SURGE] = [STR_EVT_BUFF_19_TITLE, STR_EVT_BUFF_19_DESC.format(EVT_19_SPEED_BOOST), EVT_BUFF_19_DURATION, EVT_BUFF_19_WEIGHT]
    buffEventId.append(BuffEventId.PHASE_SURGE)
    lbl_101:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_20_TITLE, true, BuffEventId.BODYGUARD):
        goto lbl_102
    buffEvent[BuffEventId.BODYGUARD] = [STR_EVT_BUFF_20_TITLE, STR_EVT_BUFF_20_DESC, EVT_BUFF_20_DURATION, EVT_BUFF_20_WEIGHT]
    buffEventId.append(BuffEventId.BODYGUARD)
    lbl_102:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_21_TITLE, true, BuffEventId.MARTYR_TRIAL):
        goto lbl_103
    buffEvent[BuffEventId.MARTYR_TRIAL] = [STR_EVT_BUFF_21_TITLE, STR_EVT_BUFF_21_DESC.format(negToPos(EVT_21_REWARD_DMG_PERMA)), EVT_BUFF_21_DURATION, EVT_BUFF_21_WEIGHT]
    buffEventId.append(BuffEventId.MARTYR_TRIAL)
    lbl_103:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_22_TITLE, true, BuffEventId.HYPERACTIVE_HEAL):
        goto lbl_104
    buffEvent[BuffEventId.HYPERACTIVE_HEAL] = [STR_EVT_BUFF_22_TITLE, STR_EVT_BUFF_22_DESC.format(EVT_22_HOT_FLAT, percent(EVT_22_HOT_MAXHP_FACTOR)), EVT_BUFF_22_DURATION, EVT_BUFF_22_WEIGHT]
    buffEventId.append(BuffEventId.HYPERACTIVE_HEAL)
    lbl_104:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_23_TITLE, true, BuffEventId.MORALE_BOOST_PROMAX):
        goto lbl_105
    buffEvent[BuffEventId.MORALE_BOOST_PROMAX] = [STR_EVT_BUFF_23_TITLE, STR_EVT_BUFF_23_DESC.format(EVT_23_HEAL_RADIUS, EVT_23_HOT_FLAT, percent(EVT_23_HOT_MAXHP_FACTOR)), EVT_BUFF_23_DURATION, EVT_BUFF_23_WEIGHT]
    buffEventId.append(BuffEventId.MORALE_BOOST_PROMAX)
    lbl_105:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_24_TITLE, true, BuffEventId.F5_REFRESH):
        goto lbl_106
    buffEvent[BuffEventId.F5_REFRESH] = [STR_EVT_BUFF_24_TITLE, STR_EVT_BUFF_24_DESC.format(EVT_24_REFRESH_INTERVAL), EVT_BUFF_24_DURATION, EVT_BUFF_24_WEIGHT]
    buffEventId.append(BuffEventId.F5_REFRESH)
    lbl_106:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_25_TITLE, true, BuffEventId.HEALING_TOWER_PROMAX):
        goto lbl_107
    buffEvent[BuffEventId.HEALING_TOWER_PROMAX] = [STR_EVT_BUFF_25_TITLE, STR_EVT_BUFF_25_DESC.format(EVT_25_HEAL_FLAT, percent(EVT_25_HEAL_MAXHP_FACTOR)), EVT_BUFF_25_DURATION, EVT_BUFF_25_WEIGHT]
    buffEventId.append(BuffEventId.HEALING_TOWER_PROMAX)
    lbl_107:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_26_TITLE, true, BuffEventId.SUPER_TRANSFORM):
        goto lbl_32
    buffEvent[BuffEventId.SUPER_TRANSFORM] = [STR_EVT_BUFF_26_TITLE, STR_EVT_BUFF_26_DESC.format(EVT_26_HP_FLAT, percent(EVT_26_HP_MAXHP_FACTOR), EVT_26_OVERHEALTH_DURATION), EVT_BUFF_26_DURATION, EVT_BUFF_26_WEIGHT]
    buffEventId.append(BuffEventId.SUPER_TRANSFORM)
    lbl_32:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_27_TITLE, true, BuffEventId.DRAW_FIRE):
        goto lbl_108
    buffEvent[BuffEventId.DRAW_FIRE] = [STR_EVT_BUFF_27_TITLE, STR_EVT_BUFF_27_DESC.format(EVT_27_ARMOR_AMOUNT, negToPos(EVT_27_DMG_TAKEN)), EVT_BUFF_27_DURATION, EVT_BUFF_27_WEIGHT]
    buffEventId.append(BuffEventId.DRAW_FIRE)
    lbl_108:

    lbl_109:
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_BUFF, STR_EVT_BUFF_29_TITLE, true, BuffEventId.MAGIC_MASTER):
        goto lbl_33
    buffEvent[BuffEventId.MAGIC_MASTER] = [STR_EVT_BUFF_29_TITLE, STR_EVT_BUFF_29_DESC.format(EVT_29_SPEED_BOOST), EVT_BUFF_29_DURATION, EVT_BUFF_29_WEIGHT]
    buffEventId.append(BuffEventId.MAGIC_MASTER)
    lbl_33:
    
    # ================================================
    # 减益事件 (Debuff Events)
    # ================================================
    debuffEvent = []
    debuffEventId = []
    
    # ================================================
    # Pack 1: Debuffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_0_TITLE, true, DebuffEventId.GRAVITY_ANOMALY):
        goto lbl_33
    debuffEvent[DebuffEventId.GRAVITY_ANOMALY] = [
        STR_EVT_DEBUFF_0_TITLE,
        STR_EVT_DEBUFF_0_DESC.format(negToPos(EVT_DEBUFF_0_SPEED), EVT_DEBUFF_0_GRAVITY),
        EVT_DEBUFF_0_DURATION,
        EVT_DEBUFF_0_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRAVITY_ANOMALY)
    lbl_33:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_1_TITLE, true, DebuffEventId.EMP):
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

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_2_TITLE, true, DebuffEventId.SACRIFICE):
        goto lbl_35
    debuffEvent[DebuffEventId.SACRIFICE] = [
        STR_EVT_DEBUFF_2_TITLE,
        STR_EVT_DEBUFF_2_DESC.format(percent(EVT_DEBUFF_2_DMG_PERCENT)),
        EVT_DEBUFF_2_DURATION,
        EVT_DEBUFF_2_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SACRIFICE)
    lbl_35:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_3_TITLE, true, DebuffEventId.VULNERABLE):
        goto lbl_36
    debuffEvent[DebuffEventId.VULNERABLE] = [
        STR_EVT_DEBUFF_3_TITLE,
        STR_EVT_DEBUFF_3_DESC.format(EVT_DEBUFF_3_DMG_TAKEN),
        EVT_DEBUFF_3_DURATION,
        EVT_DEBUFF_3_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.VULNERABLE)
    lbl_36:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_DEBUFF, STR_EVT_DEBUFF_4_TITLE, true, DebuffEventId.SPEED_LIMIT_40):
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
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_5_TITLE, true, DebuffEventId.GRAVITY_PULL):
        goto lbl_38
    debuffEvent[DebuffEventId.GRAVITY_PULL] = [
        STR_EVT_DEBUFF_5_TITLE,
        STR_EVT_DEBUFF_5_DESC.format(EVT_DEBUFF_5_SPEED_REDUCTION),
        EVT_DEBUFF_5_DURATION,
        EVT_DEBUFF_5_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRAVITY_PULL)
    lbl_38:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_6_TITLE, true, DebuffEventId.OSTEOPOROSIS):
        goto lbl_39
    debuffEvent[DebuffEventId.OSTEOPOROSIS] = [
        STR_EVT_DEBUFF_6_TITLE,
        STR_EVT_DEBUFF_6_DESC.format(negToPos(EVT_DEBUFF_6_MAX_SPEED_DEC)),
        EVT_DEBUFF_6_DURATION,
        EVT_DEBUFF_6_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.OSTEOPOROSIS)
    lbl_39:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_7_TITLE, true, DebuffEventId.EMP_PROMAX):
        goto lbl_40
    debuffEvent[DebuffEventId.EMP_PROMAX] = [
        STR_EVT_DEBUFF_7_TITLE,
        STR_EVT_DEBUFF_7_DESC.format(EVT_DEBUFF_7_RADIUS),
        EVT_DEBUFF_7_DURATION,
        EVT_DEBUFF_7_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.EMP_PROMAX)
    lbl_40:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_8_TITLE, true, DebuffEventId.ENERGY_LEAK):
        goto lbl_41
    debuffEvent[DebuffEventId.ENERGY_LEAK] = [
        STR_EVT_DEBUFF_8_TITLE,
        STR_EVT_DEBUFF_8_DESC.format(percent(EVT_DEBUFF_8_DMG_PERCENT)),
        EVT_DEBUFF_8_DURATION,
        EVT_DEBUFF_8_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.ENERGY_LEAK)
    lbl_41:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_9_TITLE, true, DebuffEventId.SHARE_THE_PAIN):
        goto lbl_43
    debuffEvent[DebuffEventId.SHARE_THE_PAIN] = [
        STR_EVT_DEBUFF_9_TITLE,
        STR_EVT_DEBUFF_9_DESC.format(percent(EVT_DEBUFF_9_DMG_FACTOR), EVT_DEBUFF_9_RADIUS),
        EVT_DEBUFF_9_DURATION,
        EVT_DEBUFF_9_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SHARE_THE_PAIN)
    lbl_43:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_10_TITLE, true, DebuffEventId.FEAST_FRENZY):
        goto lbl_44
    debuffEvent[DebuffEventId.FEAST_FRENZY] = [
        STR_EVT_DEBUFF_10_TITLE,
        STR_EVT_DEBUFF_10_DESC.format(EVT_DEBUFF_10_BERSERK_ADD),
        EVT_DEBUFF_10_DURATION,
        EVT_DEBUFF_10_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.FEAST_FRENZY)
    lbl_44:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_DEBUFF, STR_EVT_DEBUFF_11_TITLE, true, DebuffEventId.POWERLESS_SPOUSE):
        goto lbl_45
    debuffEvent[DebuffEventId.POWERLESS_SPOUSE] = [
        STR_EVT_DEBUFF_11_TITLE,
        STR_EVT_DEBUFF_11_DESC.format(EVT_DEBUFF_11_KNOCKDOWN_DURATION),
        EVT_DEBUFF_11_DURATION,
        EVT_DEBUFF_11_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.POWERLESS_SPOUSE)
    lbl_45:

    # ================================================
    # Pack 3: Debuffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_12_TITLE, true, DebuffEventId.GRIEVOUS_WOUNDS):
        goto lbl_46
    debuffEvent[DebuffEventId.GRIEVOUS_WOUNDS] = [
        STR_EVT_DEBUFF_12_TITLE,
        STR_EVT_DEBUFF_12_DESC.format(negToPos(EVT_DEBUFF_12_HEAL_DEALT_RED)),
        EVT_DEBUFF_12_DURATION,
        EVT_DEBUFF_12_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRIEVOUS_WOUNDS)
    lbl_46:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_13_TITLE, true, DebuffEventId.HALVED):
        goto lbl_47
    debuffEvent[DebuffEventId.HALVED] = [
        STR_EVT_DEBUFF_13_TITLE,
        STR_EVT_DEBUFF_13_DESC.format(EVT_DEBUFF_13_INTERVAL, percent(EVT_DEBUFF_13_DAMAGE_PERCENT), percent(EVT_DEBUFF_13_EXECUTE_THRESHOLD)),
        EVT_DEBUFF_13_DURATION,
        EVT_DEBUFF_13_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.HALVED)
    lbl_47:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_DEBUFF, STR_EVT_DEBUFF_14_TITLE, true, DebuffEventId.SELFLESS_GIVEAWAY):
        goto lbl_48
    debuffEvent[DebuffEventId.SELFLESS_GIVEAWAY] = [
        STR_EVT_DEBUFF_14_TITLE,
        STR_EVT_DEBUFF_14_DESC.format(EVT_DEBUFF_14_STACKS_TAKE),
        EVT_DEBUFF_14_DURATION,
        EVT_DEBUFF_14_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SELFLESS_GIVEAWAY)
    lbl_48:
    
    # ================================================
    # Pack 4: Debuffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_DEBUFF, STR_EVT_DEBUFF_15_TITLE, true, DebuffEventId.KEEP_DISTANCE_AURA):
        goto lbl_109
    debuffEvent[DebuffEventId.KEEP_DISTANCE_AURA] = [STR_EVT_DEBUFF_15_TITLE, STR_EVT_DEBUFF_15_DESC, EVT_DEBUFF_15_DURATION, EVT_DEBUFF_15_WEIGHT]
    debuffEventId.append(DebuffEventId.KEEP_DISTANCE_AURA)
    lbl_109:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_DEBUFF, STR_EVT_DEBUFF_16_TITLE, true, DebuffEventId.ERROR_404):
        goto lbl_110
    debuffEvent[DebuffEventId.ERROR_404] = [STR_EVT_DEBUFF_16_TITLE, STR_EVT_DEBUFF_16_DESC, EVT_DEBUFF_16_DURATION, EVT_DEBUFF_16_WEIGHT]
    debuffEventId.append(DebuffEventId.ERROR_404)
    lbl_110:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_DEBUFF, STR_EVT_DEBUFF_17_TITLE, true, DebuffEventId.CHAIN_OVERLOAD):
        goto lbl_111
    debuffEvent[DebuffEventId.CHAIN_OVERLOAD] = [STR_EVT_DEBUFF_17_TITLE, STR_EVT_DEBUFF_17_DESC, EVT_DEBUFF_17_DURATION, EVT_DEBUFF_17_WEIGHT]
    debuffEventId.append(DebuffEventId.CHAIN_OVERLOAD)
    lbl_111:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_DEBUFF, STR_EVT_DEBUFF_18_TITLE, true, DebuffEventId.HEALTH_SYNC):
        goto lbl_112
    debuffEvent[DebuffEventId.HEALTH_SYNC] = [STR_EVT_DEBUFF_18_TITLE, STR_EVT_DEBUFF_18_DESC, EVT_DEBUFF_18_DURATION, EVT_DEBUFF_18_WEIGHT]
    debuffEventId.append(DebuffEventId.HEALTH_SYNC)
    lbl_112:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_DEBUFF, STR_EVT_DEBUFF_19_TITLE, true, DebuffEventId.VAMPIRE):
        goto lbl_113
    debuffEvent[DebuffEventId.VAMPIRE] = [STR_EVT_DEBUFF_19_TITLE, STR_EVT_DEBUFF_19_DESC, EVT_DEBUFF_19_DURATION, EVT_DEBUFF_19_WEIGHT]
    debuffEventId.append(DebuffEventId.VAMPIRE)
    lbl_113:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_DEBUFF, STR_EVT_DEBUFF_20_TITLE, true, DebuffEventId.MOON_ROCKET):
        goto lbl_114
    debuffEvent[DebuffEventId.MOON_ROCKET] = [STR_EVT_DEBUFF_20_TITLE, STR_EVT_DEBUFF_20_DESC, EVT_DEBUFF_20_DURATION, EVT_DEBUFF_20_WEIGHT]
    debuffEventId.append(DebuffEventId.MOON_ROCKET)
    lbl_114:
    
    # ================================================
    # 机制事件 (Mech Events)
    # ================================================
    mechEvent = []
    mechEventId = []
    
    # ================================================
    # Pack 3: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_MECH, STR_EVT_MECH_0_TITLE, true, MechEventId.EXTREME_CHALLENGE):
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
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_1_TITLE, true, MechEventId.GAMBLER):
        goto lbl_57
    mechEvent[MechEventId.GAMBLER] = [STR_EVT_MECH_1_TITLE, STR_EVT_MECH_1_DESC.format(Button.RELOAD, EVT_MECH_1_WIN_RATE, EVT_MECH_1_STAKE), EVT_MECH_1_DURATION, EVT_MECH_1_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER)
    lbl_57:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_2_TITLE, true, MechEventId.MINI_FORM):
        goto lbl_59
    mechEvent[MechEventId.MINI_FORM] = [STR_EVT_MECH_2_TITLE, STR_EVT_MECH_2_DESC.format(percent(1 - EVT_MECH_2_MODEL_SCALE), percent(1 - EVT_MECH_2_HP_SCALE), EVT_MECH_2_SPEED_BOOST), EVT_MECH_2_DURATION, EVT_MECH_2_WEIGHT]
    mechEventId.append(MechEventId.MINI_FORM)
    lbl_59:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_1_MECH, STR_EVT_MECH_3_TITLE, true, MechEventId.STEALTH_CROUCH):
        goto lbl_60
    mechEvent[MechEventId.STEALTH_CROUCH] = [STR_EVT_MECH_3_TITLE, STR_EVT_MECH_3_DESC.format(EVT_MECH_3_SPEED_PENALTY), EVT_MECH_3_DURATION, EVT_MECH_3_WEIGHT]
    mechEventId.append(MechEventId.STEALTH_CROUCH)
    lbl_60:

    # ================================================
    # Pack 2: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_2_MECH, STR_EVT_MECH_4_TITLE, true, MechEventId.BRAKE_FAILURE):
        goto lbl_62
    mechEvent[MechEventId.BRAKE_FAILURE] = [STR_EVT_MECH_4_TITLE, STR_EVT_MECH_4_DESC.format(100 + EVT_MECH_4_MAX_SPEED), EVT_MECH_4_DURATION, EVT_MECH_4_WEIGHT]
    mechEventId.append(MechEventId.BRAKE_FAILURE)
    lbl_62:

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_MECH, STR_EVT_MECH_5_TITLE, true, MechEventId.JUMP_THRUST):
        goto lbl_67
    mechEvent[MechEventId.JUMP_THRUST] = [
        STR_EVT_MECH_5_TITLE,
        STR_EVT_MECH_5_DESC.format(Button.JUMP, negToPos(EVT_MECH_5_DMG_TAKEN)),
        EVT_MECH_5_DURATION,
        EVT_MECH_5_WEIGHT
    ]
    mechEventId.append(MechEventId.JUMP_THRUST)
    lbl_67:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_3_MECH, STR_EVT_MECH_6_TITLE, true, MechEventId.GAMBLER_SPEED_CHALLENGE):
        goto lbl_68
    mechEvent[MechEventId.GAMBLER_SPEED_CHALLENGE] = [
        STR_EVT_MECH_6_TITLE,
        STR_EVT_MECH_6_DESC.format(Button.RELOAD, percent(EVT_MECH_6_HP_PENALTY), EVT_MECH_6_PROB_LOSE_NORMAL - EVT_MECH_6_PROB_WIN_NORMAL, EVT_MECH_6_VAL_NORMAL, 100 - EVT_MECH_6_PROB_LOSE_NORMAL, EVT_MECH_6_VAL_RARE),
        EVT_MECH_6_DURATION,
        EVT_MECH_6_WEIGHT
    ]
    mechEventId.append(MechEventId.GAMBLER_SPEED_CHALLENGE)
    lbl_68:

    # ================================================
    # Pack 4: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_7_TITLE, true, MechEventId.CHEAT_CARD_COUNTING):
        goto lbl_115
    mechEvent[MechEventId.CHEAT_CARD_COUNTING] = [STR_EVT_MECH_7_TITLE, STR_EVT_MECH_7_DESC.format(Button.RELOAD, EVT_MECH_7_HEART_STEEL_COST, EVT_MECH_7_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK), EVT_MECH_7_DURATION, EVT_MECH_7_WEIGHT]
    mechEventId.append(MechEventId.CHEAT_CARD_COUNTING)
    lbl_115:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_8_TITLE, true, MechEventId.GAMBLER_SHORT_INVESTMENT):
        goto lbl_116
    mechEvent[MechEventId.GAMBLER_SHORT_INVESTMENT] = [STR_EVT_MECH_8_TITLE, STR_EVT_MECH_8_DESC.format(Button.RELOAD, EVT_MECH_8_CONTRACT_EVENTS, EVT_MECH_8_WIN_CHANCE, EVT_MECH_8_REWARD_STACKS), EVT_MECH_8_DURATION, EVT_MECH_8_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_SHORT_INVESTMENT)
    lbl_116:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_9_TITLE, true, MechEventId.FATE_SYNC):
        goto lbl_117
    mechEvent[MechEventId.FATE_SYNC] = [STR_EVT_MECH_9_TITLE, STR_EVT_MECH_9_DESC, EVT_MECH_9_DURATION, EVT_MECH_9_WEIGHT]
    mechEventId.append(MechEventId.FATE_SYNC)
    lbl_117:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_10_TITLE, true, MechEventId.CHEAT_SKIP_HERO):
        goto lbl_118
    mechEvent[MechEventId.CHEAT_SKIP_HERO] = [STR_EVT_MECH_10_TITLE, STR_EVT_MECH_10_DESC.format(Button.RELOAD), EVT_MECH_10_DURATION, EVT_MECH_10_WEIGHT]
    mechEventId.append(MechEventId.CHEAT_SKIP_HERO)
    lbl_118:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_11_TITLE, true, MechEventId.NESTING_DOLL):
        goto lbl_119
    mechEvent[MechEventId.NESTING_DOLL] = [STR_EVT_MECH_11_TITLE, STR_EVT_MECH_11_DESC.format(EVT_MECH_11_RESURRECT_DELAY, percent(EVT_MECH_11_SIZE_STEP), EVT_MECH_11_SPEED_STEP), EVT_MECH_11_DURATION, EVT_MECH_11_WEIGHT]
    mechEventId.append(MechEventId.NESTING_DOLL)
    lbl_119:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_12_TITLE, true, MechEventId.GAMBLER_LONG_INVESTMENT):
        goto lbl_120
    mechEvent[MechEventId.GAMBLER_LONG_INVESTMENT] = [STR_EVT_MECH_12_TITLE, STR_EVT_MECH_12_DESC.format(Button.RELOAD, EVT_MECH_12_CONTRACT_EVENTS, EVT_MECH_12_WIN_CHANCE, EVT_MECH_12_REWARD_STACKS), EVT_MECH_12_DURATION, EVT_MECH_12_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_LONG_INVESTMENT)
    lbl_120:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_13_TITLE, true, MechEventId.VALKYRIE_DESCENT):
        goto lbl_121
    mechEvent[MechEventId.VALKYRIE_DESCENT] = [STR_EVT_MECH_13_TITLE, STR_EVT_MECH_13_DESC.format(EVT_MECH_13_SIZE_HEALTH * 100, percent(EVT_MECH_13_HEAL_SMOOTHING)), EVT_MECH_13_DURATION, EVT_MECH_13_WEIGHT]
    mechEventId.append(MechEventId.VALKYRIE_DESCENT)
    lbl_121:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_4_MECH, STR_EVT_MECH_14_TITLE, true, MechEventId.TRINITY_SSR):
        goto lbl_122
    mechEvent[MechEventId.TRINITY_SSR] = [STR_EVT_MECH_14_TITLE, STR_EVT_MECH_14_DESC.format(100 / EVT_MECH_14_DMG_REDUCE_DIVISOR, EVT_MECH_14_SPEED_FACTOR, EVT_MECH_14_INTERVAL / EVT_MECH_14_HEART_STEEL_PER_TICK), EVT_MECH_14_DURATION, EVT_MECH_14_WEIGHT]
    mechEventId.append(MechEventId.TRINITY_SSR)
    lbl_122:

    # ================================================
    # Pack 5: Mechanics
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK_5_MECH, STR_EVT_MECH_15_TITLE, true, MechEventId.GAMBLER_DICE_MANIAC):
        goto lbl_123
    mechEvent[MechEventId.GAMBLER_DICE_MANIAC] = [STR_EVT_MECH_15_TITLE, STR_EVT_MECH_15_DESC.format(EVT_MECH_15_DURATION, Button.RELOAD, EVT_MECH_15_HOLD_TIME, EVT_MECH_15_HEART_STEEL_DELTA, EVT_MECH_15_SPEED_DELTA, EVT_MECH_15_DMG_HEAL_DELTA), EVT_MECH_15_DURATION, EVT_MECH_15_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_DICE_MANIAC)
    lbl_123:
