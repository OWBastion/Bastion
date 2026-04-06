#!mainFile "../main.opy"

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

    # ================================================
    # 减益事件 (Debuff Events)
    # ================================================
    debuffEvent = []
    debuffEventId = []

    # ================================================
    # 机制事件 (Mech Events)
    # ================================================
    mechEvent = []
    mechEventId = []
    
    # Pack 0 - Special
    buffEvent[BuffEventId.OLIVIA_GIFT] = [STR_EVT_BUFF_0_TITLE, STR_EVT_BUFF_0_DESC, EVT_BUFF_0_DURATION, EVT_BUFF_0_WEIGHT]
    buffEventId.append(BuffEventId.OLIVIA_GIFT)
    
    # ================================================
    # Pack 1: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_1, true, 1):
        goto lbl_0
    buffEvent[BuffEventId.GALE_BLESSING] = [STR_EVT_BUFF_1_TITLE, STR_EVT_BUFF_1_DESC.format(EVT_1_SPEED_BOOST), EVT_BUFF_1_DURATION, EVT_BUFF_1_WEIGHT]
    buffEventId.append(BuffEventId.GALE_BLESSING)
    
    buffEvent[BuffEventId.IRON_BULWARK] = [STR_EVT_BUFF_2_TITLE, STR_EVT_BUFF_2_DESC.format(EVT_2_ARMOR_AMOUNT, negToPos(EVT_2_DMG_TAKEN)), EVT_BUFF_2_DURATION, EVT_BUFF_2_WEIGHT]
    buffEventId.append(BuffEventId.IRON_BULWARK)
    
    buffEvent[BuffEventId.ADRENALINE] = [STR_EVT_BUFF_3_TITLE, STR_EVT_BUFF_3_DESC.format(negToPos(EVT_3_DMG_TAKEN), EVT_3_HEAL_BOOST), EVT_BUFF_3_DURATION, EVT_BUFF_3_WEIGHT]
    buffEventId.append(BuffEventId.ADRENALINE)
    
    buffEvent[BuffEventId.LIFE_SPRING] = [STR_EVT_BUFF_4_TITLE, STR_EVT_BUFF_4_DESC.format(percent(EVT_4_HEAL_PERCENT)), EVT_BUFF_4_DURATION, EVT_BUFF_4_WEIGHT]
    buffEventId.append(BuffEventId.LIFE_SPRING)
    
    buffEvent[BuffEventId.BLACK_FANS_ASSAULT] = [STR_EVT_BUFF_5_TITLE, STR_EVT_BUFF_5_DESC.format(EVT_5_HEALTH_FLAT, percent(EVT_5_HEALTH_MAXHP_FACTOR), EVT_5_SPEED_BOOST), EVT_BUFF_5_DURATION, EVT_BUFF_5_WEIGHT]
    buffEventId.append(BuffEventId.BLACK_FANS_ASSAULT)
    
    buffEvent[BuffEventId.SPEED_STACK] = [STR_EVT_BUFF_6_TITLE, STR_EVT_BUFF_6_DESC.format(EVT_6_SPEED_INC_PER_SEC), EVT_BUFF_6_DURATION, EVT_BUFF_6_WEIGHT]
    buffEventId.append(BuffEventId.SPEED_STACK)
    
    buffEvent[BuffEventId.FLESH_REGEN] = [STR_EVT_BUFF_7_TITLE, STR_EVT_BUFF_7_DESC.format(EVT_7_BASE_HEALTH, percent(EVT_7_HEALTH_PERCENT), EVT_7_REGEN_INTERVAL), EVT_BUFF_7_DURATION, EVT_BUFF_7_WEIGHT]
    buffEventId.append(BuffEventId.FLESH_REGEN)
    
    buffEvent[BuffEventId.HEART_OF_STEEL] = [STR_EVT_BUFF_8_TITLE, STR_EVT_BUFF_8_DESC.format(EVT_8_HP_LAYER_PER_DEATH, EVT_8_HP_PERCENT_PER_STACK), EVT_BUFF_8_DURATION, EVT_BUFF_8_WEIGHT]
    buffEventId.append(BuffEventId.HEART_OF_STEEL)

    # ================================================
    # Pack 1: Debuffs
    # ================================================

    debuffEvent[DebuffEventId.GRAVITY_ANOMALY] = [
        STR_EVT_DEBUFF_0_TITLE,
        STR_EVT_DEBUFF_0_DESC.format(negToPos(EVT_DEBUFF_0_SPEED), EVT_DEBUFF_0_GRAVITY),
        EVT_DEBUFF_0_DURATION,
        EVT_DEBUFF_0_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRAVITY_ANOMALY)

    debuffEvent[DebuffEventId.EMP] = [STR_EVT_DEBUFF_1_TITLE, STR_EVT_DEBUFF_1_DESC, EVT_DEBUFF_1_HACK_DURATION, EVT_DEBUFF_1_WEIGHT]
    debuffEventId.append(DebuffEventId.EMP)

    debuffEvent[DebuffEventId.SACRIFICE] = [
        STR_EVT_DEBUFF_2_TITLE,
        STR_EVT_DEBUFF_2_DESC.format(percent(EVT_DEBUFF_2_DMG_PERCENT)),
        EVT_DEBUFF_2_DURATION,
        EVT_DEBUFF_2_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SACRIFICE)

    debuffEvent[DebuffEventId.VULNERABLE] = [
        STR_EVT_DEBUFF_3_TITLE,
        STR_EVT_DEBUFF_3_DESC.format(EVT_DEBUFF_3_DMG_TAKEN),
        EVT_DEBUFF_3_DURATION,
        EVT_DEBUFF_3_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.VULNERABLE)

    debuffEvent[DebuffEventId.SPEED_LIMIT_40] = [
        STR_EVT_DEBUFF_4_TITLE,
        STR_EVT_DEBUFF_4_DESC.format(EVT_DEBUFF_4_DMG_BASE, percent(EVT_DEBUFF_4_DMG_PERCENT)),
        EVT_DEBUFF_4_DURATION,
        EVT_DEBUFF_4_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SPEED_LIMIT_40)


    # ================================================
    # Pack 1: Mechanics
    # ================================================

    mechEvent[MechEventId.GAMBLER] = [
        STR_EVT_MECH_1_TITLE,
        STR_EVT_MECH_1_DESC.format(Button.RELOAD, EVT_MECH_1_WIN_RATE, EVT_MECH_1_STAKE),
        EVT_MECH_1_DURATION,
        EVT_MECH_1_WEIGHT
    ]
    mechEventId.append(MechEventId.GAMBLER)

    mechEvent[MechEventId.MINI_FORM] = [
        STR_EVT_MECH_2_TITLE,
        STR_EVT_MECH_2_DESC.format(percent(1 - EVT_MECH_2_MODEL_SCALE), percent(1 - EVT_MECH_2_HP_SCALE), EVT_MECH_2_SPEED_BOOST),
        EVT_MECH_2_DURATION,
        EVT_MECH_2_WEIGHT
    ]
    mechEventId.append(MechEventId.MINI_FORM)

    mechEvent[MechEventId.STEALTH_CROUCH] = [
        STR_EVT_MECH_3_TITLE,
        STR_EVT_MECH_3_DESC.format(EVT_MECH_3_SPEED_PENALTY),
        EVT_MECH_3_DURATION,
        EVT_MECH_3_WEIGHT
    ]
    mechEventId.append(MechEventId.STEALTH_CROUCH)

    lbl_0:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_2, true, 1):
        goto lbl_1

    # ================================================
    # Pack 2: Buffs
    # ================================================

    buffEvent[BuffEventId.DEATH_DELAY] = [STR_EVT_BUFF_9_TITLE, STR_EVT_BUFF_9_DESC, EVT_BUFF_9_DURATION, EVT_BUFF_9_WEIGHT]
    buffEventId.append(BuffEventId.DEATH_DELAY)

    buffEvent[BuffEventId.SYMBIOSIS] = [STR_EVT_BUFF_10_TITLE, STR_EVT_BUFF_10_DESC.format(Button.INTERACT), EVT_BUFF_10_DURATION, EVT_BUFF_10_WEIGHT]
    buffEventId.append(BuffEventId.SYMBIOSIS)

    buffEvent[BuffEventId.KONAMI_CODE] = [STR_EVT_BUFF_11_TITLE, STR_EVT_BUFF_11_DESC.format(EVT_11_CHECKPOINT_INTERVAL), EVT_BUFF_11_DURATION, EVT_BUFF_11_WEIGHT]
    buffEventId.append(BuffEventId.KONAMI_CODE)

    buffEvent[BuffEventId.PHOTON_SHIELD] = [STR_EVT_BUFF_12_TITLE, STR_EVT_BUFF_12_DESC.format(percent(EVT_12_SHIELD_PERCENT)), EVT_BUFF_12_DURATION, EVT_BUFF_12_WEIGHT]
    buffEventId.append(BuffEventId.PHOTON_SHIELD)


    # ================================================
    # Pack 2: Debuffs
    # ================================================

    debuffEvent[DebuffEventId.GRAVITY_PULL] = [STR_EVT_DEBUFF_5_TITLE, STR_EVT_DEBUFF_5_DESC.format(EVT_DEBUFF_5_SPEED_REDUCTION), EVT_DEBUFF_5_DURATION, EVT_DEBUFF_5_WEIGHT]
    debuffEventId.append(DebuffEventId.GRAVITY_PULL)

    debuffEvent[DebuffEventId.OSTEOPOROSIS] = [STR_EVT_DEBUFF_6_TITLE, STR_EVT_DEBUFF_6_DESC.format(negToPos(EVT_DEBUFF_6_MAX_SPEED_DEC)), EVT_DEBUFF_6_DURATION, EVT_DEBUFF_6_WEIGHT]
    debuffEventId.append(DebuffEventId.OSTEOPOROSIS)

    debuffEvent[DebuffEventId.EMP_PROMAX] = [STR_EVT_DEBUFF_7_TITLE, STR_EVT_DEBUFF_7_DESC.format(EVT_DEBUFF_7_RADIUS), EVT_DEBUFF_7_DURATION, EVT_DEBUFF_7_WEIGHT]
    debuffEventId.append(DebuffEventId.EMP_PROMAX)

    debuffEvent[DebuffEventId.ENERGY_LEAK] = [STR_EVT_DEBUFF_8_TITLE, STR_EVT_DEBUFF_8_DESC.format(percent(EVT_DEBUFF_8_DMG_PERCENT)), EVT_DEBUFF_8_DURATION, EVT_DEBUFF_8_WEIGHT]
    debuffEventId.append(DebuffEventId.ENERGY_LEAK)

    debuffEvent[DebuffEventId.SHARE_THE_PAIN] = [STR_EVT_DEBUFF_9_TITLE, STR_EVT_DEBUFF_9_DESC.format(percent(EVT_DEBUFF_9_DMG_FACTOR), EVT_DEBUFF_9_RADIUS), EVT_DEBUFF_9_DURATION, EVT_DEBUFF_9_WEIGHT]
    debuffEventId.append(DebuffEventId.SHARE_THE_PAIN)

    debuffEvent[DebuffEventId.FEAST_FRENZY] = [STR_EVT_DEBUFF_10_TITLE, STR_EVT_DEBUFF_10_DESC.format(EVT_DEBUFF_10_BERSERK_ADD), EVT_DEBUFF_10_DURATION, EVT_DEBUFF_10_WEIGHT]
    debuffEventId.append(DebuffEventId.FEAST_FRENZY)

    debuffEvent[DebuffEventId.POWERLESS_SPOUSE] = [STR_EVT_DEBUFF_11_TITLE, STR_EVT_DEBUFF_11_DESC.format(EVT_DEBUFF_11_KNOCKDOWN_DURATION), EVT_DEBUFF_11_DURATION, EVT_DEBUFF_11_WEIGHT]
    debuffEventId.append(DebuffEventId.POWERLESS_SPOUSE)


    # ================================================
    # Pack 2: Mechanics
    # ================================================

    mechEvent[MechEventId.BRAKE_FAILURE] = [STR_EVT_MECH_4_TITLE, STR_EVT_MECH_4_DESC.format(100 + EVT_MECH_4_MAX_SPEED), EVT_MECH_4_DURATION, EVT_MECH_4_WEIGHT]
    mechEventId.append(MechEventId.BRAKE_FAILURE)

    
    lbl_1:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_3, true, 1):
        goto lbl_2
    
    # ================================================
    # Pack 3: Buffs
    # ================================================
    
    buffEvent[BuffEventId.REGROUP_CALL] = [STR_EVT_BUFF_13_TITLE, STR_EVT_BUFF_13_DESC.format(EVT_13_CHECK_INTERVAL, EVT_13_INVINCIBLE_DURATION), EVT_BUFF_13_DURATION, EVT_BUFF_13_WEIGHT]
    buffEventId.append(BuffEventId.REGROUP_CALL)
    
    buffEvent[BuffEventId.WILL_TO_WIN] = [STR_EVT_BUFF_14_TITLE, STR_EVT_BUFF_14_DESC.format(percent(EVT_14_TRIGGER_HP_PERCENT), EVT_14_INVINCIBLE_DURATION), EVT_BUFF_14_DURATION, EVT_BUFF_14_WEIGHT]
    buffEventId.append(BuffEventId.WILL_TO_WIN)
    
    buffEvent[BuffEventId.PHEIDIPPIDES_TRIAL] = [STR_EVT_BUFF_15_TITLE, STR_EVT_BUFF_15_DESC.format(EVT_15_DISTANCE_GOAL, EVT_15_REWARD_SPEED), EVT_BUFF_15_DURATION, EVT_BUFF_15_WEIGHT]
    buffEventId.append(BuffEventId.PHEIDIPPIDES_TRIAL)
    
    buffEvent[BuffEventId.HEART_OF_STEEL_PRO] = [STR_EVT_BUFF_16_TITLE, STR_EVT_BUFF_16_DESC.format(EVT_16_HP_GAIN_FLAT, EVT_16_HP_MULTIPLIER), EVT_BUFF_16_DURATION, EVT_BUFF_16_WEIGHT]
    buffEventId.append(BuffEventId.HEART_OF_STEEL_PRO)
    
    buffEvent[BuffEventId.STAT_POWER] = [STR_EVT_BUFF_17_TITLE, STR_EVT_BUFF_17_DESC.format(EVT_17_HEAL_BOOST), EVT_BUFF_17_DURATION, EVT_BUFF_17_WEIGHT]
    buffEventId.append(BuffEventId.STAT_POWER)
    
    buffEvent[BuffEventId.ULT_MOMENTUM] = [STR_EVT_BUFF_18_TITLE, STR_EVT_BUFF_18_DESC.format(EVT_18_DMG_REDUCTION_DURING_ULT), EVT_BUFF_18_DURATION, EVT_BUFF_18_WEIGHT]
    buffEventId.append(BuffEventId.ULT_MOMENTUM)
 
    # ================================================
    # Pack 3: Debuffs
    # ================================================

    debuffEvent[DebuffEventId.GRIEVOUS_WOUNDS] = [
        STR_EVT_DEBUFF_12_TITLE,
        STR_EVT_DEBUFF_12_DESC.format(negToPos(EVT_DEBUFF_12_HEAL_DEALT_RED)),
        EVT_DEBUFF_12_DURATION,
        EVT_DEBUFF_12_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.GRIEVOUS_WOUNDS)

    debuffEvent[DebuffEventId.HALVED] = [
        STR_EVT_DEBUFF_13_TITLE,
        STR_EVT_DEBUFF_13_DESC.format(EVT_DEBUFF_13_INTERVAL, percent(EVT_DEBUFF_13_DAMAGE_PERCENT), percent(EVT_DEBUFF_13_EXECUTE_THRESHOLD)),
        EVT_DEBUFF_13_DURATION,
        EVT_DEBUFF_13_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.HALVED)

    debuffEvent[DebuffEventId.SELFLESS_GIVEAWAY] = [
        STR_EVT_DEBUFF_14_TITLE,
        STR_EVT_DEBUFF_14_DESC.format(EVT_DEBUFF_14_STACKS_TAKE),
        EVT_DEBUFF_14_DURATION,
        EVT_DEBUFF_14_WEIGHT
    ]
    debuffEventId.append(DebuffEventId.SELFLESS_GIVEAWAY)


    # ================================================
    # Pack 3: Mechanics
    # ================================================

    mechEvent[MechEventId.EXTREME_CHALLENGE] = [
        STR_EVT_MECH_0_TITLE,
        STR_EVT_MECH_0_DESC.format(negToPos(EVT_MECH_0_DMG_TAKEN), percent(EVT_MECH_0_HP_PERCENT)),
        EVT_MECH_0_DURATION,
        EVT_MECH_0_WEIGHT
    ]
    mechEventId.append(MechEventId.EXTREME_CHALLENGE)

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    mechEvent[MechEventId.JUMP_THRUST] = [
        STR_EVT_MECH_5_TITLE,
        STR_EVT_MECH_5_DESC.format(Button.JUMP, negToPos(EVT_MECH_5_DMG_TAKEN)),
        EVT_MECH_5_DURATION,
        EVT_MECH_5_WEIGHT
    ]
    mechEventId.append(MechEventId.JUMP_THRUST)

    mechEvent[MechEventId.GAMBLER_SPEED_CHALLENGE] = [
        STR_EVT_MECH_6_TITLE,
        STR_EVT_MECH_6_DESC.format(Button.RELOAD, percent(EVT_MECH_6_HP_PENALTY), EVT_MECH_6_PROB_LOSE_NORMAL - EVT_MECH_6_PROB_WIN_NORMAL, EVT_MECH_6_VAL_NORMAL, 100 - EVT_MECH_6_PROB_LOSE_NORMAL, EVT_MECH_6_VAL_RARE),
        EVT_MECH_6_DURATION,
        EVT_MECH_6_WEIGHT
    ]
    mechEventId.append(MechEventId.GAMBLER_SPEED_CHALLENGE)

    
    lbl_2:
    
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_4, true, 1):
        goto lbl_3

    # ================================================
    # Pack 4: Buffs
    # ================================================
    buffEvent[BuffEventId.PHASE_SURGE] = [STR_EVT_BUFF_19_TITLE, STR_EVT_BUFF_19_DESC.format(EVT_19_SPEED_BOOST), EVT_BUFF_19_DURATION, EVT_BUFF_19_WEIGHT]
    buffEventId.append(BuffEventId.PHASE_SURGE)

    buffEvent[BuffEventId.BODYGUARD] = [STR_EVT_BUFF_20_TITLE, STR_EVT_BUFF_20_DESC, EVT_BUFF_20_DURATION, EVT_BUFF_20_WEIGHT]
    buffEventId.append(BuffEventId.BODYGUARD)

    buffEvent[BuffEventId.MARTYR_TRIAL] = [STR_EVT_BUFF_21_TITLE, STR_EVT_BUFF_21_DESC.format(negToPos(EVT_21_REWARD_DMG_PERMA)), EVT_BUFF_21_DURATION, EVT_BUFF_21_WEIGHT]
    buffEventId.append(BuffEventId.MARTYR_TRIAL)

    buffEvent[BuffEventId.HYPERACTIVE_HEAL] = [STR_EVT_BUFF_22_TITLE, STR_EVT_BUFF_22_DESC.format(EVT_22_HOT_FLAT, percent(EVT_22_HOT_MAXHP_FACTOR)), EVT_BUFF_22_DURATION, EVT_BUFF_22_WEIGHT]
    buffEventId.append(BuffEventId.HYPERACTIVE_HEAL)

    buffEvent[BuffEventId.MORALE_BOOST_PROMAX] = [STR_EVT_BUFF_23_TITLE, STR_EVT_BUFF_23_DESC.format(EVT_23_HEAL_RADIUS, EVT_23_HOT_FLAT, percent(EVT_23_HOT_MAXHP_FACTOR)), EVT_BUFF_23_DURATION, EVT_BUFF_23_WEIGHT]
    buffEventId.append(BuffEventId.MORALE_BOOST_PROMAX)

    buffEvent[BuffEventId.F5_REFRESH] = [STR_EVT_BUFF_24_TITLE, STR_EVT_BUFF_24_DESC.format(EVT_24_REFRESH_INTERVAL), EVT_BUFF_24_DURATION, EVT_BUFF_24_WEIGHT]
    buffEventId.append(BuffEventId.F5_REFRESH)

    buffEvent[BuffEventId.HEALING_TOWER_PROMAX] = [STR_EVT_BUFF_25_TITLE, STR_EVT_BUFF_25_DESC.format(EVT_25_HEAL_FLAT, percent(EVT_25_HEAL_MAXHP_FACTOR)), EVT_BUFF_25_DURATION, EVT_BUFF_25_WEIGHT]
    buffEventId.append(BuffEventId.HEALING_TOWER_PROMAX)

    buffEvent[BuffEventId.SUPER_TRANSFORM] = [STR_EVT_BUFF_26_TITLE, STR_EVT_BUFF_26_DESC.format(EVT_26_HP_FLAT, percent(EVT_26_HP_MAXHP_FACTOR), EVT_26_OVERHEALTH_DURATION), EVT_BUFF_26_DURATION, EVT_BUFF_26_WEIGHT]
    buffEventId.append(BuffEventId.SUPER_TRANSFORM)

    buffEvent[BuffEventId.DRAW_FIRE] = [STR_EVT_BUFF_27_TITLE, STR_EVT_BUFF_27_DESC.format(EVT_27_ARMOR_AMOUNT, negToPos(EVT_27_DMG_TAKEN)), EVT_BUFF_27_DURATION, EVT_BUFF_27_WEIGHT]
    buffEventId.append(BuffEventId.DRAW_FIRE)

    buffEvent[BuffEventId.MAGIC_MASTER] = [STR_EVT_BUFF_29_TITLE, STR_EVT_BUFF_29_DESC.format(EVT_29_SPEED_BOOST), EVT_BUFF_29_DURATION, EVT_BUFF_29_WEIGHT]
    buffEventId.append(BuffEventId.MAGIC_MASTER)
    
    buffEvent[BuffEventId.GAMBLER_HEART_OF_STEEL] = [STR_EVT_BUFF_30_TITLE, STR_EVT_BUFF_30_DESC.format(Button.RELOAD, EVT_30_WIN_RATE, EVT_30_WIN_MULTIPLIER, 100 - EVT_30_WIN_RATE, percent(EVT_30_LOSE_RATIO)), EVT_BUFF_30_DURATION, EVT_BUFF_30_WEIGHT]
    buffEventId.append(BuffEventId.GAMBLER_HEART_OF_STEEL)

    # ================================================
    # Pack 4: Debuffs
    # ================================================
    debuffEvent[DebuffEventId.KEEP_DISTANCE_AURA] = [STR_EVT_DEBUFF_15_TITLE, STR_EVT_DEBUFF_15_DESC, EVT_DEBUFF_15_DURATION, EVT_DEBUFF_15_WEIGHT]
    debuffEventId.append(DebuffEventId.KEEP_DISTANCE_AURA)

    debuffEvent[DebuffEventId.ERROR_404] = [STR_EVT_DEBUFF_16_TITLE, STR_EVT_DEBUFF_16_DESC, EVT_DEBUFF_16_DURATION, EVT_DEBUFF_16_WEIGHT]
    debuffEventId.append(DebuffEventId.ERROR_404)

    debuffEvent[DebuffEventId.CHAIN_OVERLOAD] = [STR_EVT_DEBUFF_17_TITLE, STR_EVT_DEBUFF_17_DESC, EVT_DEBUFF_17_DURATION, EVT_DEBUFF_17_WEIGHT]
    debuffEventId.append(DebuffEventId.CHAIN_OVERLOAD)

    debuffEvent[DebuffEventId.HEALTH_SYNC] = [STR_EVT_DEBUFF_18_TITLE, STR_EVT_DEBUFF_18_DESC, EVT_DEBUFF_18_DURATION, EVT_DEBUFF_18_WEIGHT]
    debuffEventId.append(DebuffEventId.HEALTH_SYNC)

    debuffEvent[DebuffEventId.VAMPIRE] = [STR_EVT_DEBUFF_19_TITLE, STR_EVT_DEBUFF_19_DESC, EVT_DEBUFF_19_DURATION, EVT_DEBUFF_19_WEIGHT]
    debuffEventId.append(DebuffEventId.VAMPIRE)

    debuffEvent[DebuffEventId.MOON_ROCKET] = [STR_EVT_DEBUFF_20_TITLE, STR_EVT_DEBUFF_20_DESC, EVT_DEBUFF_20_DURATION, EVT_DEBUFF_20_WEIGHT]
    debuffEventId.append(DebuffEventId.MOON_ROCKET)


    # ================================================
    # Pack 4: Mechanics
    # ================================================
    mechEvent[MechEventId.CHEAT_CARD_COUNTING] = [STR_EVT_MECH_7_TITLE, STR_EVT_MECH_7_DESC.format(Button.RELOAD, EVT_MECH_7_HEART_STEEL_COST, EVT_MECH_7_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK), EVT_MECH_7_DURATION, EVT_MECH_7_WEIGHT]
    mechEventId.append(MechEventId.CHEAT_CARD_COUNTING)

    mechEvent[MechEventId.GAMBLER_SHORT_INVESTMENT] = [STR_EVT_MECH_8_TITLE, STR_EVT_MECH_8_DESC.format(Button.RELOAD, EVT_MECH_8_CONTRACT_EVENTS, EVT_MECH_8_WIN_CHANCE, EVT_MECH_8_REWARD_STACKS), EVT_MECH_8_DURATION, EVT_MECH_8_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_SHORT_INVESTMENT)

    mechEvent[MechEventId.FATE_SYNC] = [STR_EVT_MECH_9_TITLE, STR_EVT_MECH_9_DESC, EVT_MECH_9_DURATION, EVT_MECH_9_WEIGHT]
    mechEventId.append(MechEventId.FATE_SYNC)

    mechEvent[MechEventId.CHEAT_SKIP_HERO] = [STR_EVT_MECH_10_TITLE, STR_EVT_MECH_10_DESC.format(Button.RELOAD), EVT_MECH_10_DURATION, EVT_MECH_10_WEIGHT]
    mechEventId.append(MechEventId.CHEAT_SKIP_HERO)

    mechEvent[MechEventId.NESTING_DOLL] = [STR_EVT_MECH_11_TITLE, STR_EVT_MECH_11_DESC.format(EVT_MECH_11_RESURRECT_DELAY, percent(EVT_MECH_11_SIZE_STEP), EVT_MECH_11_SPEED_STEP), EVT_MECH_11_DURATION, EVT_MECH_11_WEIGHT]
    mechEventId.append(MechEventId.NESTING_DOLL)

    mechEvent[MechEventId.GAMBLER_LONG_INVESTMENT] = [STR_EVT_MECH_12_TITLE, STR_EVT_MECH_12_DESC.format(Button.RELOAD, EVT_MECH_12_CONTRACT_EVENTS, EVT_MECH_12_WIN_CHANCE, EVT_MECH_12_REWARD_STACKS), EVT_MECH_12_DURATION, EVT_MECH_12_WEIGHT]
    mechEventId.append(MechEventId.GAMBLER_LONG_INVESTMENT)

    mechEvent[MechEventId.VALKYRIE_DESCENT] = [STR_EVT_MECH_13_TITLE, STR_EVT_MECH_13_DESC.format(EVT_MECH_13_SIZE_HEALTH * 100, percent(EVT_MECH_13_HEAL_SMOOTHING)), EVT_MECH_13_DURATION, EVT_MECH_13_WEIGHT]
    mechEventId.append(MechEventId.VALKYRIE_DESCENT)

    mechEvent[MechEventId.TRINITY_SSR] = [STR_EVT_MECH_14_TITLE, STR_EVT_MECH_14_DESC.format(100 / EVT_MECH_14_DMG_REDUCE_DIVISOR, EVT_MECH_14_SPEED_FACTOR, EVT_MECH_14_INTERVAL / EVT_MECH_14_HEART_STEEL_PER_TICK), EVT_MECH_14_DURATION, EVT_MECH_14_WEIGHT]
    mechEventId.append(MechEventId.TRINITY_SSR)


    lbl_3:
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_5, true, 1):
        goto lbl_4

    # ================================================
    # Pack 5: Mechanics
    # ================================================
    mechEvent[MechEventId.GAMBLER_DICE_MANIAC] = [
        STR_EVT_MECH_15_TITLE,
        STR_EVT_MECH_15_DESC.format(EVT_MECH_15_DURATION, Button.RELOAD, EVT_MECH_15_HOLD_TIME, EVT_MECH_15_HEART_STEEL_DELTA, EVT_MECH_15_SPEED_DELTA, EVT_MECH_15_DMG_HEAL_DELTA),
        EVT_MECH_15_DURATION,
        EVT_MECH_15_WEIGHT
    ]
    mechEventId.append(MechEventId.GAMBLER_DICE_MANIAC)

    lbl_4:
