#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "[VishkarEvent]: 极限挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.EXTREME_CHALLENGE]) == true
    
    waitUntil(eventPlayer.isAlive(), MAX_TIME)
    eventPlayer.mod_heal_event = EVT_MECH_0_HEAL_BAN
    eventPlayer.heal_recv = EVT_MECH_0_HEAL_BAN
    createEffect(getAllPlayers(), Effect.ANA_BIOTIC_GRENADE_NO_HEALING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * EVT_MECH_0_HP_PERCENT)
    eventPlayer.mod_dmg_taken = EVT_MECH_0_DMG_TAKEN
    updatePlayerStats()
    waitUntil(eventPlayer.isDead(), eventPlayer.eventDuration)
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
    clearEventEffect()
    eventPlayer.mod_heal_event = 0
    eventPlayer.heal_recv = 0
    updatePlayerStats()
    eventPlayer.eventDuration = 0


rule "[VishkarEvent]: 极限挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.EXTREME_CHALLENGE]) == true
    @Condition eventPlayer.getHealth() > eventPlayer.getMaxHealth() * EVT_MECH_0_HP_PERCENT == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * EVT_MECH_0_HP_PERCENT)
    wait(5)
    if ruleCondition:
        loop()


rule "[VishkarEvent]: 纳米战甲":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.NANO_ARMOR]) == true
    
    wait()
    waitUntil(eventPlayer.isAlive(), eventPlayer.eventDuration)
    eventPlayer.addHealthPool(Health.NORMAL, eventPlayer.getMaxHealth() * EVT_MECH_1_HP_MULTIPLIER, false, false)
    eventPlayer.healthId[0] = getLastCreatedHealthPool()
    eventPlayer.mod_speed_event = EVT_MECH_1_SPEED_PENALTY
    updatePlayerStats()
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    removeHealthPool(eventPlayer.healthId[0])
    eventPlayer.healthId[0] = null


rule "[VishkarEvent]: 赌徒":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 100) <= EVT_MECH_2_WIN_RATE:
        eventPlayer.heart_steel -= EVT_MECH_2_STAKE
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        smallMessage(eventPlayer, "  {0}  输！失去 {1} 层心之钢层数（{2}%）".format(iconString(Icon.DIAMOND), EVT_MECH_2_STAKE, EVT_MECH_2_STAKE * EVT_8_HP_PERCENT_PER_STACK))
    else:
        eventPlayer.heart_steel += EVT_MECH_2_STAKE
        eventPlayer.dlcTimeChallenge[0]++
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢层数（{2}%）".format(iconString(Icon.CLUB), EVT_MECH_2_STAKE, EVT_MECH_2_STAKE * EVT_8_HP_PERCENT_PER_STACK))
    wait()
    setPlayerHP()
    wait()
    eventPlayer.eventDuration = 0


rule "[VishkarEvent]: 有点松弛":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHILL_MODE, eventPlayer.isMoving(), eventPlayer.getSpeed() != 0]) == true
    
    wait()
    if eventPlayer.eventEffect != null:
        goto lbl_0
    createEffect(getAllPlayers(), Effect.WRECKING_BALL_PILEDRIVER_FIRE, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    lbl_0:
    createEffect([player for player in getPlayers(Team.1) if not player.ignoreObstrucVis], Effect.CLOUD, random.choice([Color.YELLOW, Color.GREEN, Color.ORANGE, Color.LIME_GREEN, Color.VIOLET]), evalOnce(eventPlayer.getPosition()), EVT_MECH_3_CLOUD_RADIUS, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    wait()
    eventPlayer.obstrucVis.append(getLastCreatedEntity())
    wait(EVT_MECH_3_SPAWN_INTERVAL)
    if ruleCondition:
        loop()
    clearEventEffect()


rule "[VishkarEvent]: 有点松弛":
    @Event eachPlayer
    @Team 1
    @Condition dlcVishkarEvent == true
    @Condition eventPlayer.obstrucVis != []
    @Condition len(eventPlayer.obstrucVis) > 0
    
    wait(20, Wait.ABORT_WHEN_FALSE)
    destroyEffect(eventPlayer.obstrucVis[0])
    eventPlayer.obstrucVis.remove(eventPlayer.obstrucVis[0])
    wait(0.5)
    if ruleCondition:
        loop()



rule "[VishkarEvent]: 迷你形态":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.MINI_FORM]) == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.sizeHealth = EVT_MECH_4_HP_SCALE
    eventPlayer.startScalingSize(EVT_MECH_4_MODEL_SCALE, false)
    eventPlayer.startScalingBarriers(EVT_MECH_4_MODEL_SCALE, false)
    eventPlayer.startModifyingVoicelinePitch(EVT_MECH_4_VOICE_PITCH, false)
    eventPlayer.mod_speed_event = EVT_MECH_4_SPEED_BOOST
    updatePlayerStats()
    setPlayerHP()
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)
    eventPlayer.sizeHealth = 1
    setPlayerHP()
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.stopModifyingVoicelinePitch()


rule "[VishkarEvent]: 悄悄地进村":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.STEALTH_CROUCH]) == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    createEffect(getAllPlayers(), Effect.REAPER_WRAITH_FORM, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.targetSilence = true
    eventPlayer.mod_speed_event -= EVT_MECH_5_SPEED_PENALTY
    updatePlayerStats()
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) == false, eventPlayer.eventDuration)
    eventPlayer.targetSilence = false
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()
    wait(0.25)


rule "[VishkarEvent]: 紧急避障":
    @Event playerTookDamage
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.EMERGENCY_EVASION]) == true
    
    wait(0.032, Wait.ABORT_WHEN_FALSE)
    eventPlayer.mod_speed_event += EVT_MECH_6_SPEED_BOOST
    updatePlayerStats()
    createEffect(getAllPlayers(), Effect.SOLDIER_SPRINTING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    wait(EVT_MECH_6_SPEED_DURATION)
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()



rule "[VishkarEvent]: 刹车失灵":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.BRAKE_FAILURE]) == true
    
    eventPlayer.startThrottleInDirection(Vector.FORWARD, 1, Relativity.TO_PLAYER, Throttle.REPLACE_EXISTING, ThrottleReeval.NONE)
    wait(eventPlayer.eventDuration)
    eventPlayer.stopThrottleInDirection()
    eventPlayer.hudText = ""


rule "[VishkarEvent]: 刹车失灵":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.BRAKE_FAILURE]) == true
    
    while eventPlayer.mod_speed_event < EVT_MECH_7_MAX_SPEED:
        eventPlayer.mod_speed_event += 5
        if eventPlayer.mod_dmg_taken == EVT_MECH_7_MAX_DMG_TAKEN:
            goto lbl_0
        eventPlayer.mod_dmg_taken -= EVT_MECH_7_DMG_TAKEN_INC
        lbl_0:
        eventPlayer.hudText = "移速+{0}% / 伤害减免 {1}%".format(eventPlayer.mod_speed_event, negToPos(eventPlayer.mod_dmg_taken))
        updatePlayerStats()
        wait(EVT_MECH_7_INTERVAL)



rule "[VishkarEvent]: 屁动力 eff":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SHORT_INVESTMENT, eventPlayer.nanoEffect == null]) == true
    
    createEffect(getAllPlayers() if eventPlayer.isHoldingButton(Button.JUMP) else null, Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.nanoEffect = getLastCreatedEntity()
    
    waitUntil(eventPlayer.eventDuration == 0, EVT_MECH_12_DURATION)
    
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.nanoEffect = null

rule "[VishkarEvent]: 屁动力":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.JUMP_THRUST, eventPlayer.isHoldingButton(Button.JUMP)]) == true
    
    eventPlayer.mod_dmg_taken = EVT_MECH_8_DMG_TAKEN
    updatePlayerStats()

    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), EVT_MECH_8_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()


rule "[VishkarEvent]: 赌徒：竞速挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SPEED_CHALLENGE, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * EVT_MECH_9_HP_PENALTY)
    eventPlayer.categoryRoll = random.uniform(0, 100)
    if eventPlayer.categoryRoll <= EVT_MECH_9_PROB_WIN_NORMAL:
        eventPlayer.mod_speed_perma += EVT_MECH_9_VAL_NORMAL
        eventPlayer.dlcTimeChallenge[0]++
        smallMessage(eventPlayer, "  {0}  赢！永久获得 {1}% 移动速度加成".format(iconString(Icon.CLUB), EVT_MECH_9_VAL_NORMAL))
    elif eventPlayer.categoryRoll <= EVT_MECH_9_PROB_LOSE_NORMAL:
        eventPlayer.mod_speed_perma -= EVT_MECH_9_VAL_NORMAL
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        smallMessage(eventPlayer, "  {0}  输！永久失去 {1}% 移动速度加成".format(iconString(Icon.DIAMOND), EVT_MECH_9_VAL_NORMAL))
    elif eventPlayer.categoryRoll <= EVT_MECH_9_PROB_WIN_RARE:
        eventPlayer.mod_speed_perma += EVT_MECH_9_VAL_RARE
        eventPlayer.dlcTimeChallenge[0]++
        smallMessage(eventPlayer, "  {0}  赢！永久获得 {1}% 移动速度加成".format(iconString(Icon.CLUB), EVT_MECH_9_VAL_RARE))
    else:
        eventPlayer.mod_speed_perma -= EVT_MECH_9_VAL_RARE
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        smallMessage(eventPlayer, "  {0}  输！永久失去 {1}% 移动速度加成".format(iconString(Icon.DIAMOND), EVT_MECH_9_VAL_RARE))
    eventPlayer.categoryRoll = 0
    updatePlayerStats()
    eventPlayer.eventDuration = 0


rule "[VishkarEvent]: 作弊：我要验牌 (触发)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_CARD_COUNTING, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.heart_steel -= EVT_MECH_10_HEART_STEEL_COST
    setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.TEAM_1, eventPlayer, 100)
    eventPlayer.eventForceRoll = EVT_MECH_10_FORCE_ROLL
    smallMessage(eventPlayer, "  {0}  已扣除 {1} 层心之钢（{2}% 最大生命值）".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_MECH_10_HEART_STEEL_COST, EVT_MECH_10_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK))
    wait(0.2)
    smallMessage(eventPlayer, "  {0}  下一个事件必然是增益，祝你好运".format(iconString(Icon.CLUB)))
    eventPlayer.eventDuration = 0
    if eventPlayer.eventId not in eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)

rule "[VishkarEvent]: 作弊：回溯 (记录位置 - 3秒心跳)":
    @Event eachPlayer
    @Team 1
    @Condition evalOnce(controlRespawnPosition) == null
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_REWIND]) == true
    
    if evalOnce(controlRespawnPosition) != null:
        eventPlayer.eventDuration = 0
        return
    if eventPlayer.eventId not in  eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)
    eventPlayer.controlPlayerRespawnPosition = [eventPlayer.getPosition(), eventPlayer.getFacingDirection(), eventPlayer.getHero()]
    wait(EVT_MECH_11_RECORD_INTERVAL)
    if ruleCondition:
        loop()
    eventPlayer.controlPlayerRespawnPosition = null


rule "[VishkarEvent]: 作弊：回溯 (按键触发)":
    @Event eachPlayer
    @Team 1
    @Condition evalOnce(controlRespawnPosition) == null
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_REWIND, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    damage(eventPlayer, null, eventPlayer.getMaxHealth() * EVT_MECH_11_TRIGGER_HP_COST)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_DISAPPEAR, Color.TEAM_1, eventPlayer, 200)
    wait(0.2)
    eventPlayer.teleport(eventPlayer.controlPlayerRespawnPosition[0])
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, Color.TEAM_1, eventPlayer, 200)
    wait(3)


rule "[VishkarEvent]: 赌徒：短期投资 (交易)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SHORT_INVESTMENT, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_12_WIN_CHANCE:
        eventPlayer.heart_steel += EVT_MECH_12_REWARD_STACKS
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（{2}% 最大生命值）".format(iconString(Icon.CLUB), EVT_MECH_12_REWARD_STACKS, EVT_MECH_12_REWARD_STACKS * EVT_8_HP_PERCENT_PER_STACK))
        setPlayerHP()
    else:
        smallMessage(eventPlayer, "  {0}  输！祝你好运".format(iconString(Icon.DIAMOND)))
    eventPlayer.eventForceRoll = EVT_MECH_12_FORCE_ROLL
    eventPlayer.eventForceCount = EVT_MECH_12_FORCE_COUNT
    smallMessage(eventPlayer, "  {0}  合约已生效：未来 3 个事件为 减益".format(iconString(Icon.DIAMOND)))   
    clearPlayerEvent()


rule "[VishkarEvent]: 命运共同体 (概率同步)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.FATE_SYNC]) == true
    
    eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.eventId == -1]
    if len(eventPlayer.target) > 0:
        eventPlayer.eventForceRoll = random.randint(0, 80)
        eventPlayer.target.eventForceRoll = eventPlayer.eventForceRoll
        smallMessage(getAllPlayers(), "  {0}  {1} 与 {2} 命运相连！下一次事件类别相同".format(abilityIconString(Hero.MAUGA, Button.ULTIMATE), eventPlayer, eventPlayer.target, eventPlayer.eventName))
    wait(0.032) 
    eventPlayer.eventDuration = 0
    clearPlayerEvent()


rule "[VishkarEvent]: 作弊：跳过 (更换英雄)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_SKIP_HERO, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    # todo：传送回重生室
    progressHero()
    if eventPlayer.eventId not in  eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)
    eventPlayer.eventDuration = 0
    clearPlayerEvent()


rule "[VishkarEvent]: 俄罗斯方块 (变大复活)":
    @Event playerDied
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.TETRIS_GROWTH]) == true
    
    eventPlayer.disableRespawn()
    wait(EVT_MECH_15_RESURRECT_DELAY)
    eventPlayer.enableRespawn()
    eventPlayer.resurrect()
    eventPlayer.eventSize++
    eventPlayer.startScalingSize(1 + EVT_MECH_15_SIZE_STEP * eventPlayer.eventSize, false)
    eventPlayer.startModifyingVoicelinePitch(max(EVT_MECH_15_PITCH_MIN, 1 - EVT_MECH_15_PITCH_STEP * eventPlayer.eventSize), false)
    eventPlayer.sizeHealth += EVT_MECH_15_SIZE_HEALTH_STEP
    setPlayerHP()


rule "[VishkarEvent]: 俄罗斯套娃 (变小复活)":
    @Event playerDied
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.NESTING_DOLL]) == true
    
    eventPlayer.disableRespawn()
    wait(EVT_MECH_16_RESURRECT_DELAY)
    eventPlayer.enableRespawn()
    eventPlayer.resurrect()
    eventPlayer.eventSize++
    eventPlayer.startScalingSize(max(EVT_MECH_16_SIZE_MIN, 1 - EVT_MECH_16_SIZE_STEP * eventPlayer.eventSize), false)
    eventPlayer.startModifyingVoicelinePitch(max(EVT_MECH_16_PITCH_MIN, 1 + EVT_MECH_16_PITCH_STEP * eventPlayer.eventSize), false)
    eventPlayer.mod_speed_event += EVT_MECH_16_SPEED_STEP
    updatePlayerStats()


rule "[VishkarEvent]: 作弊：0CD (血量换CD)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_ZERO_COOLDOWN]) == true
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.isUsingAbility2(), eventPlayer.isFiringSecondaryFire()]) == true
    
    if eventPlayer.eventId not in  eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)
    waitUntil(any([eventPlayer.isUsingAbility1(), eventPlayer.isUsingAbility2(), eventPlayer.isFiringSecondaryFire()]) == false, EVT_MECH_17_WAITUNTIL_TIMEOUT)
    damage(eventPlayer, null, eventPlayer.getMaxHealth() * EVT_MECH_17_HP_COST_PERCENT)
    resetPlayerCD()
    playEffect(getAllPlayers(), DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, Color.TEAM_2, eventPlayer, 3)
    wait(0.25)
    if ruleCondition:
        loop()
    clearEventEffect()


rule "[VishkarEvent]: 赌徒：长期投资 (豪赌)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_LONG_INVESTMENT, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if random.randint(0, 99) < EVT_MECH_18_WIN_CHANCE:
        eventPlayer.heart_steel += 20
        smallMessage(eventPlayer, "  {0}  赢！获得 {1} 层心之钢（{2}% 最大生命值）".format(iconString(Icon.CLUB), EVT_MECH_18_REWARD_STACKS, EVT_MECH_18_REWARD_STACKS * EVT_8_HP_PERCENT_PER_STACK))
        setPlayerHP()
    else:
        smallMessage(eventPlayer, "  {0}  输！祝你好运".format(iconString(Icon.DIAMOND)))
    eventPlayer.eventForceRoll = EVT_MECH_18_FORCE_ROLL
    eventPlayer.eventForceCount = EVT_MECH_18_FORCE_COUNT
    smallMessage(eventPlayer, "  {0}  合约已生效：未来 5 个事件为 减益".format(iconString(Icon.DIAMOND)))
    clearPlayerEvent()


rule "[VishkarEvent]: 瓦尔基里降临":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VALKYRIE_DESCENT]) == true
    
    eventPlayer.sizeHealth = EVT_MECH_19_SIZE_HEALTH
    setPlayerHP()
    eventPlayer.heal_recv = EVT_MECH_0_HEAL_BAN
    eventPlayer.mod_heal_event = EVT_MECH_0_HEAL_BAN
    updatePlayerStats()
    eventPlayer.eventMission = eventPlayer.getMaxHealth()
    wait(eventPlayer.eventDuration)
    eventPlayer.sizeHealth = 1
    setPlayerHP()
    eventPlayer.heal_recv = 0
    eventPlayer.mod_heal_event = 0
    updatePlayerStats()
    clearEventEffect()


rule "[VishkarEvent]: 瓦尔基里降临 大招充能":
    @Event playerTookDamage
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VALKYRIE_DESCENT]) == true
    @Condition attacker != eventPlayer
    
    eventPlayer.setUltCharge(eventPlayer.getUltCharge() + EVT_MECH_19_ULT_CHARGE_GAIN)
    wait(EVT_MECH_19_ULT_CHARGE_INTERVAL)


rule "[VishkarEvent]: 瓦尔基里降临 (大招持续回血)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.VALKYRIE_DESCENT, eventPlayer.isUsingUltimate()]) == true
    
    if eventPlayer.eventTargetHP == 0:
        eventPlayer.eventTargetHP = eventPlayer.getMaxHealth()
    eventPlayer.eventTargetHP = eventPlayer.getHealth() + ((eventPlayer.eventTargetHP - eventPlayer.getHealth()) * EVT_MECH_19_HEAL_SMOOTHING)
    while all([eventPlayer.isUsingUltimate(), eventPlayer.getHealth() < eventPlayer.eventTargetHP]):
        eventPlayer.setHealth(min(eventPlayer.eventTargetHP, eventPlayer.getHealth() + eventPlayer.getMaxHealth() * EVT_MECH_19_HEAL_TICK_PERCENT))
        playEffect(getAllPlayers(), DynamicEffect.HEAL_TARGET_ACTIVE, Color.YELLOW, eventPlayer, 60)
        wait(EVT_MECH_19_HEAL_TICK_INTERVAL)

rule "[VishkarEvent]: 三位一体 (SSR)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.TRINITY_SSR]) == true
    
    eventPlayer.mod_dmg_taken = negToPos(min(EVT_MECH_20_DMG_REDUCE_CAP, eventPlayer.getMaxHealth() / EVT_MECH_20_DMG_REDUCE_DIVISOR))
    eventPlayer.mod_speed_event = eventPlayer.mod_dmg_taken * -EVT_MECH_20_SPEED_FACTOR
    updatePlayerStats()
    eventPlayer.heart_steel += EVT_MECH_20_HEART_STEEL_PER_TICK
    setPlayerHP()
    eventPlayer.hudText = "伤害减免：{0}% / 移速加成：{1}% / 心之钢：{2}层".format(negToPos(eventPlayer.mod_dmg_taken), eventPlayer.mod_speed_event, round(eventPlayer.heart_steel))
    wait(EVT_MECH_20_INTERVAL)
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
