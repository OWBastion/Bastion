#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "initialize event array":
    @Condition vishkarEventActivated == true

    eventWeight = EVT_INIT_EVENT_WEIGHT
    
    # ================================================
    # 增益事件 (Buff Events)
    # ================================================
    buffEventName = []
    buffEventDesc = []
    buffEventDuration = []
    buffEventWeight = []
    buffEventId = []

    # ================================================
    # 减益事件 (Debuff Events)
    # ================================================
    debuffEventName = []
    debuffEventDesc = []
    debuffEventDuration = []
    debuffEventWeight = []
    debuffEventId = []

    # ================================================
    # 机制事件 (Mech Events)
    # ================================================
    mechEventName = []
    mechEventDesc = []
    mechEventDuration = []
    mechEventWeight = []
    mechEventId = []
    
    # Pack 0 - Special
    buffEventName[BuffEventId.OLIVIA_GIFT] = STR_EVT_BUFF_0_TITLE
    buffEventDesc[BuffEventId.OLIVIA_GIFT] = STR_EVT_BUFF_0_DESC
    buffEventDuration[BuffEventId.OLIVIA_GIFT] = EVT_BUFF_0_DURATION
    buffEventWeight[BuffEventId.OLIVIA_GIFT] = EVT_BUFF_0_WEIGHT
    buffEventId.append(BuffEventId.OLIVIA_GIFT)
    
    # ================================================
    # Pack 1: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_1, true, 1):
        goto lbl_0
    buffEventName[BuffEventId.GALE_BLESSING] = STR_EVT_BUFF_1_TITLE
    buffEventDesc[BuffEventId.GALE_BLESSING] = STR_EVT_BUFF_1_DESC.format(EVT_1_SPEED_BOOST)
    buffEventDuration[BuffEventId.GALE_BLESSING] = EVT_BUFF_1_DURATION
    buffEventWeight[BuffEventId.GALE_BLESSING] = EVT_BUFF_1_WEIGHT
    buffEventId.append(BuffEventId.GALE_BLESSING)

    buffEventName[BuffEventId.IRON_BULWARK] = STR_EVT_BUFF_2_TITLE
    buffEventDesc[BuffEventId.IRON_BULWARK] = STR_EVT_BUFF_2_DESC.format(EVT_2_ARMOR_FLAT, percent(EVT_2_ARMOR_MAXHP_FACTOR), negToPos(EVT_2_DMG_TAKEN))
    buffEventDuration[BuffEventId.IRON_BULWARK] = EVT_BUFF_2_DURATION
    buffEventWeight[BuffEventId.IRON_BULWARK] = EVT_BUFF_2_WEIGHT
    buffEventId.append(BuffEventId.IRON_BULWARK)

    buffEventName[BuffEventId.LIFE_SPRING] = STR_EVT_BUFF_4_TITLE
    buffEventDesc[BuffEventId.LIFE_SPRING] = STR_EVT_BUFF_4_DESC.format(percent(EVT_4_HEAL_PERCENT))
    buffEventDuration[BuffEventId.LIFE_SPRING] = EVT_BUFF_4_DURATION
    buffEventWeight[BuffEventId.LIFE_SPRING] = EVT_BUFF_4_WEIGHT
    buffEventId.append(BuffEventId.LIFE_SPRING)

    buffEventName[BuffEventId.BLACK_FANS_ASSAULT] = STR_EVT_BUFF_5_TITLE
    buffEventDesc[BuffEventId.BLACK_FANS_ASSAULT] = STR_EVT_BUFF_5_DESC.format(EVT_5_BASE_HEALTH, percent(EVT_5_HEALTH_MAXHP_PERCENT), EVT_5_SPEED_BOOST)
    buffEventDuration[BuffEventId.BLACK_FANS_ASSAULT] = EVT_BUFF_5_DURATION
    buffEventWeight[BuffEventId.BLACK_FANS_ASSAULT] = EVT_BUFF_5_WEIGHT
    buffEventId.append(BuffEventId.BLACK_FANS_ASSAULT)

    buffEventName[BuffEventId.SPEED_STACK] = STR_EVT_BUFF_6_TITLE
    buffEventDesc[BuffEventId.SPEED_STACK] = STR_EVT_BUFF_6_DESC.format(EVT_6_SPEED_INC_PER_SEC)
    buffEventDuration[BuffEventId.SPEED_STACK] = EVT_BUFF_6_DURATION
    buffEventWeight[BuffEventId.SPEED_STACK] = EVT_BUFF_6_WEIGHT
    buffEventId.append(BuffEventId.SPEED_STACK)

    buffEventName[BuffEventId.FLESH_REGEN] = STR_EVT_BUFF_7_TITLE
    buffEventDesc[BuffEventId.FLESH_REGEN] = STR_EVT_BUFF_7_DESC.format(EVT_7_BASE_HEALTH, percent(EVT_7_HEALTH_PERCENT), EVT_7_REGEN_INTERVAL)
    buffEventDuration[BuffEventId.FLESH_REGEN] = EVT_BUFF_7_DURATION
    buffEventWeight[BuffEventId.FLESH_REGEN] = EVT_BUFF_7_WEIGHT
    buffEventId.append(BuffEventId.FLESH_REGEN)

    buffEventName[BuffEventId.HEART_OF_STEEL] = STR_EVT_BUFF_8_TITLE
    buffEventDesc[BuffEventId.HEART_OF_STEEL] = STR_EVT_BUFF_8_DESC.format(EVT_8_HP_LAYER_PER_DEATH, EVT_8_HP_PERCENT_PER_STACK)
    buffEventDuration[BuffEventId.HEART_OF_STEEL] = EVT_BUFF_8_DURATION
    buffEventWeight[BuffEventId.HEART_OF_STEEL] = EVT_BUFF_8_WEIGHT
    buffEventId.append(BuffEventId.HEART_OF_STEEL)

    # ================================================
    # Pack 1: Debuffs
    # ================================================
    debuffEventName[DebuffEventId.GRAVITY_ANOMALY] = STR_EVT_DEBUFF_0_TITLE
    debuffEventDesc[DebuffEventId.GRAVITY_ANOMALY] = STR_EVT_DEBUFF_0_DESC.format(EVT_DEBUFF_0_GRAVITY)
    debuffEventDuration[DebuffEventId.GRAVITY_ANOMALY] = EVT_DEBUFF_0_DURATION
    debuffEventWeight[DebuffEventId.GRAVITY_ANOMALY] = EVT_DEBUFF_0_WEIGHT
    debuffEventId.append(DebuffEventId.GRAVITY_ANOMALY)

    debuffEventName[DebuffEventId.EMP] = STR_EVT_DEBUFF_1_TITLE
    debuffEventDesc[DebuffEventId.EMP] = STR_EVT_DEBUFF_1_DESC
    debuffEventDuration[DebuffEventId.EMP] = EVT_DEBUFF_1_HACK_DURATION
    debuffEventWeight[DebuffEventId.EMP] = EVT_DEBUFF_1_WEIGHT
    debuffEventId.append(DebuffEventId.EMP)

    debuffEventName[DebuffEventId.SACRIFICE] = STR_EVT_DEBUFF_2_TITLE
    debuffEventDesc[DebuffEventId.SACRIFICE] = STR_EVT_DEBUFF_2_DESC.format(percent(EVT_DEBUFF_2_DMG_PERCENT))
    debuffEventDuration[DebuffEventId.SACRIFICE] = EVT_DEBUFF_2_DURATION
    debuffEventWeight[DebuffEventId.SACRIFICE] = EVT_DEBUFF_2_WEIGHT
    debuffEventId.append(DebuffEventId.SACRIFICE)

    debuffEventName[DebuffEventId.VULNERABLE] = STR_EVT_DEBUFF_3_TITLE
    debuffEventDesc[DebuffEventId.VULNERABLE] = STR_EVT_DEBUFF_3_DESC.format(EVT_DEBUFF_3_DMG_TAKEN)
    debuffEventDuration[DebuffEventId.VULNERABLE] = EVT_DEBUFF_3_DURATION
    debuffEventWeight[DebuffEventId.VULNERABLE] = EVT_DEBUFF_3_WEIGHT
    debuffEventId.append(DebuffEventId.VULNERABLE)

    debuffEventName[DebuffEventId.SPEED_LIMIT_40] = STR_EVT_DEBUFF_4_TITLE
    debuffEventDesc[DebuffEventId.SPEED_LIMIT_40] = STR_EVT_DEBUFF_4_DESC.format(EVT_DEBUFF_4_DMG_BASE, percent(EVT_DEBUFF_4_DMG_PERCENT))
    debuffEventDuration[DebuffEventId.SPEED_LIMIT_40] = EVT_DEBUFF_4_DURATION
    debuffEventWeight[DebuffEventId.SPEED_LIMIT_40] = EVT_DEBUFF_4_WEIGHT
    debuffEventId.append(DebuffEventId.SPEED_LIMIT_40)


    # ================================================
    # Pack 1: Mechanics
    # ================================================
    mechEventName[MechEventId.GAMBLER] = STR_EVT_MECH_1_TITLE
    mechEventDesc[MechEventId.GAMBLER] = STR_EVT_MECH_1_DESC.format(Button.RELOAD, EVT_MECH_1_WIN_RATE, EVT_MECH_1_STAKE)
    mechEventDuration[MechEventId.GAMBLER] = EVT_MECH_1_DURATION
    mechEventWeight[MechEventId.GAMBLER] = EVT_MECH_1_WEIGHT
    mechEventId.append(MechEventId.GAMBLER)

    mechEventName[MechEventId.MINI_FORM] = STR_EVT_MECH_2_TITLE
    mechEventDesc[MechEventId.MINI_FORM] = STR_EVT_MECH_2_DESC.format(percent(1 - EVT_MECH_2_MODEL_SCALE), percent(1 - EVT_MECH_2_HP_SCALE), EVT_MECH_2_SPEED_BOOST)
    mechEventDuration[MechEventId.MINI_FORM] = EVT_MECH_2_DURATION
    mechEventWeight[MechEventId.MINI_FORM] = EVT_MECH_2_WEIGHT
    mechEventId.append(MechEventId.MINI_FORM)

    mechEventName[MechEventId.STEALTH_CROUCH] = STR_EVT_MECH_3_TITLE
    mechEventDesc[MechEventId.STEALTH_CROUCH] = STR_EVT_MECH_3_DESC.format(percent(EVT_MECH_3_HP_COST_RATIO), EVT_MECH_3_SPEED_BOOST)
    mechEventDuration[MechEventId.STEALTH_CROUCH] = EVT_MECH_3_DURATION
    mechEventWeight[MechEventId.STEALTH_CROUCH] = EVT_MECH_3_WEIGHT
    mechEventId.append(MechEventId.STEALTH_CROUCH)

    lbl_0:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_2, true, 1):
        goto lbl_1

    # ================================================
    # Pack 2: Buffs
    # ================================================
    buffEventName[BuffEventId.DEATH_DELAY] = STR_EVT_BUFF_9_TITLE
    buffEventDesc[BuffEventId.DEATH_DELAY] = STR_EVT_BUFF_9_DESC
    buffEventDuration[BuffEventId.DEATH_DELAY] = EVT_BUFF_9_DURATION
    buffEventWeight[BuffEventId.DEATH_DELAY] = EVT_BUFF_9_WEIGHT
    buffEventId.append(BuffEventId.DEATH_DELAY)

    buffEventName[BuffEventId.KONAMI_CODE] = STR_EVT_BUFF_11_TITLE
    buffEventDesc[BuffEventId.KONAMI_CODE] = STR_EVT_BUFF_11_DESC
    buffEventDuration[BuffEventId.KONAMI_CODE] = EVT_BUFF_11_DURATION
    buffEventWeight[BuffEventId.KONAMI_CODE] = EVT_BUFF_11_WEIGHT
    buffEventId.append(BuffEventId.KONAMI_CODE)

    buffEventName[BuffEventId.PHOTON_SHIELD] = STR_EVT_BUFF_12_TITLE
    buffEventDesc[BuffEventId.PHOTON_SHIELD] = STR_EVT_BUFF_12_DESC.format(percent(EVT_12_SHIELD_PERCENT))
    buffEventDuration[BuffEventId.PHOTON_SHIELD] = EVT_BUFF_12_DURATION
    buffEventWeight[BuffEventId.PHOTON_SHIELD] = EVT_BUFF_12_WEIGHT
    buffEventId.append(BuffEventId.PHOTON_SHIELD)


    # ================================================
    # Pack 2: Debuffs
    # ================================================
    debuffEventName[DebuffEventId.GRAVITY_PULL] = STR_EVT_DEBUFF_5_TITLE
    debuffEventDesc[DebuffEventId.GRAVITY_PULL] = STR_EVT_DEBUFF_5_DESC.format(EVT_DEBUFF_5_SPEED_REDUCTION)
    debuffEventDuration[DebuffEventId.GRAVITY_PULL] = EVT_DEBUFF_5_DURATION
    debuffEventWeight[DebuffEventId.GRAVITY_PULL] = EVT_DEBUFF_5_WEIGHT
    debuffEventId.append(DebuffEventId.GRAVITY_PULL)

    debuffEventName[DebuffEventId.OSTEOPOROSIS] = STR_EVT_DEBUFF_6_TITLE
    debuffEventDesc[DebuffEventId.OSTEOPOROSIS] = STR_EVT_DEBUFF_6_DESC.format(negToPos(EVT_DEBUFF_6_MAX_SPEED_DEC))
    debuffEventDuration[DebuffEventId.OSTEOPOROSIS] = EVT_DEBUFF_6_DURATION
    debuffEventWeight[DebuffEventId.OSTEOPOROSIS] = EVT_DEBUFF_6_WEIGHT
    debuffEventId.append(DebuffEventId.OSTEOPOROSIS)

    debuffEventName[DebuffEventId.EMP_PROMAX] = STR_EVT_DEBUFF_7_TITLE
    debuffEventDesc[DebuffEventId.EMP_PROMAX] = STR_EVT_DEBUFF_7_DESC.format(EVT_DEBUFF_7_RADIUS)
    debuffEventDuration[DebuffEventId.EMP_PROMAX] = EVT_DEBUFF_7_DURATION
    debuffEventWeight[DebuffEventId.EMP_PROMAX] = EVT_DEBUFF_7_WEIGHT
    debuffEventId.append(DebuffEventId.EMP_PROMAX)

    debuffEventName[DebuffEventId.ENERGY_LEAK] = STR_EVT_DEBUFF_8_TITLE
    debuffEventDesc[DebuffEventId.ENERGY_LEAK] = STR_EVT_DEBUFF_8_DESC.format(percent(EVT_DEBUFF_8_DMG_PERCENT))
    debuffEventDuration[DebuffEventId.ENERGY_LEAK] = EVT_DEBUFF_8_DURATION
    debuffEventWeight[DebuffEventId.ENERGY_LEAK] = EVT_DEBUFF_8_WEIGHT
    debuffEventId.append(DebuffEventId.ENERGY_LEAK)

    debuffEventName[DebuffEventId.SHARE_THE_PAIN] = STR_EVT_DEBUFF_9_TITLE
    debuffEventDesc[DebuffEventId.SHARE_THE_PAIN] = STR_EVT_DEBUFF_9_DESC.format(percent(EVT_DEBUFF_9_DMG_FACTOR), EVT_DEBUFF_9_RADIUS)
    debuffEventDuration[DebuffEventId.SHARE_THE_PAIN] = EVT_DEBUFF_9_DURATION
    debuffEventWeight[DebuffEventId.SHARE_THE_PAIN] = EVT_DEBUFF_9_WEIGHT
    debuffEventId.append(DebuffEventId.SHARE_THE_PAIN)

    debuffEventName[DebuffEventId.FEAST_FRENZY] = STR_EVT_DEBUFF_10_TITLE
    debuffEventDesc[DebuffEventId.FEAST_FRENZY] = STR_EVT_DEBUFF_10_DESC.format(EVT_DEBUFF_10_BERSERK_ADD)
    debuffEventDuration[DebuffEventId.FEAST_FRENZY] = EVT_DEBUFF_10_DURATION
    debuffEventWeight[DebuffEventId.FEAST_FRENZY] = EVT_DEBUFF_10_WEIGHT
    debuffEventId.append(DebuffEventId.FEAST_FRENZY)

    debuffEventName[DebuffEventId.POWERLESS_SPOUSE] = STR_EVT_DEBUFF_11_TITLE
    debuffEventDesc[DebuffEventId.POWERLESS_SPOUSE] = STR_EVT_DEBUFF_11_DESC.format(EVT_DEBUFF_11_KNOCKDOWN_DURATION)
    debuffEventDuration[DebuffEventId.POWERLESS_SPOUSE] = EVT_DEBUFF_11_DURATION
    debuffEventWeight[DebuffEventId.POWERLESS_SPOUSE] = EVT_DEBUFF_11_WEIGHT
    debuffEventId.append(DebuffEventId.POWERLESS_SPOUSE)


    # ================================================
    # Pack 2: Mechanics
    # ================================================
    mechEventName[MechEventId.BRAKE_FAILURE] = STR_EVT_MECH_4_TITLE
    mechEventDesc[MechEventId.BRAKE_FAILURE] = STR_EVT_MECH_4_DESC.format(100 + EVT_MECH_4_MAX_SPEED)
    mechEventDuration[MechEventId.BRAKE_FAILURE] = EVT_MECH_4_DURATION
    mechEventWeight[MechEventId.BRAKE_FAILURE] = EVT_MECH_4_WEIGHT
    mechEventId.append(MechEventId.BRAKE_FAILURE)

    
    lbl_1:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_3, true, 1):
        goto lbl_2
    
    # ================================================
    # Pack 3: Buffs
    # ================================================
    buffEventName[BuffEventId.REGROUP_CALL] = STR_EVT_BUFF_13_TITLE
    buffEventDesc[BuffEventId.REGROUP_CALL] = STR_EVT_BUFF_13_DESC.format(EVT_13_CHECK_INTERVAL, EVT_13_INVINCIBLE_DURATION)
    buffEventDuration[BuffEventId.REGROUP_CALL] = EVT_BUFF_13_DURATION
    buffEventWeight[BuffEventId.REGROUP_CALL] = EVT_BUFF_13_WEIGHT
    buffEventId.append(BuffEventId.REGROUP_CALL)

    buffEventName[BuffEventId.WILL_TO_WIN] = STR_EVT_BUFF_14_TITLE
    buffEventDesc[BuffEventId.WILL_TO_WIN] = STR_EVT_BUFF_14_DESC.format(percent(EVT_14_TRIGGER_HP_PERCENT), EVT_14_INVINCIBLE_DURATION)
    buffEventDuration[BuffEventId.WILL_TO_WIN] = EVT_BUFF_14_DURATION
    buffEventWeight[BuffEventId.WILL_TO_WIN] = EVT_BUFF_14_WEIGHT
    buffEventId.append(BuffEventId.WILL_TO_WIN)

    buffEventName[BuffEventId.PHEIDIPPIDES_TRIAL] = STR_EVT_BUFF_15_TITLE
    buffEventDesc[BuffEventId.PHEIDIPPIDES_TRIAL] = STR_EVT_BUFF_15_DESC.format(EVT_15_DISTANCE_GOAL, EVT_15_REWARD_SPEED)
    buffEventDuration[BuffEventId.PHEIDIPPIDES_TRIAL] = EVT_BUFF_15_DURATION
    buffEventWeight[BuffEventId.PHEIDIPPIDES_TRIAL] = EVT_BUFF_15_WEIGHT
    buffEventId.append(BuffEventId.PHEIDIPPIDES_TRIAL)

    buffEventName[BuffEventId.HEART_OF_STEEL_PRO] = STR_EVT_BUFF_16_TITLE
    buffEventDesc[BuffEventId.HEART_OF_STEEL_PRO] = STR_EVT_BUFF_16_DESC.format(EVT_16_HP_GAIN_FLAT, EVT_16_HP_MULTIPLIER)
    buffEventDuration[BuffEventId.HEART_OF_STEEL_PRO] = EVT_BUFF_16_DURATION
    buffEventWeight[BuffEventId.HEART_OF_STEEL_PRO] = EVT_BUFF_16_WEIGHT
    buffEventId.append(BuffEventId.HEART_OF_STEEL_PRO)

    buffEventName[BuffEventId.ULT_MOMENTUM] = STR_EVT_BUFF_18_TITLE
    buffEventDesc[BuffEventId.ULT_MOMENTUM] = STR_EVT_BUFF_18_DESC.format(EVT_18_DMG_REDUCTION_DURING_ULT)
    buffEventDuration[BuffEventId.ULT_MOMENTUM] = EVT_BUFF_18_DURATION
    buffEventWeight[BuffEventId.ULT_MOMENTUM] = EVT_BUFF_18_WEIGHT
    buffEventId.append(BuffEventId.ULT_MOMENTUM)
 
    # ================================================
    # Pack 3: Debuffs
    # ================================================
    debuffEventName[DebuffEventId.HALVED] = STR_EVT_DEBUFF_13_TITLE
    debuffEventDesc[DebuffEventId.HALVED] = STR_EVT_DEBUFF_13_DESC.format(EVT_DEBUFF_13_INTERVAL, percent(EVT_DEBUFF_13_DAMAGE_PERCENT), percent(EVT_DEBUFF_13_EXECUTE_THRESHOLD))
    debuffEventDuration[DebuffEventId.HALVED] = EVT_DEBUFF_13_DURATION
    debuffEventWeight[DebuffEventId.HALVED] = EVT_DEBUFF_13_WEIGHT
    debuffEventId.append(DebuffEventId.HALVED)

    debuffEventName[DebuffEventId.SELFLESS_GIVEAWAY] = STR_EVT_DEBUFF_14_TITLE
    debuffEventDesc[DebuffEventId.SELFLESS_GIVEAWAY] = STR_EVT_DEBUFF_14_DESC.format(EVT_DEBUFF_14_STACKS_TAKE)
    debuffEventDuration[DebuffEventId.SELFLESS_GIVEAWAY] = EVT_DEBUFF_14_DURATION
    debuffEventWeight[DebuffEventId.SELFLESS_GIVEAWAY] = EVT_DEBUFF_14_WEIGHT
    debuffEventId.append(DebuffEventId.SELFLESS_GIVEAWAY)


    # ================================================
    # Pack 3: Mechanics
    # ================================================
    mechEventName[MechEventId.EXTREME_CHALLENGE] = STR_EVT_MECH_0_TITLE
    mechEventDesc[MechEventId.EXTREME_CHALLENGE] = STR_EVT_MECH_0_DESC.format(negToPos(EVT_MECH_0_DMG_TAKEN), percent(EVT_MECH_0_HP_PERCENT))
    mechEventDuration[MechEventId.EXTREME_CHALLENGE] = EVT_MECH_0_DURATION
    mechEventWeight[MechEventId.EXTREME_CHALLENGE] = EVT_MECH_0_WEIGHT
    mechEventId.append(MechEventId.EXTREME_CHALLENGE)

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    mechEventName[MechEventId.JUMP_THRUST] = STR_EVT_MECH_5_TITLE
    mechEventDesc[MechEventId.JUMP_THRUST] = STR_EVT_MECH_5_DESC.format(Button.JUMP, negToPos(EVT_MECH_5_DMG_TAKEN))
    mechEventDuration[MechEventId.JUMP_THRUST] = EVT_MECH_5_DURATION
    mechEventWeight[MechEventId.JUMP_THRUST] = EVT_MECH_5_WEIGHT
    mechEventId.append(MechEventId.JUMP_THRUST)

    mechEventName[MechEventId.GAMBLER_SPEED_CHALLENGE] = STR_EVT_MECH_6_TITLE
    mechEventDesc[MechEventId.GAMBLER_SPEED_CHALLENGE] = STR_EVT_MECH_6_DESC.format(Button.RELOAD, EVT_MECH_6_HEARTSTEEL_COST, EVT_MECH_6_PROB_LOSE_NORMAL - EVT_MECH_6_PROB_WIN_NORMAL, EVT_MECH_6_VAL_NORMAL, 100 - EVT_MECH_6_PROB_LOSE_NORMAL, EVT_MECH_6_VAL_RARE)
    mechEventDuration[MechEventId.GAMBLER_SPEED_CHALLENGE] = EVT_MECH_6_DURATION
    mechEventWeight[MechEventId.GAMBLER_SPEED_CHALLENGE] = EVT_MECH_6_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_SPEED_CHALLENGE)

    
    lbl_2:
    
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_4, true, 1):
        goto lbl_3

    # ================================================
    # Pack 4: Buffs
    # ================================================
    buffEventName[BuffEventId.PHASE_SURGE] = STR_EVT_BUFF_19_TITLE
    buffEventDesc[BuffEventId.PHASE_SURGE] = STR_EVT_BUFF_19_DESC.format(EVT_19_SPEED_BOOST)
    buffEventDuration[BuffEventId.PHASE_SURGE] = EVT_BUFF_19_DURATION
    buffEventWeight[BuffEventId.PHASE_SURGE] = EVT_BUFF_19_WEIGHT
    buffEventId.append(BuffEventId.PHASE_SURGE)

    buffEventName[BuffEventId.BODYGUARD] = STR_EVT_BUFF_20_TITLE
    buffEventDesc[BuffEventId.BODYGUARD] = STR_EVT_BUFF_20_DESC
    buffEventDuration[BuffEventId.BODYGUARD] = EVT_BUFF_20_DURATION
    buffEventWeight[BuffEventId.BODYGUARD] = EVT_BUFF_20_WEIGHT
    buffEventId.append(BuffEventId.BODYGUARD)

    buffEventName[BuffEventId.MARTYR_TRIAL] = STR_EVT_BUFF_21_TITLE
    buffEventDesc[BuffEventId.MARTYR_TRIAL] = STR_EVT_BUFF_21_DESC.format(negToPos(EVT_21_REWARD_DMG_PERMA))
    buffEventDuration[BuffEventId.MARTYR_TRIAL] = EVT_BUFF_21_DURATION
    buffEventWeight[BuffEventId.MARTYR_TRIAL] = EVT_BUFF_21_WEIGHT
    buffEventId.append(BuffEventId.MARTYR_TRIAL)

    buffEventName[BuffEventId.F5_REFRESH] = STR_EVT_BUFF_24_TITLE
    buffEventDesc[BuffEventId.F5_REFRESH] = STR_EVT_BUFF_24_DESC.format(EVT_24_REFRESH_INTERVAL)
    buffEventDuration[BuffEventId.F5_REFRESH] = EVT_BUFF_24_DURATION
    buffEventWeight[BuffEventId.F5_REFRESH] = EVT_BUFF_24_WEIGHT
    buffEventId.append(BuffEventId.F5_REFRESH)

    buffEventName[BuffEventId.HEALING_TOWER_PROMAX] = STR_EVT_BUFF_25_TITLE
    buffEventDesc[BuffEventId.HEALING_TOWER_PROMAX] = STR_EVT_BUFF_25_DESC.format(EVT_25_HEAL_FLAT, percent(EVT_25_HEAL_MAXHP_FACTOR))
    buffEventDuration[BuffEventId.HEALING_TOWER_PROMAX] = EVT_BUFF_25_DURATION
    buffEventWeight[BuffEventId.HEALING_TOWER_PROMAX] = EVT_BUFF_25_WEIGHT
    buffEventId.append(BuffEventId.HEALING_TOWER_PROMAX)

    # ================================================
    # Pack 4: Debuffs
    # ================================================
    debuffEventName[DebuffEventId.KEEP_DISTANCE_AURA] = STR_EVT_DEBUFF_15_TITLE
    debuffEventDesc[DebuffEventId.KEEP_DISTANCE_AURA] = STR_EVT_DEBUFF_15_DESC
    debuffEventDuration[DebuffEventId.KEEP_DISTANCE_AURA] = EVT_DEBUFF_15_DURATION
    debuffEventWeight[DebuffEventId.KEEP_DISTANCE_AURA] = EVT_DEBUFF_15_WEIGHT
    debuffEventId.append(DebuffEventId.KEEP_DISTANCE_AURA)

    debuffEventName[DebuffEventId.MOON_ROCKET] = STR_EVT_DEBUFF_20_TITLE
    debuffEventDesc[DebuffEventId.MOON_ROCKET] = STR_EVT_DEBUFF_20_DESC
    debuffEventDuration[DebuffEventId.MOON_ROCKET] = EVT_DEBUFF_20_DURATION
    debuffEventWeight[DebuffEventId.MOON_ROCKET] = EVT_DEBUFF_20_WEIGHT
    debuffEventId.append(DebuffEventId.MOON_ROCKET)


    # ================================================
    # Pack 4: Mechanics
    # ================================================
    mechEventName[MechEventId.CHEAT_CARD_COUNTING] = STR_EVT_MECH_7_TITLE
    mechEventDesc[MechEventId.CHEAT_CARD_COUNTING] = STR_EVT_MECH_7_DESC.format(Button.RELOAD, EVT_MECH_7_HEART_STEEL_COST, EVT_MECH_7_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    mechEventDuration[MechEventId.CHEAT_CARD_COUNTING] = EVT_MECH_7_DURATION
    mechEventWeight[MechEventId.CHEAT_CARD_COUNTING] = EVT_MECH_7_WEIGHT
    mechEventId.append(MechEventId.CHEAT_CARD_COUNTING)

    mechEventName[MechEventId.GAMBLER_SHORT_INVESTMENT] = STR_EVT_MECH_8_TITLE
    mechEventDesc[MechEventId.GAMBLER_SHORT_INVESTMENT] = STR_EVT_MECH_8_DESC.format(Button.RELOAD, EVT_MECH_8_CONTRACT_EVENTS, EVT_MECH_8_WIN_CHANCE, EVT_MECH_8_REWARD_STACKS)
    mechEventDuration[MechEventId.GAMBLER_SHORT_INVESTMENT] = EVT_MECH_8_DURATION
    mechEventWeight[MechEventId.GAMBLER_SHORT_INVESTMENT] = EVT_MECH_8_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_SHORT_INVESTMENT)

    mechEventName[MechEventId.CHEAT_SKIP_HERO] = STR_EVT_MECH_10_TITLE
    mechEventDesc[MechEventId.CHEAT_SKIP_HERO] = STR_EVT_MECH_10_DESC.format(Button.RELOAD)
    mechEventDuration[MechEventId.CHEAT_SKIP_HERO] = EVT_MECH_10_DURATION
    mechEventWeight[MechEventId.CHEAT_SKIP_HERO] = EVT_MECH_10_WEIGHT
    mechEventId.append(MechEventId.CHEAT_SKIP_HERO)

    mechEventName[MechEventId.NESTING_DOLL] = STR_EVT_MECH_11_TITLE
    mechEventDesc[MechEventId.NESTING_DOLL] = STR_EVT_MECH_11_DESC.format(EVT_MECH_11_RESURRECT_DELAY, percent(EVT_MECH_11_SIZE_STEP), EVT_MECH_11_SPEED_STEP)
    mechEventDuration[MechEventId.NESTING_DOLL] = EVT_MECH_11_DURATION
    mechEventWeight[MechEventId.NESTING_DOLL] = EVT_MECH_11_WEIGHT
    mechEventId.append(MechEventId.NESTING_DOLL)

    mechEventName[MechEventId.GAMBLER_LONG_INVESTMENT] = STR_EVT_MECH_12_TITLE
    mechEventDesc[MechEventId.GAMBLER_LONG_INVESTMENT] = STR_EVT_MECH_12_DESC.format(Button.RELOAD, EVT_MECH_12_CONTRACT_EVENTS, EVT_MECH_12_WIN_CHANCE, EVT_MECH_12_REWARD_STACKS)
    mechEventDuration[MechEventId.GAMBLER_LONG_INVESTMENT] = EVT_MECH_12_DURATION
    mechEventWeight[MechEventId.GAMBLER_LONG_INVESTMENT] = EVT_MECH_12_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_LONG_INVESTMENT)

    mechEventName[MechEventId.VALKYRIE_DESCENT] = STR_EVT_MECH_13_TITLE
    mechEventDesc[MechEventId.VALKYRIE_DESCENT] = STR_EVT_MECH_13_DESC.format(EVT_MECH_13_SIZE_HEALTH * 100, percent(EVT_MECH_13_HEAL_SMOOTHING))
    mechEventDuration[MechEventId.VALKYRIE_DESCENT] = EVT_MECH_13_DURATION
    mechEventWeight[MechEventId.VALKYRIE_DESCENT] = EVT_MECH_13_WEIGHT
    mechEventId.append(MechEventId.VALKYRIE_DESCENT)

    mechEventName[MechEventId.TRINITY_SSR] = STR_EVT_MECH_14_TITLE
    mechEventDesc[MechEventId.TRINITY_SSR] = STR_EVT_MECH_14_DESC.format(100 / EVT_MECH_14_DMG_REDUCE_DIVISOR, EVT_MECH_14_SPEED_FACTOR, EVT_MECH_14_INTERVAL / EVT_MECH_14_HEART_STEEL_PER_TICK)
    mechEventDuration[MechEventId.TRINITY_SSR] = EVT_MECH_14_DURATION
    mechEventWeight[MechEventId.TRINITY_SSR] = EVT_MECH_14_WEIGHT
    mechEventId.append(MechEventId.TRINITY_SSR)

    mechEventName[MechEventId.VAMPIRE] = STR_EVT_MECH_18_TITLE
    mechEventDesc[MechEventId.VAMPIRE] = STR_EVT_MECH_18_DESC.format(EVT_MECH_18_DRAIN_FLAT, percent(EVT_MECH_18_DRAIN_MAXHP_FACTOR), EVT_MECH_18_KILL_HEAL_PERMA)
    mechEventDuration[MechEventId.VAMPIRE] = EVT_MECH_18_DURATION
    mechEventWeight[MechEventId.VAMPIRE] = EVT_MECH_18_WEIGHT
    mechEventId.append(MechEventId.VAMPIRE)

    mechEventName[MechEventId.THIEF] = STR_EVT_MECH_19_TITLE
    mechEventDesc[MechEventId.THIEF] = STR_EVT_MECH_19_DESC.format(Button.RELOAD)
    mechEventDuration[MechEventId.THIEF] = EVT_MECH_19_DURATION
    mechEventWeight[MechEventId.THIEF] = EVT_MECH_19_WEIGHT
    mechEventId.append(MechEventId.THIEF)

    mechEventName[MechEventId.GAMBLER_HELPFUL_SOUL] = STR_EVT_MECH_20_TITLE
    mechEventDesc[MechEventId.GAMBLER_HELPFUL_SOUL] = STR_EVT_MECH_20_DESC.format(Button.RELOAD, EVT_MECH_20_WIN_RATE, percent(EVT_MECH_20_HEAL_MAXHP_FACTOR), 100 - EVT_MECH_20_WIN_RATE)
    mechEventDuration[MechEventId.GAMBLER_HELPFUL_SOUL] = EVT_MECH_20_DURATION
    mechEventWeight[MechEventId.GAMBLER_HELPFUL_SOUL] = EVT_MECH_20_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_HELPFUL_SOUL)

    mechEventName[MechEventId.CHEAT_BACKROOM_DEAL] = STR_EVT_MECH_22_TITLE
    mechEventDesc[MechEventId.CHEAT_BACKROOM_DEAL] = STR_EVT_MECH_22_DESC.format(Button.RELOAD, EVT_MECH_22_HEART_STEEL_COST, EVT_MECH_22_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    mechEventDuration[MechEventId.CHEAT_BACKROOM_DEAL] = EVT_MECH_22_DURATION
    mechEventWeight[MechEventId.CHEAT_BACKROOM_DEAL] = EVT_MECH_22_WEIGHT
    mechEventId.append(MechEventId.CHEAT_BACKROOM_DEAL)

    mechEventName[MechEventId.MIRROR_INVERSION] = STR_EVT_MECH_23_TITLE
    mechEventDesc[MechEventId.MIRROR_INVERSION] = STR_EVT_MECH_23_DESC.format(Button.RELOAD)
    mechEventDuration[MechEventId.MIRROR_INVERSION] = EVT_MECH_23_DURATION
    mechEventWeight[MechEventId.MIRROR_INVERSION] = EVT_MECH_23_WEIGHT
    mechEventId.append(MechEventId.MIRROR_INVERSION)

    mechEventName[MechEventId.GAMBLER_WINNER_TAKE_ALL] = STR_EVT_MECH_24_TITLE
    mechEventDesc[MechEventId.GAMBLER_WINNER_TAKE_ALL] = STR_EVT_MECH_24_DESC.format(Button.RELOAD, percent(EVT_MECH_24_STAKE_RATIO), EVT_MECH_24_WIN_RATE)
    mechEventDuration[MechEventId.GAMBLER_WINNER_TAKE_ALL] = EVT_MECH_24_DURATION
    mechEventWeight[MechEventId.GAMBLER_WINNER_TAKE_ALL] = EVT_MECH_24_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_WINNER_TAKE_ALL)


    lbl_3:
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_5, true, 1):
        goto lbl_4

    # ================================================
    # Pack 5: Buffs
    # ================================================
    buffEventName[BuffEventId.MAGIC_MASTER] = STR_EVT_BUFF_29_TITLE
    buffEventDesc[BuffEventId.MAGIC_MASTER] = STR_EVT_BUFF_29_DESC.format(EVT_29_SPEED_BOOST)
    buffEventDuration[BuffEventId.MAGIC_MASTER] = EVT_BUFF_29_DURATION
    buffEventWeight[BuffEventId.MAGIC_MASTER] = EVT_BUFF_29_WEIGHT
    buffEventId.append(BuffEventId.MAGIC_MASTER)

    buffEventName[BuffEventId.DIVINE_REINFORCEMENT] = STR_EVT_BUFF_30_TITLE
    buffEventDesc[BuffEventId.DIVINE_REINFORCEMENT] = STR_EVT_BUFF_30_DESC.format(Button.RELOAD, EVT_30_HEAL_FLAT, percent(EVT_30_HEAL_MAXHP_FACTOR), EVT_30_COOLDOWN)
    buffEventDuration[BuffEventId.DIVINE_REINFORCEMENT] = EVT_BUFF_30_DURATION
    buffEventWeight[BuffEventId.DIVINE_REINFORCEMENT] = EVT_BUFF_30_WEIGHT
    buffEventId.append(BuffEventId.DIVINE_REINFORCEMENT)

    buffEventName[BuffEventId.TEMPER_HEART] = STR_EVT_BUFF_31_TITLE
    buffEventDesc[BuffEventId.TEMPER_HEART] = STR_EVT_BUFF_31_DESC.format(EVT_31_HERO_GOAL, EVT_31_STACK_MULTIPLIER, EVT_8_HP_PERCENT_PER_STACK, EVT_8_HP_PERCENT_PER_STACK + EVT_31_PERCENT_PER_STACK_BONUS)
    buffEventDuration[BuffEventId.TEMPER_HEART] = EVT_BUFF_31_DURATION
    buffEventWeight[BuffEventId.TEMPER_HEART] = EVT_BUFF_31_WEIGHT
    buffEventId.append(BuffEventId.TEMPER_HEART)

    buffEventName[BuffEventId.BATTLEFIELD_MEDIC] = STR_EVT_BUFF_32_TITLE
    buffEventDesc[BuffEventId.BATTLEFIELD_MEDIC] = STR_EVT_BUFF_32_DESC.format(EVT_32_HEAL_GOAL, EVT_32_REWARD_HEAL_PERMA)
    buffEventDuration[BuffEventId.BATTLEFIELD_MEDIC] = EVT_BUFF_32_DURATION
    buffEventWeight[BuffEventId.BATTLEFIELD_MEDIC] = EVT_BUFF_32_WEIGHT
    buffEventId.append(BuffEventId.BATTLEFIELD_MEDIC)
    # ================================================
    # Pack 5: Debuffs
    # ================================================
    debuffEventName[DebuffEventId.WAYWARD_NAVIGATION] = STR_EVT_DEBUFF_22_TITLE
    debuffEventDesc[DebuffEventId.WAYWARD_NAVIGATION] = STR_EVT_DEBUFF_22_DESC.format(EVT_DEBUFF_22_INTERVAL)
    debuffEventDuration[DebuffEventId.WAYWARD_NAVIGATION] = EVT_DEBUFF_22_DURATION
    debuffEventWeight[DebuffEventId.WAYWARD_NAVIGATION] = EVT_DEBUFF_22_WEIGHT
    debuffEventId.append(DebuffEventId.WAYWARD_NAVIGATION)

    debuffEventName[DebuffEventId.OVERWEIGHT_PACK] = STR_EVT_DEBUFF_23_TITLE
    debuffEventDesc[DebuffEventId.OVERWEIGHT_PACK] = STR_EVT_DEBUFF_23_DESC.format(EVT_DEBUFF_23_HP_UNIT, EVT_DEBUFF_23_DMG_TAKEN_PER_UNIT)
    debuffEventDuration[DebuffEventId.OVERWEIGHT_PACK] = EVT_DEBUFF_23_DURATION
    debuffEventWeight[DebuffEventId.OVERWEIGHT_PACK] = EVT_DEBUFF_23_WEIGHT
    debuffEventId.append(DebuffEventId.OVERWEIGHT_PACK)

    debuffEventName[DebuffEventId.ADLERSBRUNN_WRAITH] = STR_EVT_DEBUFF_21_TITLE
    debuffEventDesc[DebuffEventId.ADLERSBRUNN_WRAITH] = STR_EVT_DEBUFF_21_DESC.format(EVT_DEBUFF_21_TOTAL_STACK, negToPos(EVT_DEBUFF_21_HEAL_DELTA_PER_STACK), Button.RELOAD, percent(EVT_DEBUFF_21_HP_COST_RATIO))
    debuffEventDuration[DebuffEventId.ADLERSBRUNN_WRAITH] = EVT_DEBUFF_21_DURATION
    debuffEventWeight[DebuffEventId.ADLERSBRUNN_WRAITH] = EVT_DEBUFF_21_WEIGHT
    debuffEventId.append(DebuffEventId.ADLERSBRUNN_WRAITH)

    # ================================================
    # Pack 5: Mechanics
    # ================================================
    mechEventName[MechEventId.GAMBLER_DICE_MANIAC] = STR_EVT_MECH_15_TITLE
    mechEventDesc[MechEventId.GAMBLER_DICE_MANIAC] = STR_EVT_MECH_15_DESC.format(EVT_MECH_15_DURATION, Button.RELOAD, EVT_INTERACT_HOLD_TIME, EVT_MECH_15_HEART_STEEL_DELTA, EVT_MECH_15_SPEED_DELTA, EVT_MECH_15_DMG_HEAL_DELTA)
    mechEventDuration[MechEventId.GAMBLER_DICE_MANIAC] = EVT_MECH_15_DURATION
    mechEventWeight[MechEventId.GAMBLER_DICE_MANIAC] = EVT_MECH_15_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_DICE_MANIAC)

    mechEventName[MechEventId.GAMBLER_HEART_OF_STEEL] = STR_EVT_MECH_16_TITLE
    mechEventDesc[MechEventId.GAMBLER_HEART_OF_STEEL] = STR_EVT_MECH_16_DESC.format(Button.RELOAD, EVT_MECH_16_WIN_RATE, EVT_MECH_16_WIN_MULTIPLIER, 100 - EVT_MECH_16_WIN_RATE, percent(EVT_MECH_16_LOSE_RATIO))
    mechEventDuration[MechEventId.GAMBLER_HEART_OF_STEEL] = EVT_MECH_16_DURATION
    mechEventWeight[MechEventId.GAMBLER_HEART_OF_STEEL] = EVT_MECH_16_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_HEART_OF_STEEL)

    mechEventName[MechEventId.GAMBLER_ALL_IN_ART_5] = STR_EVT_MECH_17_TITLE
    mechEventDesc[MechEventId.GAMBLER_ALL_IN_ART_5] = STR_EVT_MECH_17_DESC.format(Button.RELOAD, percent(EVT_MECH_17_STAKE_RATIO), EVT_MECH_17_WIN_RATE, EVT_MECH_17_WIN_MULTIPLIER)
    mechEventDuration[MechEventId.GAMBLER_ALL_IN_ART_5] = EVT_MECH_17_DURATION
    mechEventWeight[MechEventId.GAMBLER_ALL_IN_ART_5] = EVT_MECH_17_WEIGHT
    mechEventId.append(MechEventId.GAMBLER_ALL_IN_ART_5)

    lbl_4:
