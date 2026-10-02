#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "initialize event array":
    @Condition vishkarEventActivated == true

    eventWeight = EVT_INIT_EVENT_WEIGHT

    eventCatalogId = []
    eventName = []
    eventDesc = []
    eventDuration = []
    eventCatalogWeight = []
    eventCatalogType = []

    # Pack 0 - Special
    eventName[EventId.OLIVIA_GIFT] = STR_EVT_BUFF_0_TITLE
    eventDesc[EventId.OLIVIA_GIFT] = STR_EVT_BUFF_0_DESC
    eventDuration[EventId.OLIVIA_GIFT] = EVT_BUFF_0_DURATION
    eventCatalogWeight[EventId.OLIVIA_GIFT] = EVT_BUFF_0_WEIGHT
    eventCatalogType[EventId.OLIVIA_GIFT] = EventType.BUFF
    eventCatalogId.append(EventId.OLIVIA_GIFT)
    
    # ================================================
    # Pack 1: Buffs
    # ================================================
    eventName[EventId.GALE_BLESSING] = STR_EVT_BUFF_1_TITLE
    eventDesc[EventId.GALE_BLESSING] = STR_EVT_BUFF_1_DESC.format(EVT_1_SPEED_BOOST)
    eventDuration[EventId.GALE_BLESSING] = EVT_BUFF_1_DURATION
    eventCatalogWeight[EventId.GALE_BLESSING] = EVT_BUFF_1_WEIGHT
    eventCatalogType[EventId.GALE_BLESSING] = EventType.BUFF
    eventCatalogId.append(EventId.GALE_BLESSING)

    eventName[EventId.IRON_BULWARK] = STR_EVT_BUFF_2_TITLE
    eventDesc[EventId.IRON_BULWARK] = STR_EVT_BUFF_2_DESC.format(EVT_2_ARMOR_FLAT, percent(EVT_2_ARMOR_MAXHP_FACTOR), negToPos(EVT_2_DMG_TAKEN))
    eventDuration[EventId.IRON_BULWARK] = EVT_BUFF_2_DURATION
    eventCatalogWeight[EventId.IRON_BULWARK] = EVT_BUFF_2_WEIGHT
    eventCatalogType[EventId.IRON_BULWARK] = EventType.BUFF
    eventCatalogId.append(EventId.IRON_BULWARK)

    eventName[EventId.LIFE_SPRING] = STR_EVT_BUFF_4_TITLE
    eventDesc[EventId.LIFE_SPRING] = STR_EVT_BUFF_4_DESC.format(percent(EVT_4_HEALTH_MAXHP_FACTOR), percent(EVT_4_HEAL_PERCENT))
    eventDuration[EventId.LIFE_SPRING] = EVT_BUFF_4_DURATION
    eventCatalogWeight[EventId.LIFE_SPRING] = EVT_BUFF_4_WEIGHT
    eventCatalogType[EventId.LIFE_SPRING] = EventType.BUFF
    eventCatalogId.append(EventId.LIFE_SPRING)

    eventName[EventId.BLACK_FANS_ASSAULT] = STR_EVT_BUFF_5_TITLE
    eventDesc[EventId.BLACK_FANS_ASSAULT] = STR_EVT_BUFF_5_DESC.format(EVT_5_BASE_HEALTH, percent(EVT_5_HEALTH_MAXHP_PERCENT), EVT_5_SPEED_BOOST)
    eventDuration[EventId.BLACK_FANS_ASSAULT] = EVT_BUFF_5_DURATION
    eventCatalogWeight[EventId.BLACK_FANS_ASSAULT] = EVT_BUFF_5_WEIGHT
    eventCatalogType[EventId.BLACK_FANS_ASSAULT] = EventType.BUFF
    eventCatalogId.append(EventId.BLACK_FANS_ASSAULT)

    eventName[EventId.SPEED_STACK] = STR_EVT_BUFF_6_TITLE
    eventDesc[EventId.SPEED_STACK] = STR_EVT_BUFF_6_DESC.format(EVT_6_SPEED_INC_PER_SEC)
    eventDuration[EventId.SPEED_STACK] = EVT_BUFF_6_DURATION
    eventCatalogWeight[EventId.SPEED_STACK] = EVT_BUFF_6_WEIGHT
    eventCatalogType[EventId.SPEED_STACK] = EventType.BUFF
    eventCatalogId.append(EventId.SPEED_STACK)

    eventName[EventId.FLESH_REGEN] = STR_EVT_BUFF_7_TITLE
    eventDesc[EventId.FLESH_REGEN] = STR_EVT_BUFF_7_DESC.format(EVT_7_BASE_HEALTH, percent(EVT_7_HEALTH_PERCENT), EVT_7_REGEN_INTERVAL)
    eventDuration[EventId.FLESH_REGEN] = EVT_BUFF_7_DURATION
    eventCatalogWeight[EventId.FLESH_REGEN] = EVT_BUFF_7_WEIGHT
    eventCatalogType[EventId.FLESH_REGEN] = EventType.BUFF
    eventCatalogId.append(EventId.FLESH_REGEN)

    eventName[EventId.HEART_OF_STEEL] = STR_EVT_BUFF_8_TITLE
    eventDesc[EventId.HEART_OF_STEEL] = STR_EVT_BUFF_8_DESC.format(EVT_8_HP_LAYER_PER_DEATH, EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[EventId.HEART_OF_STEEL] = EVT_BUFF_8_DURATION
    eventCatalogWeight[EventId.HEART_OF_STEEL] = EVT_BUFF_8_WEIGHT
    eventCatalogType[EventId.HEART_OF_STEEL] = EventType.BUFF
    eventCatalogId.append(EventId.HEART_OF_STEEL)

    # ================================================
    # Pack 1: Debuffs
    # ================================================
    eventName[EventId.GRAVITY_ANOMALY] = STR_EVT_DEBUFF_0_TITLE
    eventDesc[EventId.GRAVITY_ANOMALY] = STR_EVT_DEBUFF_0_DESC.format(EVT_DEBUFF_0_GRAVITY)
    eventDuration[EventId.GRAVITY_ANOMALY] = EVT_DEBUFF_0_DURATION
    eventCatalogWeight[EventId.GRAVITY_ANOMALY] = EVT_DEBUFF_0_WEIGHT
    eventCatalogType[EventId.GRAVITY_ANOMALY] = EventType.DEBUFF
    eventCatalogId.append(EventId.GRAVITY_ANOMALY)

    eventName[EventId.EMP] = STR_EVT_DEBUFF_1_TITLE
    eventDesc[EventId.EMP] = STR_EVT_DEBUFF_1_DESC
    eventDuration[EventId.EMP] = EVT_DEBUFF_1_HACK_DURATION
    eventCatalogWeight[EventId.EMP] = EVT_DEBUFF_1_WEIGHT
    eventCatalogType[EventId.EMP] = EventType.DEBUFF
    eventCatalogId.append(EventId.EMP)

    eventName[EventId.SACRIFICE] = STR_EVT_DEBUFF_2_TITLE
    eventDesc[EventId.SACRIFICE] = STR_EVT_DEBUFF_2_DESC.format(percent(EVT_DEBUFF_2_DMG_PERCENT))
    eventDuration[EventId.SACRIFICE] = EVT_DEBUFF_2_DURATION
    eventCatalogWeight[EventId.SACRIFICE] = EVT_DEBUFF_2_WEIGHT
    eventCatalogType[EventId.SACRIFICE] = EventType.DEBUFF
    eventCatalogId.append(EventId.SACRIFICE)

    eventName[EventId.VULNERABLE] = STR_EVT_DEBUFF_3_TITLE
    eventDesc[EventId.VULNERABLE] = STR_EVT_DEBUFF_3_DESC.format(EVT_DEBUFF_3_DMG_TAKEN)
    eventDuration[EventId.VULNERABLE] = EVT_DEBUFF_3_DURATION
    eventCatalogWeight[EventId.VULNERABLE] = EVT_DEBUFF_3_WEIGHT
    eventCatalogType[EventId.VULNERABLE] = EventType.DEBUFF
    eventCatalogId.append(EventId.VULNERABLE)

    eventName[EventId.SPEED_LIMIT_40] = STR_EVT_DEBUFF_4_TITLE
    eventDesc[EventId.SPEED_LIMIT_40] = STR_EVT_DEBUFF_4_DESC.format(EVT_DEBUFF_4_DMG_BASE, percent(EVT_DEBUFF_4_DMG_PERCENT))
    eventDuration[EventId.SPEED_LIMIT_40] = EVT_DEBUFF_4_DURATION
    eventCatalogWeight[EventId.SPEED_LIMIT_40] = EVT_DEBUFF_4_WEIGHT
    eventCatalogType[EventId.SPEED_LIMIT_40] = EventType.DEBUFF
    eventCatalogId.append(EventId.SPEED_LIMIT_40)

    # ================================================
    # Pack 1: Mechanics
    # ================================================
    eventName[EventId.GAMBLER] = STR_EVT_MECH_1_TITLE
    eventDesc[EventId.GAMBLER] = STR_EVT_MECH_1_DESC.format(Button.RELOAD, EVT_MECH_1_WIN_RATE, EVT_MECH_1_REWARD_STACKS, EVT_MECH_1_STAKE)
    eventDuration[EventId.GAMBLER] = EVT_MECH_1_DURATION
    eventCatalogWeight[EventId.GAMBLER] = EVT_MECH_1_WEIGHT
    eventCatalogType[EventId.GAMBLER] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER)

    eventName[EventId.MINI_FORM] = STR_EVT_MECH_2_TITLE
    eventDesc[EventId.MINI_FORM] = STR_EVT_MECH_2_DESC.format(percent(1 - EVT_MECH_2_MODEL_SCALE), percent(1 - EVT_MECH_2_HP_SCALE), EVT_MECH_2_SPEED_BOOST)
    eventDuration[EventId.MINI_FORM] = EVT_MECH_2_DURATION
    eventCatalogWeight[EventId.MINI_FORM] = EVT_MECH_2_WEIGHT
    eventCatalogType[EventId.MINI_FORM] = EventType.MECH
    eventCatalogId.append(EventId.MINI_FORM)

    eventName[EventId.STEALTH_CROUCH] = STR_EVT_MECH_3_TITLE
    eventDesc[EventId.STEALTH_CROUCH] = STR_EVT_MECH_3_DESC.format(percent(EVT_MECH_3_HP_COST_RATIO), EVT_MECH_3_SPEED_BOOST)
    eventDuration[EventId.STEALTH_CROUCH] = EVT_MECH_3_DURATION
    eventCatalogWeight[EventId.STEALTH_CROUCH] = EVT_MECH_3_WEIGHT
    eventCatalogType[EventId.STEALTH_CROUCH] = EventType.MECH
    eventCatalogId.append(EventId.STEALTH_CROUCH)

    # ================================================
    # Pack 2: Buffs
    # ================================================
    eventName[EventId.DEATH_DELAY] = STR_EVT_BUFF_9_TITLE
    eventDesc[EventId.DEATH_DELAY] = STR_EVT_BUFF_9_DESC
    eventDuration[EventId.DEATH_DELAY] = EVT_BUFF_9_DURATION
    eventCatalogWeight[EventId.DEATH_DELAY] = EVT_BUFF_9_WEIGHT
    eventCatalogType[EventId.DEATH_DELAY] = EventType.BUFF
    eventCatalogId.append(EventId.DEATH_DELAY)

    eventName[EventId.KONAMI_CODE] = STR_EVT_BUFF_11_TITLE
    eventDesc[EventId.KONAMI_CODE] = STR_EVT_BUFF_11_DESC
    eventDuration[EventId.KONAMI_CODE] = EVT_BUFF_11_DURATION
    eventCatalogWeight[EventId.KONAMI_CODE] = EVT_BUFF_11_WEIGHT
    eventCatalogType[EventId.KONAMI_CODE] = EventType.BUFF
    eventCatalogId.append(EventId.KONAMI_CODE)

    eventName[EventId.SYMBIOSIS] = STR_EVT_BUFF_10_TITLE
    eventDesc[EventId.SYMBIOSIS] = STR_EVT_BUFF_10_DESC.format(Button.CROUCH)
    eventDuration[EventId.SYMBIOSIS] = EVT_BUFF_10_DURATION
    eventCatalogWeight[EventId.SYMBIOSIS] = EVT_BUFF_10_WEIGHT
    eventCatalogType[EventId.SYMBIOSIS] = EventType.BUFF
    eventCatalogId.append(EventId.SYMBIOSIS)

    eventName[EventId.PHOTON_SHIELD] = STR_EVT_BUFF_12_TITLE
    eventDesc[EventId.PHOTON_SHIELD] = STR_EVT_BUFF_12_DESC.format(EVT_12_BASE_SHIELD, percent(EVT_12_SHIELD_PERCENT))
    eventDuration[EventId.PHOTON_SHIELD] = EVT_BUFF_12_DURATION
    eventCatalogWeight[EventId.PHOTON_SHIELD] = EVT_BUFF_12_WEIGHT
    eventCatalogType[EventId.PHOTON_SHIELD] = EventType.BUFF
    eventCatalogId.append(EventId.PHOTON_SHIELD)

    # ================================================
    # Pack 2: Debuffs
    # ================================================
    eventName[EventId.GRAVITY_PULL] = STR_EVT_DEBUFF_5_TITLE
    eventDesc[EventId.GRAVITY_PULL] = STR_EVT_DEBUFF_5_DESC.format(EVT_DEBUFF_5_SPEED_REDUCTION)
    eventDuration[EventId.GRAVITY_PULL] = EVT_DEBUFF_5_DURATION
    eventCatalogWeight[EventId.GRAVITY_PULL] = EVT_DEBUFF_5_WEIGHT
    eventCatalogType[EventId.GRAVITY_PULL] = EventType.DEBUFF
    eventCatalogId.append(EventId.GRAVITY_PULL)

    eventName[EventId.OSTEOPOROSIS] = STR_EVT_DEBUFF_6_TITLE
    eventDesc[EventId.OSTEOPOROSIS] = STR_EVT_DEBUFF_6_DESC.format(negToPos(EVT_DEBUFF_6_MAX_SPEED_DEC))
    eventDuration[EventId.OSTEOPOROSIS] = EVT_DEBUFF_6_DURATION
    eventCatalogWeight[EventId.OSTEOPOROSIS] = EVT_DEBUFF_6_WEIGHT
    eventCatalogType[EventId.OSTEOPOROSIS] = EventType.DEBUFF
    eventCatalogId.append(EventId.OSTEOPOROSIS)

    eventName[EventId.EMP_PROMAX] = STR_EVT_DEBUFF_7_TITLE
    eventDesc[EventId.EMP_PROMAX] = STR_EVT_DEBUFF_7_DESC.format(EVT_DEBUFF_7_RADIUS)
    eventDuration[EventId.EMP_PROMAX] = EVT_DEBUFF_7_DURATION
    eventCatalogWeight[EventId.EMP_PROMAX] = EVT_DEBUFF_7_WEIGHT
    eventCatalogType[EventId.EMP_PROMAX] = EventType.DEBUFF
    eventCatalogId.append(EventId.EMP_PROMAX)

    eventName[EventId.ENERGY_LEAK] = STR_EVT_DEBUFF_8_TITLE
    eventDesc[EventId.ENERGY_LEAK] = STR_EVT_DEBUFF_8_DESC.format(percent(EVT_DEBUFF_8_DMG_PERCENT))
    eventDuration[EventId.ENERGY_LEAK] = EVT_DEBUFF_8_DURATION
    eventCatalogWeight[EventId.ENERGY_LEAK] = EVT_DEBUFF_8_WEIGHT
    eventCatalogType[EventId.ENERGY_LEAK] = EventType.DEBUFF
    eventCatalogId.append(EventId.ENERGY_LEAK)

    eventName[EventId.SHARE_THE_PAIN] = STR_EVT_DEBUFF_9_TITLE
    eventDesc[EventId.SHARE_THE_PAIN] = STR_EVT_DEBUFF_9_DESC.format(percent(EVT_DEBUFF_9_DMG_FACTOR))
    eventDuration[EventId.SHARE_THE_PAIN] = EVT_DEBUFF_9_DURATION
    eventCatalogWeight[EventId.SHARE_THE_PAIN] = EVT_DEBUFF_9_WEIGHT
    eventCatalogType[EventId.SHARE_THE_PAIN] = EventType.DEBUFF
    eventCatalogId.append(EventId.SHARE_THE_PAIN)

    eventName[EventId.FEAST_FRENZY] = STR_EVT_DEBUFF_10_TITLE
    eventDesc[EventId.FEAST_FRENZY] = STR_EVT_DEBUFF_10_DESC.format(EVT_DEBUFF_10_BERSERK_ADD)
    eventDuration[EventId.FEAST_FRENZY] = EVT_DEBUFF_10_DURATION
    eventCatalogWeight[EventId.FEAST_FRENZY] = EVT_DEBUFF_10_WEIGHT
    eventCatalogType[EventId.FEAST_FRENZY] = EventType.DEBUFF
    eventCatalogId.append(EventId.FEAST_FRENZY)

    eventName[EventId.POWERLESS_SPOUSE] = STR_EVT_DEBUFF_11_TITLE
    eventDesc[EventId.POWERLESS_SPOUSE] = STR_EVT_DEBUFF_11_DESC.format(EVT_DEBUFF_11_DELAY, EVT_DEBUFF_11_KNOCKDOWN_DURATION)
    eventDuration[EventId.POWERLESS_SPOUSE] = EVT_DEBUFF_11_DURATION
    eventCatalogWeight[EventId.POWERLESS_SPOUSE] = EVT_DEBUFF_11_WEIGHT
    eventCatalogType[EventId.POWERLESS_SPOUSE] = EventType.DEBUFF
    eventCatalogId.append(EventId.POWERLESS_SPOUSE)

    # ================================================
    # Pack 2: Mechanics
    # ================================================
    eventName[EventId.BRAKE_FAILURE] = STR_EVT_MECH_4_TITLE
    eventDesc[EventId.BRAKE_FAILURE] = STR_EVT_MECH_4_DESC.format(100 + EVT_MECH_4_MAX_SPEED)
    eventDuration[EventId.BRAKE_FAILURE] = EVT_MECH_4_DURATION
    eventCatalogWeight[EventId.BRAKE_FAILURE] = EVT_MECH_4_WEIGHT
    eventCatalogType[EventId.BRAKE_FAILURE] = EventType.MECH
    eventCatalogId.append(EventId.BRAKE_FAILURE)

    # ================================================
    # Pack 3: Buffs
    # ================================================
    eventName[EventId.REGROUP_CALL] = STR_EVT_BUFF_13_TITLE
    eventDesc[EventId.REGROUP_CALL] = STR_EVT_BUFF_13_DESC.format(EVT_13_CHECK_INTERVAL, EVT_13_INVINCIBLE_DURATION)
    eventDuration[EventId.REGROUP_CALL] = EVT_BUFF_13_DURATION
    eventCatalogWeight[EventId.REGROUP_CALL] = EVT_BUFF_13_WEIGHT
    eventCatalogType[EventId.REGROUP_CALL] = EventType.BUFF
    eventCatalogId.append(EventId.REGROUP_CALL)

    eventName[EventId.WILL_TO_WIN] = STR_EVT_BUFF_14_TITLE
    eventDesc[EventId.WILL_TO_WIN] = STR_EVT_BUFF_14_DESC.format(percent(EVT_14_TRIGGER_HP_PERCENT), EVT_14_INVINCIBLE_DURATION)
    eventDuration[EventId.WILL_TO_WIN] = EVT_BUFF_14_DURATION
    eventCatalogWeight[EventId.WILL_TO_WIN] = EVT_BUFF_14_WEIGHT
    eventCatalogType[EventId.WILL_TO_WIN] = EventType.BUFF
    eventCatalogId.append(EventId.WILL_TO_WIN)

    eventName[EventId.PHEIDIPPIDES_TRIAL] = STR_EVT_BUFF_15_TITLE
    eventDesc[EventId.PHEIDIPPIDES_TRIAL] = STR_EVT_BUFF_15_DESC.format(EVT_15_DISTANCE_GOAL, EVT_15_REWARD_SPEED)
    eventDuration[EventId.PHEIDIPPIDES_TRIAL] = EVT_BUFF_15_DURATION
    eventCatalogWeight[EventId.PHEIDIPPIDES_TRIAL] = EVT_BUFF_15_WEIGHT
    eventCatalogType[EventId.PHEIDIPPIDES_TRIAL] = EventType.BUFF
    eventCatalogId.append(EventId.PHEIDIPPIDES_TRIAL)

    eventName[EventId.HEART_OF_STEEL_PRO] = STR_EVT_BUFF_16_TITLE
    eventDesc[EventId.HEART_OF_STEEL_PRO] = STR_EVT_BUFF_16_DESC.format(EVT_16_HP_GAIN_FLAT, EVT_16_HP_MULTIPLIER)
    eventDuration[EventId.HEART_OF_STEEL_PRO] = EVT_BUFF_16_DURATION
    eventCatalogWeight[EventId.HEART_OF_STEEL_PRO] = EVT_BUFF_16_WEIGHT
    eventCatalogType[EventId.HEART_OF_STEEL_PRO] = EventType.BUFF
    eventCatalogId.append(EventId.HEART_OF_STEEL_PRO)

    eventName[EventId.ULT_MOMENTUM] = STR_EVT_BUFF_18_TITLE
    eventDesc[EventId.ULT_MOMENTUM] = STR_EVT_BUFF_18_DESC.format(EVT_18_DMG_REDUCTION_DURING_ULT)
    eventDuration[EventId.ULT_MOMENTUM] = EVT_BUFF_18_DURATION
    eventCatalogWeight[EventId.ULT_MOMENTUM] = EVT_BUFF_18_WEIGHT
    eventCatalogType[EventId.ULT_MOMENTUM] = EventType.BUFF
    eventCatalogId.append(EventId.ULT_MOMENTUM)
 
    # ================================================
    # Pack 3: Debuffs
    # ================================================
    eventName[EventId.HALVED] = STR_EVT_DEBUFF_13_TITLE
    eventDesc[EventId.HALVED] = STR_EVT_DEBUFF_13_DESC.format(EVT_DEBUFF_13_INTERVAL, percent(EVT_DEBUFF_13_DAMAGE_PERCENT), percent(EVT_DEBUFF_13_EXECUTE_THRESHOLD))
    eventDuration[EventId.HALVED] = EVT_DEBUFF_13_DURATION
    eventCatalogWeight[EventId.HALVED] = EVT_DEBUFF_13_WEIGHT
    eventCatalogType[EventId.HALVED] = EventType.DEBUFF
    eventCatalogId.append(EventId.HALVED)

    eventName[EventId.SELFLESS_GIVEAWAY] = STR_EVT_DEBUFF_14_TITLE
    eventDesc[EventId.SELFLESS_GIVEAWAY] = STR_EVT_DEBUFF_14_DESC.format(EVT_DEBUFF_14_STACKS_TAKE)
    eventDuration[EventId.SELFLESS_GIVEAWAY] = EVT_DEBUFF_14_DURATION
    eventCatalogWeight[EventId.SELFLESS_GIVEAWAY] = EVT_DEBUFF_14_WEIGHT
    eventCatalogType[EventId.SELFLESS_GIVEAWAY] = EventType.DEBUFF
    eventCatalogId.append(EventId.SELFLESS_GIVEAWAY)

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    eventName[EventId.EXTREME_CHALLENGE] = STR_EVT_MECH_0_TITLE
    eventDesc[EventId.EXTREME_CHALLENGE] = STR_EVT_MECH_0_DESC.format(negToPos(EVT_MECH_0_DMG_TAKEN), percent(EVT_MECH_0_HP_PERCENT))
    eventDuration[EventId.EXTREME_CHALLENGE] = EVT_MECH_0_DURATION
    eventCatalogWeight[EventId.EXTREME_CHALLENGE] = EVT_MECH_0_WEIGHT
    eventCatalogType[EventId.EXTREME_CHALLENGE] = EventType.MECH
    eventCatalogId.append(EventId.EXTREME_CHALLENGE)

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    eventName[EventId.JUMP_THRUST] = STR_EVT_MECH_5_TITLE
    eventDesc[EventId.JUMP_THRUST] = STR_EVT_MECH_5_DESC.format(Button.JUMP, negToPos(EVT_MECH_5_DMG_TAKEN))
    eventDuration[EventId.JUMP_THRUST] = EVT_MECH_5_DURATION
    eventCatalogWeight[EventId.JUMP_THRUST] = EVT_MECH_5_WEIGHT
    eventCatalogType[EventId.JUMP_THRUST] = EventType.MECH
    eventCatalogId.append(EventId.JUMP_THRUST)

    eventName[EventId.GAMBLER_SPEED_CHALLENGE] = STR_EVT_MECH_6_TITLE
    eventDesc[EventId.GAMBLER_SPEED_CHALLENGE] = STR_EVT_MECH_6_DESC.format(Button.RELOAD, EVT_MECH_6_HEARTSTEEL_COST, EVT_MECH_6_PROB_LOSE_NORMAL, EVT_MECH_6_VAL_NORMAL, EVT_MECH_6_VAL_NORMAL_LOSS, 100 - EVT_MECH_6_PROB_LOSE_NORMAL, EVT_MECH_6_VAL_RARE, EVT_MECH_6_VAL_RARE_LOSS)
    eventDuration[EventId.GAMBLER_SPEED_CHALLENGE] = EVT_MECH_6_DURATION
    eventCatalogWeight[EventId.GAMBLER_SPEED_CHALLENGE] = EVT_MECH_6_WEIGHT
    eventCatalogType[EventId.GAMBLER_SPEED_CHALLENGE] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_SPEED_CHALLENGE)

    # ================================================
    # Pack 4: Buffs
    # ================================================
    eventName[EventId.PHASE_SURGE] = STR_EVT_BUFF_19_TITLE
    eventDesc[EventId.PHASE_SURGE] = STR_EVT_BUFF_19_DESC.format(EVT_19_SPEED_BOOST, EVT_19_SPEED_BONUS_PER_TRIGGER)
    eventDuration[EventId.PHASE_SURGE] = EVT_BUFF_19_DURATION
    eventCatalogWeight[EventId.PHASE_SURGE] = EVT_BUFF_19_WEIGHT
    eventCatalogType[EventId.PHASE_SURGE] = EventType.BUFF
    eventCatalogId.append(EventId.PHASE_SURGE)

    eventName[EventId.BODYGUARD] = STR_EVT_BUFF_20_TITLE
    eventDesc[EventId.BODYGUARD] = STR_EVT_BUFF_20_DESC
    eventDuration[EventId.BODYGUARD] = EVT_BUFF_20_DURATION
    eventCatalogWeight[EventId.BODYGUARD] = EVT_BUFF_20_WEIGHT
    eventCatalogType[EventId.BODYGUARD] = EventType.BUFF
    eventCatalogId.append(EventId.BODYGUARD)

    eventName[EventId.MARTYR_TRIAL] = STR_EVT_BUFF_21_TITLE
    eventDesc[EventId.MARTYR_TRIAL] = STR_EVT_BUFF_21_DESC.format(negToPos(EVT_21_REWARD_DMG_PERMA))
    eventDuration[EventId.MARTYR_TRIAL] = EVT_BUFF_21_DURATION
    eventCatalogWeight[EventId.MARTYR_TRIAL] = EVT_BUFF_21_WEIGHT
    eventCatalogType[EventId.MARTYR_TRIAL] = EventType.BUFF
    eventCatalogId.append(EventId.MARTYR_TRIAL)

    eventName[EventId.F5_REFRESH] = STR_EVT_BUFF_24_TITLE
    eventDesc[EventId.F5_REFRESH] = STR_EVT_BUFF_24_DESC.format(EVT_24_REFRESH_INTERVAL)
    eventDuration[EventId.F5_REFRESH] = EVT_BUFF_24_DURATION
    eventCatalogWeight[EventId.F5_REFRESH] = EVT_BUFF_24_WEIGHT
    eventCatalogType[EventId.F5_REFRESH] = EventType.BUFF
    eventCatalogId.append(EventId.F5_REFRESH)

    eventName[EventId.HEALING_TOWER_PROMAX] = STR_EVT_BUFF_25_TITLE
    eventDesc[EventId.HEALING_TOWER_PROMAX] = STR_EVT_BUFF_25_DESC.format(EVT_25_HEAL_FLAT, percent(EVT_25_HEAL_MAXHP_FACTOR))
    eventDuration[EventId.HEALING_TOWER_PROMAX] = EVT_BUFF_25_DURATION
    eventCatalogWeight[EventId.HEALING_TOWER_PROMAX] = EVT_BUFF_25_WEIGHT
    eventCatalogType[EventId.HEALING_TOWER_PROMAX] = EventType.BUFF
    eventCatalogId.append(EventId.HEALING_TOWER_PROMAX)

    # ================================================
    # Pack 4: Debuffs
    # ================================================
    eventName[EventId.KEEP_DISTANCE_AURA] = STR_EVT_DEBUFF_15_TITLE
    eventDesc[EventId.KEEP_DISTANCE_AURA] = STR_EVT_DEBUFF_15_DESC
    eventDuration[EventId.KEEP_DISTANCE_AURA] = EVT_DEBUFF_15_DURATION
    eventCatalogWeight[EventId.KEEP_DISTANCE_AURA] = EVT_DEBUFF_15_WEIGHT
    eventCatalogType[EventId.KEEP_DISTANCE_AURA] = EventType.DEBUFF
    eventCatalogId.append(EventId.KEEP_DISTANCE_AURA)

    eventName[EventId.MOON_ROCKET] = STR_EVT_DEBUFF_20_TITLE
    eventDesc[EventId.MOON_ROCKET] = STR_EVT_DEBUFF_20_DESC
    eventDuration[EventId.MOON_ROCKET] = EVT_DEBUFF_20_DURATION
    eventCatalogWeight[EventId.MOON_ROCKET] = EVT_DEBUFF_20_WEIGHT
    eventCatalogType[EventId.MOON_ROCKET] = EventType.DEBUFF
    eventCatalogId.append(EventId.MOON_ROCKET)

    # ================================================
    # Pack 4: Mechanics
    # ================================================
    eventName[EventId.CHEAT_CARD_COUNTING] = STR_EVT_MECH_7_TITLE
    eventDesc[EventId.CHEAT_CARD_COUNTING] = STR_EVT_MECH_7_DESC.format(Button.RELOAD, EVT_MECH_7_HEART_STEEL_COST, EVT_MECH_7_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[EventId.CHEAT_CARD_COUNTING] = EVT_MECH_7_DURATION
    eventCatalogWeight[EventId.CHEAT_CARD_COUNTING] = EVT_MECH_7_WEIGHT
    eventCatalogType[EventId.CHEAT_CARD_COUNTING] = EventType.MECH
    eventCatalogId.append(EventId.CHEAT_CARD_COUNTING)

    eventName[EventId.GAMBLER_SHORT_INVESTMENT] = STR_EVT_MECH_8_TITLE
    eventDesc[EventId.GAMBLER_SHORT_INVESTMENT] = STR_EVT_MECH_8_DESC.format(Button.RELOAD, EVT_MECH_8_CONTRACT_EVENTS, EVT_MECH_8_WIN_CHANCE, EVT_MECH_8_REWARD_STACKS)
    eventDuration[EventId.GAMBLER_SHORT_INVESTMENT] = EVT_MECH_8_DURATION
    eventCatalogWeight[EventId.GAMBLER_SHORT_INVESTMENT] = EVT_MECH_8_WEIGHT
    eventCatalogType[EventId.GAMBLER_SHORT_INVESTMENT] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_SHORT_INVESTMENT)

    eventName[EventId.CHEAT_SKIP_HERO] = STR_EVT_MECH_10_TITLE
    eventDesc[EventId.CHEAT_SKIP_HERO] = STR_EVT_MECH_10_DESC.format(Button.RELOAD)
    eventDuration[EventId.CHEAT_SKIP_HERO] = EVT_MECH_10_DURATION
    eventCatalogWeight[EventId.CHEAT_SKIP_HERO] = EVT_MECH_10_WEIGHT
    eventCatalogType[EventId.CHEAT_SKIP_HERO] = EventType.MECH
    eventCatalogId.append(EventId.CHEAT_SKIP_HERO)

    eventName[EventId.NESTING_DOLL] = STR_EVT_MECH_11_TITLE
    eventDesc[EventId.NESTING_DOLL] = STR_EVT_MECH_11_DESC.format(EVT_MECH_11_RESURRECT_DELAY, percent(EVT_MECH_11_SIZE_STEP), EVT_MECH_11_SPEED_STEP)
    eventDuration[EventId.NESTING_DOLL] = EVT_MECH_11_DURATION
    eventCatalogWeight[EventId.NESTING_DOLL] = EVT_MECH_11_WEIGHT
    eventCatalogType[EventId.NESTING_DOLL] = EventType.MECH
    eventCatalogId.append(EventId.NESTING_DOLL)

    eventName[EventId.GAMBLER_LONG_INVESTMENT] = STR_EVT_MECH_12_TITLE
    eventDesc[EventId.GAMBLER_LONG_INVESTMENT] = STR_EVT_MECH_12_DESC.format(Button.RELOAD, EVT_MECH_12_CONTRACT_EVENTS, EVT_MECH_12_WIN_CHANCE, EVT_MECH_12_REWARD_STACKS)
    eventDuration[EventId.GAMBLER_LONG_INVESTMENT] = EVT_MECH_12_DURATION
    eventCatalogWeight[EventId.GAMBLER_LONG_INVESTMENT] = EVT_MECH_12_WEIGHT
    eventCatalogType[EventId.GAMBLER_LONG_INVESTMENT] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_LONG_INVESTMENT)

    eventName[EventId.VALKYRIE_DESCENT] = STR_EVT_MECH_13_TITLE
    eventDesc[EventId.VALKYRIE_DESCENT] = STR_EVT_MECH_13_DESC.format(EVT_MECH_13_SIZE_HEALTH * 100, percent(EVT_MECH_13_HEAL_SMOOTHING))
    eventDuration[EventId.VALKYRIE_DESCENT] = EVT_MECH_13_DURATION
    eventCatalogWeight[EventId.VALKYRIE_DESCENT] = EVT_MECH_13_WEIGHT
    eventCatalogType[EventId.VALKYRIE_DESCENT] = EventType.MECH
    eventCatalogId.append(EventId.VALKYRIE_DESCENT)

    eventName[EventId.TRINITY_SSR] = STR_EVT_MECH_14_TITLE
    eventDesc[EventId.TRINITY_SSR] = STR_EVT_MECH_14_DESC.format(100 / EVT_MECH_14_DMG_REDUCE_DIVISOR, EVT_MECH_14_SPEED_FACTOR, EVT_MECH_14_INTERVAL / EVT_MECH_14_HEART_STEEL_PER_TICK)
    eventDuration[EventId.TRINITY_SSR] = EVT_MECH_14_DURATION
    eventCatalogWeight[EventId.TRINITY_SSR] = EVT_MECH_14_WEIGHT
    eventCatalogType[EventId.TRINITY_SSR] = EventType.MECH
    eventCatalogId.append(EventId.TRINITY_SSR)

    eventName[EventId.VAMPIRE] = STR_EVT_MECH_18_TITLE
    eventDesc[EventId.VAMPIRE] = STR_EVT_MECH_18_DESC.format(EVT_MECH_18_DRAIN_FLAT, percent(EVT_MECH_18_DRAIN_MAXHP_FACTOR), EVT_MECH_18_KILL_HEAL_PERMA)
    eventDuration[EventId.VAMPIRE] = EVT_MECH_18_DURATION
    eventCatalogWeight[EventId.VAMPIRE] = EVT_MECH_18_WEIGHT
    eventCatalogType[EventId.VAMPIRE] = EventType.MECH
    eventCatalogId.append(EventId.VAMPIRE)

    eventName[EventId.THIEF] = STR_EVT_MECH_19_TITLE
    eventDesc[EventId.THIEF] = STR_EVT_MECH_19_DESC.format(Button.RELOAD)
    eventDuration[EventId.THIEF] = EVT_MECH_19_DURATION
    eventCatalogWeight[EventId.THIEF] = EVT_MECH_19_WEIGHT
    eventCatalogType[EventId.THIEF] = EventType.MECH
    eventCatalogId.append(EventId.THIEF)

    eventName[EventId.GAMBLER_HELPFUL_SOUL] = STR_EVT_MECH_20_TITLE
    eventDesc[EventId.GAMBLER_HELPFUL_SOUL] = STR_EVT_MECH_20_DESC.format(Button.RELOAD, EVT_MECH_20_WIN_RATE, percent(EVT_MECH_20_HEAL_MAXHP_FACTOR), 100 - EVT_MECH_20_WIN_RATE)
    eventDuration[EventId.GAMBLER_HELPFUL_SOUL] = EVT_MECH_20_DURATION
    eventCatalogWeight[EventId.GAMBLER_HELPFUL_SOUL] = EVT_MECH_20_WEIGHT
    eventCatalogType[EventId.GAMBLER_HELPFUL_SOUL] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_HELPFUL_SOUL)

    eventName[EventId.CHEAT_BACKROOM_DEAL] = STR_EVT_MECH_22_TITLE
    eventDesc[EventId.CHEAT_BACKROOM_DEAL] = STR_EVT_MECH_22_DESC.format(Button.RELOAD, EVT_MECH_22_HEART_STEEL_COST, EVT_MECH_22_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[EventId.CHEAT_BACKROOM_DEAL] = EVT_MECH_22_DURATION
    eventCatalogWeight[EventId.CHEAT_BACKROOM_DEAL] = EVT_MECH_22_WEIGHT
    eventCatalogType[EventId.CHEAT_BACKROOM_DEAL] = EventType.MECH
    eventCatalogId.append(EventId.CHEAT_BACKROOM_DEAL)

    eventName[EventId.MIRROR_INVERSION] = STR_EVT_MECH_23_TITLE
    eventDesc[EventId.MIRROR_INVERSION] = STR_EVT_MECH_23_DESC.format(Button.RELOAD)
    eventDuration[EventId.MIRROR_INVERSION] = EVT_MECH_23_DURATION
    eventCatalogWeight[EventId.MIRROR_INVERSION] = EVT_MECH_23_WEIGHT
    eventCatalogType[EventId.MIRROR_INVERSION] = EventType.MECH
    eventCatalogId.append(EventId.MIRROR_INVERSION)

    eventName[EventId.GAMBLER_WINNER_TAKE_ALL] = STR_EVT_MECH_24_TITLE
    eventDesc[EventId.GAMBLER_WINNER_TAKE_ALL] = STR_EVT_MECH_24_DESC.format(Button.RELOAD, percent(EVT_MECH_24_STAKE_RATIO), EVT_MECH_24_WIN_RATE)
    eventDuration[EventId.GAMBLER_WINNER_TAKE_ALL] = EVT_MECH_24_DURATION
    eventCatalogWeight[EventId.GAMBLER_WINNER_TAKE_ALL] = EVT_MECH_24_WEIGHT
    eventCatalogType[EventId.GAMBLER_WINNER_TAKE_ALL] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_WINNER_TAKE_ALL)

    # ================================================
    # Pack 5: Buffs
    # ================================================
    eventName[EventId.MAGIC_MASTER] = STR_EVT_BUFF_29_TITLE
    eventDesc[EventId.MAGIC_MASTER] = STR_EVT_BUFF_29_DESC.format(EVT_29_SPEED_BOOST)
    eventDuration[EventId.MAGIC_MASTER] = EVT_BUFF_29_DURATION
    eventCatalogWeight[EventId.MAGIC_MASTER] = EVT_BUFF_29_WEIGHT
    eventCatalogType[EventId.MAGIC_MASTER] = EventType.BUFF
    eventCatalogId.append(EventId.MAGIC_MASTER)

    eventName[EventId.DIVINE_REINFORCEMENT] = STR_EVT_BUFF_30_TITLE
    eventDesc[EventId.DIVINE_REINFORCEMENT] = STR_EVT_BUFF_30_DESC.format(Button.RELOAD, EVT_30_HEAL_FLAT, percent(EVT_30_HEAL_MAXHP_FACTOR), EVT_30_COOLDOWN)
    eventDuration[EventId.DIVINE_REINFORCEMENT] = EVT_BUFF_30_DURATION
    eventCatalogWeight[EventId.DIVINE_REINFORCEMENT] = EVT_BUFF_30_WEIGHT
    eventCatalogType[EventId.DIVINE_REINFORCEMENT] = EventType.BUFF
    eventCatalogId.append(EventId.DIVINE_REINFORCEMENT)

    eventName[EventId.TEMPER_HEART] = STR_EVT_BUFF_31_TITLE
    eventDesc[EventId.TEMPER_HEART] = STR_EVT_BUFF_31_DESC.format(EVT_31_HERO_GOAL_MULTI if (controlJumpPosition != null and portalPosition == null) else EVT_31_HERO_GOAL, EVT_31_STACK_MULTIPLIER, EVT_8_HP_PERCENT_PER_STACK, EVT_8_HP_PERCENT_PER_STACK + EVT_31_PERCENT_PER_STACK_BONUS)
    eventDuration[EventId.TEMPER_HEART] = EVT_BUFF_31_DURATION
    eventCatalogWeight[EventId.TEMPER_HEART] = EVT_BUFF_31_WEIGHT
    eventCatalogType[EventId.TEMPER_HEART] = EventType.BUFF
    eventCatalogId.append(EventId.TEMPER_HEART)

    eventName[EventId.BATTLEFIELD_MEDIC] = STR_EVT_BUFF_32_TITLE
    eventDesc[EventId.BATTLEFIELD_MEDIC] = STR_EVT_BUFF_32_DESC.format(EVT_32_HEAL_BASE, EVT_32_HEAL_PER_PLAYER, EVT_32_REWARD_HEAL_PERMA)
    eventDuration[EventId.BATTLEFIELD_MEDIC] = EVT_BUFF_32_DURATION
    eventCatalogWeight[EventId.BATTLEFIELD_MEDIC] = EVT_BUFF_32_WEIGHT
    eventCatalogType[EventId.BATTLEFIELD_MEDIC] = EventType.BUFF
    eventCatalogId.append(EventId.BATTLEFIELD_MEDIC)

    eventName[EventId.WHERE_YOU_FALL] = STR_EVT_BUFF_33_TITLE
    eventDesc[EventId.WHERE_YOU_FALL] = STR_EVT_BUFF_33_DESC.format(EVT_33_RESCUE_RADIUS, Button.INTERACT, EVT_33_RESCUE_TIME, percent(EVT_33_REVIVE_HEALTH_RATIO))
    eventDuration[EventId.WHERE_YOU_FALL] = EVT_BUFF_33_DURATION
    eventCatalogWeight[EventId.WHERE_YOU_FALL] = EVT_BUFF_33_WEIGHT
    eventCatalogType[EventId.WHERE_YOU_FALL] = EventType.BUFF
    eventCatalogId.append(EventId.WHERE_YOU_FALL)

    eventName[EventId.SHARED_BLESSING] = STR_EVT_BUFF_34_TITLE
    eventDesc[EventId.SHARED_BLESSING] = STR_EVT_BUFF_34_DESC.format(Button.INTERACT, EVT_34_REWARD_STACKS)
    eventDuration[EventId.SHARED_BLESSING] = EVT_BUFF_34_DURATION
    eventCatalogWeight[EventId.SHARED_BLESSING] = EVT_BUFF_34_WEIGHT
    eventCatalogType[EventId.SHARED_BLESSING] = EventType.BUFF
    eventCatalogId.append(EventId.SHARED_BLESSING)
    # ================================================
    # Pack 5: Debuffs
    # ================================================
    eventName[EventId.WAYWARD_NAVIGATION] = STR_EVT_DEBUFF_22_TITLE
    eventDesc[EventId.WAYWARD_NAVIGATION] = STR_EVT_DEBUFF_22_DESC.format(EVT_DEBUFF_22_INTERVAL)
    eventDuration[EventId.WAYWARD_NAVIGATION] = EVT_DEBUFF_22_DURATION
    eventCatalogWeight[EventId.WAYWARD_NAVIGATION] = EVT_DEBUFF_22_WEIGHT
    eventCatalogType[EventId.WAYWARD_NAVIGATION] = EventType.DEBUFF
    eventCatalogId.append(EventId.WAYWARD_NAVIGATION)

    eventName[EventId.OVERWEIGHT_PACK] = STR_EVT_DEBUFF_23_TITLE
    eventDesc[EventId.OVERWEIGHT_PACK] = STR_EVT_DEBUFF_23_DESC.format(EVT_DEBUFF_23_HP_UNIT, EVT_DEBUFF_23_DMG_TAKEN_PER_UNIT)
    eventDuration[EventId.OVERWEIGHT_PACK] = EVT_DEBUFF_23_DURATION
    eventCatalogWeight[EventId.OVERWEIGHT_PACK] = EVT_DEBUFF_23_WEIGHT
    eventCatalogType[EventId.OVERWEIGHT_PACK] = EventType.DEBUFF
    eventCatalogId.append(EventId.OVERWEIGHT_PACK)

    eventName[EventId.ADLERSBRUNN_WRAITH] = STR_EVT_DEBUFF_21_TITLE
    eventDesc[EventId.ADLERSBRUNN_WRAITH] = STR_EVT_DEBUFF_21_DESC.format(EVT_DEBUFF_21_TOTAL_STACK, negToPos(EVT_DEBUFF_21_HEAL_DELTA_PER_STACK), Button.RELOAD, percent(EVT_DEBUFF_21_HP_COST_RATIO))
    eventDuration[EventId.ADLERSBRUNN_WRAITH] = EVT_DEBUFF_21_DURATION
    eventCatalogWeight[EventId.ADLERSBRUNN_WRAITH] = EVT_DEBUFF_21_WEIGHT
    eventCatalogType[EventId.ADLERSBRUNN_WRAITH] = EventType.DEBUFF
    eventCatalogId.append(EventId.ADLERSBRUNN_WRAITH)

    eventName[EventId.STATIC_FIELD] = STR_EVT_DEBUFF_25_TITLE
    eventDesc[EventId.STATIC_FIELD] = STR_EVT_DEBUFF_25_DESC.format(EVT_DEBUFF_25_TRIGGER_RADIUS, EVT_DEBUFF_25_STUN)
    eventDuration[EventId.STATIC_FIELD] = EVT_DEBUFF_25_DURATION
    eventCatalogWeight[EventId.STATIC_FIELD] = EVT_DEBUFF_25_WEIGHT
    eventCatalogType[EventId.STATIC_FIELD] = EventType.DEBUFF
    eventCatalogId.append(EventId.STATIC_FIELD)

    eventName[EventId.BLACK_HOLE] = STR_EVT_DEBUFF_26_TITLE
    eventDesc[EventId.BLACK_HOLE] = STR_EVT_DEBUFF_26_DESC.format(EVT_DEBUFF_26_STOP_RADIUS)
    eventDuration[EventId.BLACK_HOLE] = EVT_DEBUFF_26_DURATION
    eventCatalogWeight[EventId.BLACK_HOLE] = EVT_DEBUFF_26_WEIGHT
    eventCatalogType[EventId.BLACK_HOLE] = EventType.DEBUFF
    eventCatalogId.append(EventId.BLACK_HOLE)

    # ================================================
    # Pack 5: Mechanics
    # ================================================
    eventName[EventId.GAMBLER_DICE_MANIAC] = STR_EVT_MECH_15_TITLE
    eventDesc[EventId.GAMBLER_DICE_MANIAC] = STR_EVT_MECH_15_DESC.format(EVT_MECH_15_DURATION, Button.RELOAD, EVT_INTERACT_HOLD_TIME, EVT_MECH_15_HEART_STEEL_DELTA, EVT_MECH_15_SPEED_DELTA, EVT_MECH_15_DMG_HEAL_DELTA)
    eventDuration[EventId.GAMBLER_DICE_MANIAC] = EVT_MECH_15_DURATION
    eventCatalogWeight[EventId.GAMBLER_DICE_MANIAC] = EVT_MECH_15_WEIGHT
    eventCatalogType[EventId.GAMBLER_DICE_MANIAC] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_DICE_MANIAC)

    eventName[EventId.GAMBLER_HEART_OF_STEEL] = STR_EVT_MECH_16_TITLE
    eventDesc[EventId.GAMBLER_HEART_OF_STEEL] = STR_EVT_MECH_16_DESC.format(Button.RELOAD, EVT_MECH_16_WIN_RATE, EVT_MECH_16_WIN_MULTIPLIER, 100 - EVT_MECH_16_WIN_RATE, percent(EVT_MECH_16_LOSE_RATIO))
    eventDuration[EventId.GAMBLER_HEART_OF_STEEL] = EVT_MECH_16_DURATION
    eventCatalogWeight[EventId.GAMBLER_HEART_OF_STEEL] = EVT_MECH_16_WEIGHT
    eventCatalogType[EventId.GAMBLER_HEART_OF_STEEL] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_HEART_OF_STEEL)

    eventName[EventId.GAMBLER_ALL_IN_ART_5] = STR_EVT_MECH_17_TITLE
    eventDesc[EventId.GAMBLER_ALL_IN_ART_5] = STR_EVT_MECH_17_DESC.format(Button.RELOAD, percent(EVT_MECH_17_STAKE_RATIO), EVT_MECH_17_WIN_RATE, EVT_MECH_17_WIN_MULTIPLIER)
    eventDuration[EventId.GAMBLER_ALL_IN_ART_5] = EVT_MECH_17_DURATION
    eventCatalogWeight[EventId.GAMBLER_ALL_IN_ART_5] = EVT_MECH_17_WEIGHT
    eventCatalogType[EventId.GAMBLER_ALL_IN_ART_5] = EventType.MECH
    eventCatalogId.append(EventId.GAMBLER_ALL_IN_ART_5)

    eventName[EventId.PROPHET] = STR_EVT_MECH_25_TITLE
    eventDesc[EventId.PROPHET] = STR_EVT_MECH_25_DESC
    eventDuration[EventId.PROPHET] = EVT_MECH_25_DURATION
    eventCatalogWeight[EventId.PROPHET] = EVT_MECH_25_WEIGHT
    eventCatalogType[EventId.PROPHET] = EventType.MECH
    eventCatalogId.append(EventId.PROPHET)

    eventName[EventId.EQUIVALENT_EXCHANGE] = STR_EVT_MECH_27_TITLE
    eventDesc[EventId.EQUIVALENT_EXCHANGE] = STR_EVT_MECH_27_DESC.format(Button.RELOAD, EVT_MECH_27_EXCHANGE_STACKS, EVT_MECH_27_EXCHANGE_PERCENT)
    eventDuration[EventId.EQUIVALENT_EXCHANGE] = EVT_MECH_27_DURATION
    eventCatalogWeight[EventId.EQUIVALENT_EXCHANGE] = EVT_MECH_27_WEIGHT
    eventCatalogType[EventId.EQUIVALENT_EXCHANGE] = EventType.MECH
    eventCatalogId.append(EventId.EQUIVALENT_EXCHANGE)

    eventName[EventId.CYCLE_REPLAY] = STR_EVT_MECH_28_TITLE
    eventDesc[EventId.CYCLE_REPLAY] = STR_EVT_MECH_28_DESC.format(Button.RELOAD, EVT_MECH_28_STEEL_COST, EVT_MECH_28_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[EventId.CYCLE_REPLAY] = EVT_MECH_28_DURATION
    eventCatalogWeight[EventId.CYCLE_REPLAY] = EVT_MECH_28_WEIGHT
    eventCatalogType[EventId.CYCLE_REPLAY] = EventType.MECH
    eventCatalogId.append(EventId.CYCLE_REPLAY)

    eventName[EventId.LIFE_PULSE] = STR_EVT_MECH_29_TITLE
    eventDesc[EventId.LIFE_PULSE] = STR_EVT_MECH_29_DESC.format(Button.RELOAD, percent(EVT_MECH_29_HP_COST_PER_SEC), EVT_MECH_29_HEAL_RADIUS, percent(EVT_MECH_29_HEAL_PER_SEC), EVT_MECH_29_RELEASE_COOLDOWN)
    eventDuration[EventId.LIFE_PULSE] = EVT_MECH_29_DURATION
    eventCatalogWeight[EventId.LIFE_PULSE] = EVT_MECH_29_WEIGHT
    eventCatalogType[EventId.LIFE_PULSE] = EventType.MECH
    eventCatalogId.append(EventId.LIFE_PULSE)

    eventName[EventId.TOXIC_FOG] = STR_EVT_MECH_30_TITLE
    eventDesc[EventId.TOXIC_FOG] = STR_EVT_MECH_30_DESC.format(percent(EVT_MECH_30_DAMAGE_PERCENT_PER_TICK), EVT_MECH_30_DAMAGE_FLAT)
    eventDuration[EventId.TOXIC_FOG] = EVT_MECH_30_DURATION
    eventCatalogWeight[EventId.TOXIC_FOG] = EVT_MECH_30_WEIGHT
    eventCatalogType[EventId.TOXIC_FOG] = EventType.MECH
    eventCatalogId.append(EventId.TOXIC_FOG)
