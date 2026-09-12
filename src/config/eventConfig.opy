
#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "initialize event array":
    @Condition vishkarEventActivated == true

    eventWeight = EVT_INIT_EVENT_WEIGHT
    eventWeightBias = 0
    
    eventCatalogId = []
    eventName = []
    eventDesc = []
    eventDuration = []
    eventCatalogWeight = []
    eventCatalogType = []
    eventCatalogEffectId = []


    
    # Pack 0 - Special
    eventName[BuffEventId.OLIVIA_GIFT] = STR_EVT_BUFF_0_TITLE
    eventDesc[BuffEventId.OLIVIA_GIFT] = STR_EVT_BUFF_0_DESC
    eventDuration[BuffEventId.OLIVIA_GIFT] = EVT_BUFF_0_DURATION
    eventCatalogWeight[BuffEventId.OLIVIA_GIFT] = EVT_BUFF_0_WEIGHT
    eventCatalogType[BuffEventId.OLIVIA_GIFT] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.OLIVIA_GIFT] = BuffEventId.OLIVIA_GIFT
    eventCatalogId.append(BuffEventId.OLIVIA_GIFT)
    
    # ================================================
    # Pack 1: Buffs
    # ================================================
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_1, true, 1):
        goto lbl_0
    eventName[BuffEventId.GALE_BLESSING] = STR_EVT_BUFF_1_TITLE
    eventDesc[BuffEventId.GALE_BLESSING] = STR_EVT_BUFF_1_DESC.format(EVT_1_SPEED_BOOST)
    eventDuration[BuffEventId.GALE_BLESSING] = EVT_BUFF_1_DURATION
    eventCatalogWeight[BuffEventId.GALE_BLESSING] = EVT_BUFF_1_WEIGHT
    eventCatalogType[BuffEventId.GALE_BLESSING] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.GALE_BLESSING] = BuffEventId.GALE_BLESSING
    eventCatalogId.append(BuffEventId.GALE_BLESSING)

    eventName[BuffEventId.IRON_BULWARK] = STR_EVT_BUFF_2_TITLE
    eventDesc[BuffEventId.IRON_BULWARK] = STR_EVT_BUFF_2_DESC.format(EVT_2_ARMOR_FLAT, percent(EVT_2_ARMOR_MAXHP_FACTOR), negToPos(EVT_2_DMG_TAKEN))
    eventDuration[BuffEventId.IRON_BULWARK] = EVT_BUFF_2_DURATION
    eventCatalogWeight[BuffEventId.IRON_BULWARK] = EVT_BUFF_2_WEIGHT
    eventCatalogType[BuffEventId.IRON_BULWARK] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.IRON_BULWARK] = BuffEventId.IRON_BULWARK
    eventCatalogId.append(BuffEventId.IRON_BULWARK)

    eventName[BuffEventId.LIFE_SPRING] = STR_EVT_BUFF_4_TITLE
    eventDesc[BuffEventId.LIFE_SPRING] = STR_EVT_BUFF_4_DESC.format(percent(EVT_4_HEALTH_MAXHP_FACTOR), percent(EVT_4_HEAL_PERCENT))
    eventDuration[BuffEventId.LIFE_SPRING] = EVT_BUFF_4_DURATION
    eventCatalogWeight[BuffEventId.LIFE_SPRING] = EVT_BUFF_4_WEIGHT
    eventCatalogType[BuffEventId.LIFE_SPRING] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.LIFE_SPRING] = BuffEventId.LIFE_SPRING
    eventCatalogId.append(BuffEventId.LIFE_SPRING)

    eventName[BuffEventId.BLACK_FANS_ASSAULT] = STR_EVT_BUFF_5_TITLE
    eventDesc[BuffEventId.BLACK_FANS_ASSAULT] = STR_EVT_BUFF_5_DESC.format(EVT_5_BASE_HEALTH, percent(EVT_5_HEALTH_MAXHP_PERCENT), EVT_5_SPEED_BOOST)
    eventDuration[BuffEventId.BLACK_FANS_ASSAULT] = EVT_BUFF_5_DURATION
    eventCatalogWeight[BuffEventId.BLACK_FANS_ASSAULT] = EVT_BUFF_5_WEIGHT
    eventCatalogType[BuffEventId.BLACK_FANS_ASSAULT] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.BLACK_FANS_ASSAULT] = BuffEventId.BLACK_FANS_ASSAULT
    eventCatalogId.append(BuffEventId.BLACK_FANS_ASSAULT)

    eventName[BuffEventId.SPEED_STACK] = STR_EVT_BUFF_6_TITLE
    eventDesc[BuffEventId.SPEED_STACK] = STR_EVT_BUFF_6_DESC.format(EVT_6_SPEED_INC_PER_SEC)
    eventDuration[BuffEventId.SPEED_STACK] = EVT_BUFF_6_DURATION
    eventCatalogWeight[BuffEventId.SPEED_STACK] = EVT_BUFF_6_WEIGHT
    eventCatalogType[BuffEventId.SPEED_STACK] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.SPEED_STACK] = BuffEventId.SPEED_STACK
    eventCatalogId.append(BuffEventId.SPEED_STACK)

    eventName[BuffEventId.FLESH_REGEN] = STR_EVT_BUFF_7_TITLE
    eventDesc[BuffEventId.FLESH_REGEN] = STR_EVT_BUFF_7_DESC.format(EVT_7_BASE_HEALTH, percent(EVT_7_HEALTH_PERCENT), EVT_7_REGEN_INTERVAL)
    eventDuration[BuffEventId.FLESH_REGEN] = EVT_BUFF_7_DURATION
    eventCatalogWeight[BuffEventId.FLESH_REGEN] = EVT_BUFF_7_WEIGHT
    eventCatalogType[BuffEventId.FLESH_REGEN] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.FLESH_REGEN] = BuffEventId.FLESH_REGEN
    eventCatalogId.append(BuffEventId.FLESH_REGEN)

    eventName[BuffEventId.HEART_OF_STEEL] = STR_EVT_BUFF_8_TITLE
    eventDesc[BuffEventId.HEART_OF_STEEL] = STR_EVT_BUFF_8_DESC.format(EVT_8_HP_LAYER_PER_DEATH, EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[BuffEventId.HEART_OF_STEEL] = EVT_BUFF_8_DURATION
    eventCatalogWeight[BuffEventId.HEART_OF_STEEL] = EVT_BUFF_8_WEIGHT
    eventCatalogType[BuffEventId.HEART_OF_STEEL] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.HEART_OF_STEEL] = BuffEventId.HEART_OF_STEEL
    eventCatalogId.append(BuffEventId.HEART_OF_STEEL)

    # ================================================
    # Pack 1: Debuffs
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY] = STR_EVT_DEBUFF_0_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY] = STR_EVT_DEBUFF_0_DESC.format(EVT_DEBUFF_0_GRAVITY)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY] = EVT_DEBUFF_0_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY] = EVT_DEBUFF_0_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY] = DebuffEventId.GRAVITY_ANOMALY
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_ANOMALY)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP] = STR_EVT_DEBUFF_1_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP] = STR_EVT_DEBUFF_1_DESC
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP] = EVT_DEBUFF_1_HACK_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP] = EVT_DEBUFF_1_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP] = DebuffEventId.EMP
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.EMP)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE] = STR_EVT_DEBUFF_2_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE] = STR_EVT_DEBUFF_2_DESC.format(percent(EVT_DEBUFF_2_DMG_PERCENT))
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE] = EVT_DEBUFF_2_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE] = EVT_DEBUFF_2_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE] = DebuffEventId.SACRIFICE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.SACRIFICE)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE] = STR_EVT_DEBUFF_3_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE] = STR_EVT_DEBUFF_3_DESC.format(EVT_DEBUFF_3_DMG_TAKEN)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE] = EVT_DEBUFF_3_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE] = EVT_DEBUFF_3_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE] = DebuffEventId.VULNERABLE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.VULNERABLE)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40] = STR_EVT_DEBUFF_4_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40] = STR_EVT_DEBUFF_4_DESC.format(EVT_DEBUFF_4_DMG_BASE, percent(EVT_DEBUFF_4_DMG_PERCENT))
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40] = EVT_DEBUFF_4_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40] = EVT_DEBUFF_4_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40] = DebuffEventId.SPEED_LIMIT_40
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.SPEED_LIMIT_40)


    # ================================================
    # Pack 1: Mechanics
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER] = STR_EVT_MECH_1_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER] = STR_EVT_MECH_1_DESC.format(Button.RELOAD, EVT_MECH_1_WIN_RATE, EVT_MECH_1_STAKE)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER] = EVT_MECH_1_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER] = EVT_MECH_1_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER] = MechEventId.GAMBLER
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM] = STR_EVT_MECH_2_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM] = STR_EVT_MECH_2_DESC.format(percent(1 - EVT_MECH_2_MODEL_SCALE), percent(1 - EVT_MECH_2_HP_SCALE), EVT_MECH_2_SPEED_BOOST)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM] = EVT_MECH_2_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM] = EVT_MECH_2_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM] = MechEventId.MINI_FORM
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MINI_FORM)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH] = STR_EVT_MECH_3_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH] = STR_EVT_MECH_3_DESC.format(percent(EVT_MECH_3_HP_COST_RATIO), EVT_MECH_3_SPEED_BOOST)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH] = EVT_MECH_3_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH] = EVT_MECH_3_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH] = MechEventId.STEALTH_CROUCH
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.STEALTH_CROUCH)

    lbl_0:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_2, true, 1):
        goto lbl_1

    # ================================================
    # Pack 2: Buffs
    # ================================================
    eventName[BuffEventId.DEATH_DELAY] = STR_EVT_BUFF_9_TITLE
    eventDesc[BuffEventId.DEATH_DELAY] = STR_EVT_BUFF_9_DESC
    eventDuration[BuffEventId.DEATH_DELAY] = EVT_BUFF_9_DURATION
    eventCatalogWeight[BuffEventId.DEATH_DELAY] = EVT_BUFF_9_WEIGHT
    eventCatalogType[BuffEventId.DEATH_DELAY] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.DEATH_DELAY] = BuffEventId.DEATH_DELAY
    eventCatalogId.append(BuffEventId.DEATH_DELAY)

    eventName[BuffEventId.KONAMI_CODE] = STR_EVT_BUFF_11_TITLE
    eventDesc[BuffEventId.KONAMI_CODE] = STR_EVT_BUFF_11_DESC
    eventDuration[BuffEventId.KONAMI_CODE] = EVT_BUFF_11_DURATION
    eventCatalogWeight[BuffEventId.KONAMI_CODE] = EVT_BUFF_11_WEIGHT
    eventCatalogType[BuffEventId.KONAMI_CODE] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.KONAMI_CODE] = BuffEventId.KONAMI_CODE
    eventCatalogId.append(BuffEventId.KONAMI_CODE)

    eventName[BuffEventId.PHOTON_SHIELD] = STR_EVT_BUFF_12_TITLE
    eventDesc[BuffEventId.PHOTON_SHIELD] = STR_EVT_BUFF_12_DESC.format(EVT_12_BASE_SHIELD, percent(EVT_12_SHIELD_PERCENT))
    eventDuration[BuffEventId.PHOTON_SHIELD] = EVT_BUFF_12_DURATION
    eventCatalogWeight[BuffEventId.PHOTON_SHIELD] = EVT_BUFF_12_WEIGHT
    eventCatalogType[BuffEventId.PHOTON_SHIELD] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.PHOTON_SHIELD] = BuffEventId.PHOTON_SHIELD
    eventCatalogId.append(BuffEventId.PHOTON_SHIELD)


    # ================================================
    # Pack 2: Debuffs
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL] = STR_EVT_DEBUFF_5_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL] = STR_EVT_DEBUFF_5_DESC.format(EVT_DEBUFF_5_SPEED_REDUCTION)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL] = EVT_DEBUFF_5_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL] = EVT_DEBUFF_5_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL] = DebuffEventId.GRAVITY_PULL
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.GRAVITY_PULL)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS] = STR_EVT_DEBUFF_6_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS] = STR_EVT_DEBUFF_6_DESC.format(negToPos(EVT_DEBUFF_6_MAX_SPEED_DEC))
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS] = EVT_DEBUFF_6_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS] = EVT_DEBUFF_6_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS] = DebuffEventId.OSTEOPOROSIS
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.OSTEOPOROSIS)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX] = STR_EVT_DEBUFF_7_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX] = STR_EVT_DEBUFF_7_DESC.format(EVT_DEBUFF_7_RADIUS)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX] = EVT_DEBUFF_7_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX] = EVT_DEBUFF_7_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX] = DebuffEventId.EMP_PROMAX
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.EMP_PROMAX)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK] = STR_EVT_DEBUFF_8_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK] = STR_EVT_DEBUFF_8_DESC.format(percent(EVT_DEBUFF_8_DMG_PERCENT))
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK] = EVT_DEBUFF_8_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK] = EVT_DEBUFF_8_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK] = DebuffEventId.ENERGY_LEAK
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.ENERGY_LEAK)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN] = STR_EVT_DEBUFF_9_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN] = STR_EVT_DEBUFF_9_DESC.format(percent(EVT_DEBUFF_9_DMG_FACTOR), EVT_DEBUFF_9_RADIUS)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN] = EVT_DEBUFF_9_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN] = EVT_DEBUFF_9_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN] = DebuffEventId.SHARE_THE_PAIN
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.SHARE_THE_PAIN)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY] = STR_EVT_DEBUFF_10_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY] = STR_EVT_DEBUFF_10_DESC.format(EVT_DEBUFF_10_BERSERK_ADD)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY] = EVT_DEBUFF_10_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY] = EVT_DEBUFF_10_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY] = DebuffEventId.FEAST_FRENZY
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.FEAST_FRENZY)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE] = STR_EVT_DEBUFF_11_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE] = STR_EVT_DEBUFF_11_DESC.format(EVT_DEBUFF_11_DELAY, EVT_DEBUFF_11_KNOCKDOWN_DURATION)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE] = EVT_DEBUFF_11_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE] = EVT_DEBUFF_11_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE] = DebuffEventId.POWERLESS_SPOUSE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.POWERLESS_SPOUSE)


    # ================================================
    # Pack 2: Mechanics
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE] = STR_EVT_MECH_4_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE] = STR_EVT_MECH_4_DESC.format(100 + EVT_MECH_4_MAX_SPEED)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE] = EVT_MECH_4_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE] = EVT_MECH_4_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE] = MechEventId.BRAKE_FAILURE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.BRAKE_FAILURE)

    
    lbl_1:

    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_3, true, 1):
        goto lbl_2
    
    # ================================================
    # Pack 3: Buffs
    # ================================================
    eventName[BuffEventId.REGROUP_CALL] = STR_EVT_BUFF_13_TITLE
    eventDesc[BuffEventId.REGROUP_CALL] = STR_EVT_BUFF_13_DESC.format(EVT_13_CHECK_INTERVAL, EVT_13_INVINCIBLE_DURATION)
    eventDuration[BuffEventId.REGROUP_CALL] = EVT_BUFF_13_DURATION
    eventCatalogWeight[BuffEventId.REGROUP_CALL] = EVT_BUFF_13_WEIGHT
    eventCatalogType[BuffEventId.REGROUP_CALL] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.REGROUP_CALL] = BuffEventId.REGROUP_CALL
    eventCatalogId.append(BuffEventId.REGROUP_CALL)

    eventName[BuffEventId.WILL_TO_WIN] = STR_EVT_BUFF_14_TITLE
    eventDesc[BuffEventId.WILL_TO_WIN] = STR_EVT_BUFF_14_DESC.format(percent(EVT_14_TRIGGER_HP_PERCENT), EVT_14_INVINCIBLE_DURATION)
    eventDuration[BuffEventId.WILL_TO_WIN] = EVT_BUFF_14_DURATION
    eventCatalogWeight[BuffEventId.WILL_TO_WIN] = EVT_BUFF_14_WEIGHT
    eventCatalogType[BuffEventId.WILL_TO_WIN] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.WILL_TO_WIN] = BuffEventId.WILL_TO_WIN
    eventCatalogId.append(BuffEventId.WILL_TO_WIN)

    eventName[BuffEventId.PHEIDIPPIDES_TRIAL] = STR_EVT_BUFF_15_TITLE
    eventDesc[BuffEventId.PHEIDIPPIDES_TRIAL] = STR_EVT_BUFF_15_DESC.format(EVT_15_DISTANCE_GOAL, EVT_15_REWARD_SPEED)
    eventDuration[BuffEventId.PHEIDIPPIDES_TRIAL] = EVT_BUFF_15_DURATION
    eventCatalogWeight[BuffEventId.PHEIDIPPIDES_TRIAL] = EVT_BUFF_15_WEIGHT
    eventCatalogType[BuffEventId.PHEIDIPPIDES_TRIAL] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.PHEIDIPPIDES_TRIAL] = BuffEventId.PHEIDIPPIDES_TRIAL
    eventCatalogId.append(BuffEventId.PHEIDIPPIDES_TRIAL)

    eventName[BuffEventId.HEART_OF_STEEL_PRO] = STR_EVT_BUFF_16_TITLE
    eventDesc[BuffEventId.HEART_OF_STEEL_PRO] = STR_EVT_BUFF_16_DESC.format(EVT_16_HP_GAIN_FLAT, EVT_16_HP_MULTIPLIER)
    eventDuration[BuffEventId.HEART_OF_STEEL_PRO] = EVT_BUFF_16_DURATION
    eventCatalogWeight[BuffEventId.HEART_OF_STEEL_PRO] = EVT_BUFF_16_WEIGHT
    eventCatalogType[BuffEventId.HEART_OF_STEEL_PRO] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.HEART_OF_STEEL_PRO] = BuffEventId.HEART_OF_STEEL_PRO
    eventCatalogId.append(BuffEventId.HEART_OF_STEEL_PRO)

    eventName[BuffEventId.ULT_MOMENTUM] = STR_EVT_BUFF_18_TITLE
    eventDesc[BuffEventId.ULT_MOMENTUM] = STR_EVT_BUFF_18_DESC.format(EVT_18_DMG_REDUCTION_DURING_ULT)
    eventDuration[BuffEventId.ULT_MOMENTUM] = EVT_BUFF_18_DURATION
    eventCatalogWeight[BuffEventId.ULT_MOMENTUM] = EVT_BUFF_18_WEIGHT
    eventCatalogType[BuffEventId.ULT_MOMENTUM] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.ULT_MOMENTUM] = BuffEventId.ULT_MOMENTUM
    eventCatalogId.append(BuffEventId.ULT_MOMENTUM)
 
    # ================================================
    # Pack 3: Debuffs
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED] = STR_EVT_DEBUFF_13_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED] = STR_EVT_DEBUFF_13_DESC.format(EVT_DEBUFF_13_INTERVAL, percent(EVT_DEBUFF_13_DAMAGE_PERCENT), percent(EVT_DEBUFF_13_EXECUTE_THRESHOLD))
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED] = EVT_DEBUFF_13_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED] = EVT_DEBUFF_13_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED] = DebuffEventId.HALVED
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.HALVED)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY] = STR_EVT_DEBUFF_14_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY] = STR_EVT_DEBUFF_14_DESC.format(EVT_DEBUFF_14_STACKS_TAKE)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY] = EVT_DEBUFF_14_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY] = EVT_DEBUFF_14_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY] = DebuffEventId.SELFLESS_GIVEAWAY
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY)


    # ================================================
    # Pack 3: Mechanics
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE] = STR_EVT_MECH_0_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE] = STR_EVT_MECH_0_DESC.format(negToPos(EVT_MECH_0_DMG_TAKEN), percent(EVT_MECH_0_HP_PERCENT))
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE] = EVT_MECH_0_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE] = EVT_MECH_0_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE] = MechEventId.EXTREME_CHALLENGE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.EXTREME_CHALLENGE)

    # ================================================
    # Pack 3: Mechanics
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST] = STR_EVT_MECH_5_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST] = STR_EVT_MECH_5_DESC.format(Button.JUMP, negToPos(EVT_MECH_5_DMG_TAKEN))
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST] = EVT_MECH_5_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST] = EVT_MECH_5_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST] = MechEventId.JUMP_THRUST
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.JUMP_THRUST)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE] = STR_EVT_MECH_6_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE] = STR_EVT_MECH_6_DESC.format(Button.RELOAD, EVT_MECH_6_HEARTSTEEL_COST, EVT_MECH_6_PROB_LOSE_NORMAL - EVT_MECH_6_PROB_WIN_NORMAL, EVT_MECH_6_VAL_NORMAL, 100 - EVT_MECH_6_PROB_LOSE_NORMAL, EVT_MECH_6_VAL_RARE)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE] = EVT_MECH_6_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE] = EVT_MECH_6_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE] = MechEventId.GAMBLER_SPEED_CHALLENGE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE)

    
    lbl_2:
    
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_4, true, 1):
        goto lbl_3

    # ================================================
    # Pack 4: Buffs
    # ================================================
    eventName[BuffEventId.PHASE_SURGE] = STR_EVT_BUFF_19_TITLE
    eventDesc[BuffEventId.PHASE_SURGE] = STR_EVT_BUFF_19_DESC.format(EVT_19_SPEED_BOOST, EVT_19_SPEED_BONUS_PER_TRIGGER)
    eventDuration[BuffEventId.PHASE_SURGE] = EVT_BUFF_19_DURATION
    eventCatalogWeight[BuffEventId.PHASE_SURGE] = EVT_BUFF_19_WEIGHT
    eventCatalogType[BuffEventId.PHASE_SURGE] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.PHASE_SURGE] = BuffEventId.PHASE_SURGE
    eventCatalogId.append(BuffEventId.PHASE_SURGE)

    eventName[BuffEventId.BODYGUARD] = STR_EVT_BUFF_20_TITLE
    eventDesc[BuffEventId.BODYGUARD] = STR_EVT_BUFF_20_DESC
    eventDuration[BuffEventId.BODYGUARD] = EVT_BUFF_20_DURATION
    eventCatalogWeight[BuffEventId.BODYGUARD] = EVT_BUFF_20_WEIGHT
    eventCatalogType[BuffEventId.BODYGUARD] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.BODYGUARD] = BuffEventId.BODYGUARD
    eventCatalogId.append(BuffEventId.BODYGUARD)

    eventName[BuffEventId.MARTYR_TRIAL] = STR_EVT_BUFF_21_TITLE
    eventDesc[BuffEventId.MARTYR_TRIAL] = STR_EVT_BUFF_21_DESC.format(negToPos(EVT_21_REWARD_DMG_PERMA))
    eventDuration[BuffEventId.MARTYR_TRIAL] = EVT_BUFF_21_DURATION
    eventCatalogWeight[BuffEventId.MARTYR_TRIAL] = EVT_BUFF_21_WEIGHT
    eventCatalogType[BuffEventId.MARTYR_TRIAL] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.MARTYR_TRIAL] = BuffEventId.MARTYR_TRIAL
    eventCatalogId.append(BuffEventId.MARTYR_TRIAL)

    eventName[BuffEventId.F5_REFRESH] = STR_EVT_BUFF_24_TITLE
    eventDesc[BuffEventId.F5_REFRESH] = STR_EVT_BUFF_24_DESC.format(EVT_24_REFRESH_INTERVAL)
    eventDuration[BuffEventId.F5_REFRESH] = EVT_BUFF_24_DURATION
    eventCatalogWeight[BuffEventId.F5_REFRESH] = EVT_BUFF_24_WEIGHT
    eventCatalogType[BuffEventId.F5_REFRESH] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.F5_REFRESH] = BuffEventId.F5_REFRESH
    eventCatalogId.append(BuffEventId.F5_REFRESH)

    eventName[BuffEventId.HEALING_TOWER_PROMAX] = STR_EVT_BUFF_25_TITLE
    eventDesc[BuffEventId.HEALING_TOWER_PROMAX] = STR_EVT_BUFF_25_DESC.format(EVT_25_HEAL_FLAT, percent(EVT_25_HEAL_MAXHP_FACTOR))
    eventDuration[BuffEventId.HEALING_TOWER_PROMAX] = EVT_BUFF_25_DURATION
    eventCatalogWeight[BuffEventId.HEALING_TOWER_PROMAX] = EVT_BUFF_25_WEIGHT
    eventCatalogType[BuffEventId.HEALING_TOWER_PROMAX] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.HEALING_TOWER_PROMAX] = BuffEventId.HEALING_TOWER_PROMAX
    eventCatalogId.append(BuffEventId.HEALING_TOWER_PROMAX)

    # ================================================
    # Pack 4: Debuffs
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA] = STR_EVT_DEBUFF_15_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA] = STR_EVT_DEBUFF_15_DESC
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA] = EVT_DEBUFF_15_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA] = EVT_DEBUFF_15_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA] = DebuffEventId.KEEP_DISTANCE_AURA
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.KEEP_DISTANCE_AURA)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET] = STR_EVT_DEBUFF_20_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET] = STR_EVT_DEBUFF_20_DESC
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET] = EVT_DEBUFF_20_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET] = EVT_DEBUFF_20_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET] = DebuffEventId.MOON_ROCKET
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.MOON_ROCKET)


    # ================================================
    # Pack 4: Mechanics
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING] = STR_EVT_MECH_7_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING] = STR_EVT_MECH_7_DESC.format(Button.RELOAD, EVT_MECH_7_HEART_STEEL_COST, EVT_MECH_7_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING] = EVT_MECH_7_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING] = EVT_MECH_7_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING] = MechEventId.CHEAT_CARD_COUNTING
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_CARD_COUNTING)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT] = STR_EVT_MECH_8_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT] = STR_EVT_MECH_8_DESC.format(Button.RELOAD, EVT_MECH_8_CONTRACT_EVENTS, EVT_MECH_8_WIN_CHANCE, EVT_MECH_8_REWARD_STACKS)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT] = EVT_MECH_8_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT] = EVT_MECH_8_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT] = MechEventId.GAMBLER_SHORT_INVESTMENT
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SHORT_INVESTMENT)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO] = STR_EVT_MECH_10_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO] = STR_EVT_MECH_10_DESC.format(Button.RELOAD)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO] = EVT_MECH_10_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO] = EVT_MECH_10_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO] = MechEventId.CHEAT_SKIP_HERO
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_SKIP_HERO)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL] = STR_EVT_MECH_11_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL] = STR_EVT_MECH_11_DESC.format(EVT_MECH_11_RESURRECT_DELAY, percent(EVT_MECH_11_SIZE_STEP), EVT_MECH_11_SPEED_STEP)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL] = EVT_MECH_11_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL] = EVT_MECH_11_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL] = MechEventId.NESTING_DOLL
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.NESTING_DOLL)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT] = STR_EVT_MECH_12_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT] = STR_EVT_MECH_12_DESC.format(Button.RELOAD, EVT_MECH_12_CONTRACT_EVENTS, EVT_MECH_12_WIN_CHANCE, EVT_MECH_12_REWARD_STACKS)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT] = EVT_MECH_12_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT] = EVT_MECH_12_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT] = MechEventId.GAMBLER_LONG_INVESTMENT
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_LONG_INVESTMENT)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT] = STR_EVT_MECH_13_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT] = STR_EVT_MECH_13_DESC.format(EVT_MECH_13_SIZE_HEALTH * 100, percent(EVT_MECH_13_HEAL_SMOOTHING))
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT] = EVT_MECH_13_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT] = EVT_MECH_13_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT] = MechEventId.VALKYRIE_DESCENT
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VALKYRIE_DESCENT)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR] = STR_EVT_MECH_14_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR] = STR_EVT_MECH_14_DESC.format(100 / EVT_MECH_14_DMG_REDUCE_DIVISOR, EVT_MECH_14_SPEED_FACTOR, EVT_MECH_14_INTERVAL / EVT_MECH_14_HEART_STEEL_PER_TICK)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR] = EVT_MECH_14_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR] = EVT_MECH_14_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR] = MechEventId.TRINITY_SSR
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.TRINITY_SSR)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE] = STR_EVT_MECH_18_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE] = STR_EVT_MECH_18_DESC.format(EVT_MECH_18_DRAIN_FLAT, percent(EVT_MECH_18_DRAIN_MAXHP_FACTOR), EVT_MECH_18_KILL_HEAL_PERMA)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE] = EVT_MECH_18_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE] = EVT_MECH_18_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE] = MechEventId.VAMPIRE
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.VAMPIRE)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF] = STR_EVT_MECH_19_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF] = STR_EVT_MECH_19_DESC.format(Button.RELOAD)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF] = EVT_MECH_19_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF] = EVT_MECH_19_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF] = MechEventId.THIEF
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.THIEF)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL] = STR_EVT_MECH_20_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL] = STR_EVT_MECH_20_DESC.format(Button.RELOAD, EVT_MECH_20_WIN_RATE, percent(EVT_MECH_20_HEAL_MAXHP_FACTOR), 100 - EVT_MECH_20_WIN_RATE)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL] = EVT_MECH_20_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL] = EVT_MECH_20_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL] = MechEventId.GAMBLER_HELPFUL_SOUL
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HELPFUL_SOUL)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL] = STR_EVT_MECH_22_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL] = STR_EVT_MECH_22_DESC.format(Button.RELOAD, EVT_MECH_22_HEART_STEEL_COST, EVT_MECH_22_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL] = EVT_MECH_22_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL] = EVT_MECH_22_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL] = MechEventId.CHEAT_BACKROOM_DEAL
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.CHEAT_BACKROOM_DEAL)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION] = STR_EVT_MECH_23_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION] = STR_EVT_MECH_23_DESC.format(Button.RELOAD)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION] = EVT_MECH_23_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION] = EVT_MECH_23_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION] = MechEventId.MIRROR_INVERSION
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL] = STR_EVT_MECH_24_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL] = STR_EVT_MECH_24_DESC.format(Button.RELOAD, percent(EVT_MECH_24_STAKE_RATIO), EVT_MECH_24_WIN_RATE)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL] = EVT_MECH_24_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL] = EVT_MECH_24_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL] = MechEventId.GAMBLER_WINNER_TAKE_ALL
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL)


    lbl_3:
    if not createWorkshopSettingBool(STR_CAT_RANDOM_PACK, STR_CAT_RANDOM_PACK_5, true, 1):
        goto lbl_4

    # ================================================
    # Pack 5: Buffs
    # ================================================
    eventName[BuffEventId.MAGIC_MASTER] = STR_EVT_BUFF_29_TITLE
    eventDesc[BuffEventId.MAGIC_MASTER] = STR_EVT_BUFF_29_DESC.format(EVT_29_SPEED_BOOST)
    eventDuration[BuffEventId.MAGIC_MASTER] = EVT_BUFF_29_DURATION
    eventCatalogWeight[BuffEventId.MAGIC_MASTER] = EVT_BUFF_29_WEIGHT
    eventCatalogType[BuffEventId.MAGIC_MASTER] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.MAGIC_MASTER] = BuffEventId.MAGIC_MASTER
    eventCatalogId.append(BuffEventId.MAGIC_MASTER)

    eventName[BuffEventId.DIVINE_REINFORCEMENT] = STR_EVT_BUFF_30_TITLE
    eventDesc[BuffEventId.DIVINE_REINFORCEMENT] = STR_EVT_BUFF_30_DESC.format(Button.RELOAD, EVT_30_HEAL_FLAT, percent(EVT_30_HEAL_MAXHP_FACTOR), EVT_30_COOLDOWN)
    eventDuration[BuffEventId.DIVINE_REINFORCEMENT] = EVT_BUFF_30_DURATION
    eventCatalogWeight[BuffEventId.DIVINE_REINFORCEMENT] = EVT_BUFF_30_WEIGHT
    eventCatalogType[BuffEventId.DIVINE_REINFORCEMENT] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.DIVINE_REINFORCEMENT] = BuffEventId.DIVINE_REINFORCEMENT
    eventCatalogId.append(BuffEventId.DIVINE_REINFORCEMENT)

    eventName[BuffEventId.TEMPER_HEART] = STR_EVT_BUFF_31_TITLE
    eventDesc[BuffEventId.TEMPER_HEART] = STR_EVT_BUFF_31_DESC.format(EVT_31_HERO_GOAL_MULTI if (controlJumpPosition != null and portalPosition == null) else EVT_31_HERO_GOAL, EVT_31_STACK_MULTIPLIER, EVT_8_HP_PERCENT_PER_STACK, EVT_8_HP_PERCENT_PER_STACK + EVT_31_PERCENT_PER_STACK_BONUS)
    eventDuration[BuffEventId.TEMPER_HEART] = EVT_BUFF_31_DURATION
    eventCatalogWeight[BuffEventId.TEMPER_HEART] = EVT_BUFF_31_WEIGHT
    eventCatalogType[BuffEventId.TEMPER_HEART] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.TEMPER_HEART] = BuffEventId.TEMPER_HEART
    eventCatalogId.append(BuffEventId.TEMPER_HEART)

    eventName[BuffEventId.BATTLEFIELD_MEDIC] = STR_EVT_BUFF_32_TITLE
    eventDesc[BuffEventId.BATTLEFIELD_MEDIC] = STR_EVT_BUFF_32_DESC.format(EVT_32_HEAL_BASE, EVT_32_HEAL_PER_PLAYER, EVT_32_REWARD_HEAL_PERMA)
    eventDuration[BuffEventId.BATTLEFIELD_MEDIC] = EVT_BUFF_32_DURATION
    eventCatalogWeight[BuffEventId.BATTLEFIELD_MEDIC] = EVT_BUFF_32_WEIGHT
    eventCatalogType[BuffEventId.BATTLEFIELD_MEDIC] = EventType.BUFF
    eventCatalogEffectId[BuffEventId.BATTLEFIELD_MEDIC] = BuffEventId.BATTLEFIELD_MEDIC
    eventCatalogId.append(BuffEventId.BATTLEFIELD_MEDIC)
    # ================================================
    # Pack 5: Debuffs
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION] = STR_EVT_DEBUFF_22_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION] = STR_EVT_DEBUFF_22_DESC.format(EVT_DEBUFF_22_INTERVAL)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION] = EVT_DEBUFF_22_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION] = EVT_DEBUFF_22_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION] = DebuffEventId.WAYWARD_NAVIGATION
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.WAYWARD_NAVIGATION)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK] = STR_EVT_DEBUFF_23_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK] = STR_EVT_DEBUFF_23_DESC.format(EVT_DEBUFF_23_HP_UNIT, EVT_DEBUFF_23_DMG_TAKEN_PER_UNIT)
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK] = EVT_DEBUFF_23_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK] = EVT_DEBUFF_23_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK] = DebuffEventId.OVERWEIGHT_PACK
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.OVERWEIGHT_PACK)

    eventName[BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH] = STR_EVT_DEBUFF_21_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH] = STR_EVT_DEBUFF_21_DESC.format(EVT_DEBUFF_21_TOTAL_STACK, negToPos(EVT_DEBUFF_21_HEAL_DELTA_PER_STACK), Button.RELOAD, percent(EVT_DEBUFF_21_HP_COST_RATIO))
    eventDuration[BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH] = EVT_DEBUFF_21_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH] = EVT_DEBUFF_21_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH] = EventType.DEBUFF
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH] = DebuffEventId.ADLERSBRUNN_WRAITH
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DebuffEventId.ADLERSBRUNN_WRAITH)

    # ================================================
    # Pack 5: Mechanics
    # ================================================
    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC] = STR_EVT_MECH_15_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC] = STR_EVT_MECH_15_DESC.format(EVT_MECH_15_DURATION, Button.RELOAD, EVT_INTERACT_HOLD_TIME, EVT_MECH_15_HEART_STEEL_DELTA, EVT_MECH_15_SPEED_DELTA, EVT_MECH_15_DMG_HEAL_DELTA)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC] = EVT_MECH_15_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC] = EVT_MECH_15_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC] = MechEventId.GAMBLER_DICE_MANIAC
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_DICE_MANIAC)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL] = STR_EVT_MECH_16_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL] = STR_EVT_MECH_16_DESC.format(Button.RELOAD, EVT_MECH_16_WIN_RATE, EVT_MECH_16_WIN_MULTIPLIER, 100 - EVT_MECH_16_WIN_RATE, percent(EVT_MECH_16_LOSE_RATIO))
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL] = EVT_MECH_16_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL] = EVT_MECH_16_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL] = MechEventId.GAMBLER_HEART_OF_STEEL
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL)

    eventName[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5] = STR_EVT_MECH_17_TITLE
    eventDesc[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5] = STR_EVT_MECH_17_DESC.format(Button.RELOAD, percent(EVT_MECH_17_STAKE_RATIO), EVT_MECH_17_WIN_RATE, EVT_MECH_17_WIN_MULTIPLIER)
    eventDuration[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5] = EVT_MECH_17_DURATION
    eventCatalogWeight[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5] = EVT_MECH_17_WEIGHT
    eventCatalogType[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5] = EventType.MECH
    eventCatalogEffectId[BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5] = MechEventId.GAMBLER_ALL_IN_ART_5
    eventCatalogId.append(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5)

    lbl_4:

#!mainFile "../main.opy"
