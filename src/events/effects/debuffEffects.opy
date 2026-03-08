#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "[VishkarEvent]: 重力异常":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.GRAVITY_ANOMALY]) == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.mod_speed_event = EVT_DEBUFF_0_SPEED
    updatePlayerStats()
    eventPlayer.setGravity(100 + EVT_DEBUFF_0_GRAVITY)
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()
    eventPlayer.setGravity(100)


rule "[VishkarEvent]: 电磁脉冲":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.EMP]) == true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.BASTION, Team.2)[0], Status.HACKED, EVT_DEBUFF_1_HACK_DURATION)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_HACKED_STARTING, Color.TEAM_2, eventPlayer, 200)
    eventPlayer.hack_timer = EVT_DEBUFF_1_HACK_DURATION
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)


rule "[VishkarEvent]: 献祭":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SACRIFICE]) == true
    @Condition [player for player in getLivingPlayers(Team.1) if player.isUsingAbility1() or player.isUsingAbility2()] > 0
    
    eventPlayer.passiveRegenBlocked = true

    playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.TEAM_2, eventPlayer, 200)
    damage(eventPlayer, (sorted([player for player in getLivingPlayers(Team.1) if player.isUsingAbility1() or player.isUsingAbility2()], lambda i: distance(eventPlayer, i)))[0], eventPlayer.getMaxHealth() * EVT_DEBUFF_2_DMG_PERCENT)
    wait(max(0.5, getAverageServerLoad() / 100 * 0.032))
    if ruleCondition:
        loop()
    startCombatRegen()


rule "[VishkarEvent]: 易损":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.VULNERABLE]) == true
    
    createEffect(getAllPlayers(), Effect.ZENYATTA_ORB_OF_DISCORD_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.ZENYATTA_ORB_OF_DISCORD_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    eventPlayer.mod_dmg_taken = EVT_DEBUFF_3_DMG_TAKEN
    wait(getAverageServerLoad() / 100 * 0.032)
    updatePlayerStats()
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()
    clearEventEffect()


rule "[VishkarEvent]: 限速40":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SPEED_LIMIT_40, eventPlayer.isMoving(), eventPlayer.getSpeed() != 0]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    wait(EVT_DEBUFF_4_CHECK_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.hasStatus(Status.BURNING):
        goto lbl_0
    eventPlayer.setStatusEffect(null, Status.BURNING, EVT_DEBUFF_4_BURN_DURATION)
    lbl_0:
    eventPlayer.startDamageOverTime(null, EVT_DEBUFF_4_CHECK_INTERVAL, EVT_DEBUFF_4_DMG_BASE + round(eventPlayer.getMaxHealth() * EVT_DEBUFF_4_DMG_PERCENT))
    wait(0.032)
    if ruleCondition:
        loop()
    eventPlayer.clearStatusEffect(Status.BURNING)
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()


rule "[VishkarEvent]: 引力异常":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.GRAVITY_PULL]) == true
    
    if eventPlayer.mod_speed_event != 0:
        goto lbl_0
    eventPlayer.mod_speed_event -= EVT_DEBUFF_5_SPEED_REDUCTION
    updatePlayerStats()
    lbl_0:
    if eventPlayer.eventEffect != null:
        goto lbl_1
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect[1] = getLastCreatedEntity()
    lbl_1:
    eventPlayer.applyImpulse(directionTowards(eventPlayer, sorted(getPlayers(Team.2), lambda player: distance(eventPlayer, player))[0]), EVT_DEBUFF_5_PULL_AIR if eventPlayer.isInAir() else EVT_DEBUFF_5_PULL_GROUND, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
    clearEventEffect()


rule "[VishkarEvent]: 骨质疏松 Effect":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.OSTEOPOROSIS, eventPlayer.eventEffect == null]) == true

    createEffect(getAllPlayers(), Effect.MEI_FROZEN, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    wait(eventPlayer.eventDuration, Wait.IGNORE_CONDITION)
    clearEventEffect()
    eventPlayer.hudText = ""


rule "[VishkarEvent]: 骨质疏松":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.OSTEOPOROSIS]) == true
    
    while eventPlayer.mod_speed_event != EVT_DEBUFF_6_MAX_SPEED_DEC:
        eventPlayer.mod_speed_event -= EVT_DEBUFF_6_SPEED_DEC_PER_SEC
        eventPlayer.hudText = "移速{0}%".format(eventPlayer.mod_speed_event)
        updatePlayerStats()
        wait(1)
    updatePlayerStats()


rule "[VishkarEvent]: 电磁脉冲 ProMax":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.EMP_PROMAX]) == true
    
    ([player for player in getPlayers(Team.1) if distance(eventPlayer, player) <= EVT_DEBUFF_7_RADIUS]).empProMax = eventPlayer
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_EMP_EXPLOSION_EFFECT, Color.TEAM_2, eventPlayer, 200)
    wait(eventPlayer.eventDuration - 1)
    getPlayers(Team.1).empProMax = null


rule "[VishkarEvent]: 电磁脉冲 ProMax":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.hasStatus(Status.HACKED) != true, eventPlayer.empProMax != null, eventPlayer.hack_timer == 0]) == true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.hack_timer = max(0, EVT_DEBUFF_7_HACK_BASE_DURATION if eventPlayer.empProMax == eventPlayer else EVT_DEBUFF_7_HACK_BASE_DURATION - distance(eventPlayer, eventPlayer.empProMax) * EVT_DEBUFF_7_DIST_FACTOR)
    if eventPlayer.hack_timer <= EVT_DEBUFF_7_MIN_HACK_THRESHOLD:
        goto lbl_0
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_HACKED_STARTING, Color.TEAM_2, eventPlayer, 200)
    lbl_0:
    eventPlayer.setStatusEffect(eventPlayer.empProMax, Status.HACKED, eventPlayer.hack_timer)
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)
    wait(eventPlayer.hack_timer)
    eventPlayer.hack_timer = 0
    eventPlayer.empProMax = null


rule "[VishkarEvent]: 能量泄漏":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.ENERGY_LEAK]) == true
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.isUsingAbility2()]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    wait()
    playEffect(getAllPlayers(), DynamicEffect.ECHO_STICKY_BOMB_EXPLOSION, Color.TEAM_2, eventPlayer, 200)
    damage(eventPlayer, null, eventPlayer.getMaxHealth() * EVT_DEBUFF_8_DMG_PERCENT)
    wait(EVT_DEBUFF_8_COOLDOWN)
    if ruleCondition:
        loop()
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()


rule "[VishkarEvent]: 生命在于静止":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.STILLNESS_IS_LIFE]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    wait()
    damage(eventPlayer, null, ceil(eventPlayer.getMaxHealth() * (EVT_DEBUFF_9_DMG_MOVING if eventPlayer.isMoving() else EVT_DEBUFF_9_DMG_STILL)))
    eventPlayer.setStatusEffect(null, Status.BURNING, EVT_DEBUFF_9_BURN_DURATION)
    wait(EVT_DEBUFF_9_TICK_RATE)
    if ruleCondition:
        loop()
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()


rule "[VishkarEvent]: 有难同当 Effect":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SHARE_THE_PAIN]) == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    wait(eventPlayer.eventDuration)
    clearEventEffect()


rule "[VishkarEvent]: 有难同当":
    @Event playerTookDamage
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SHARE_THE_PAIN]) == true
    @Condition attacker.getHero() == Hero.BASTION
    @Condition eventAbility != null
    
    wait()
    damage([player for player in getLivingPlayers(Team.1) if not player.hasStatus(Status.PHASED_OUT) and not player.hasStatus(Status.INVINCIBLE) and distance(eventPlayer, player) <= EVT_DEBUFF_10_RADIUS and eventPlayer != player], attacker, eventDamage * EVT_DEBUFF_10_DMG_FACTOR)
    wait()


rule "[VishkarEvent]: 狂欢盛宴":
    @Event playerDied
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.FEAST_FRENZY, attacker.getHero() == Hero.BASTION]) == true
    
    bigMessage(getAllPlayers(), "盛宴！")
    smallMessage(getPlayers(Team.1), "  {0} {1} 阵亡触发了狂欢盛宴".format(iconString(Icon.WARNING), eventPlayer))
    getPlayers(Team.2).hasNano = true
    berserkerTime += EVT_DEBUFF_11_BERSERK_ADD
    wait(EVT_DEBUFF_11_COOLDOWN)


rule "[VishkarEvent]: 狂欢盛宴计时器":
    @Condition berserkerTime != 0
    
    wait(2)
    berserkerTime -= 2
    if ruleCondition:
        loop()
    getPlayers(Team.2).hasNano = false
    eventId = -1


rule "[VishkarEvent]: 无能的丈夫/妻子":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.POWERLESS_SPOUSE]) == true
    
    ([player for player in getLivingPlayers(Team.1) if distance(eventPlayer, player) <= EVT_DEBUFF_12_RADIUS and eventPlayer != player]).setStatusEffect(eventPlayer, Status.KNOCKED_DOWN, EVT_DEBUFF_12_KNOCKDOWN_DURATION)
    wait(2)


rule "[VishkarEvent]: 重伤":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.GRIEVOUS_WOUNDS]) == true
    
    eventPlayer.mod_heal_event = EVT_DEBUFF_13_HEAL_DEALT_RED
    eventPlayer.heal_recv = EVT_DEBUFF_13_HEAL_RECV_RED
    updatePlayerStats()
    createEffect(getAllPlayers(), Effect.ANA_BIOTIC_GRENADE_NO_HEALING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND, Color.WHITE, eventPlayer, 200)
    wait(eventPlayer.eventDuration)
    clearEventEffect()
    eventPlayer.mod_heal_event = 0
    eventPlayer.heal_recv = 0
    updatePlayerStats()
    clearEventEffect()


rule "[VishkarEvent]: 减半":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.HALVED, eventPlayer.getHealth() != 0]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    if eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * EVT_DEBUFF_14_EXECUTE_THRESHOLD:
        kill(eventPlayer, eventPlayer)
        playEffect(getAllPlayers(), DynamicEffect.DVA_SELF_DESTRUCT_EXPLOSION, Color.TEAM_2, eventPlayer, 200)
    else:
        wait(EVT_DEBUFF_14_INTERVAL)
        eventPlayer.startDamageOverTime(null, 1, eventPlayer.getHealth() * EVT_DEBUFF_14_DAMAGE_PERCENT)
        playEffect(getAllPlayers(), DynamicEffect.ZARYA_PARTICLE_CANNON_EXPLOSION, Color.TEAM_2, eventPlayer, 3)
    if ruleCondition:
        loop()
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()


rule "[VishkarEvent]: 舍己为人":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SELFLESS_GIVEAWAY]) == true
    
    if eventPlayer.getMaxHealth() <= EVT_DEBUFF_15_MIN_MAX_HP:
        eventPlayer.eventDuration = 0
    else:
        getPlayers(Team.1).exclude(eventPlayer).heart_steel += EVT_DEBUFF_15_STACKS_GIVE
        getPlayers(Team.1).exclude(eventPlayer).setPlayerHP = true
        eventPlayer.heart_steel -= EVT_DEBUFF_15_STACKS_TAKE * len(getPlayers(Team.1).exclude(eventPlayer))
        setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.ORISA_HALT_IMPLOSION, Color.TEAM_1, eventPlayer, 200)
    playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer, 100)
    wait(eventPlayer.eventDuration)


rule "[VishkarEvent]: 舍己为人":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.setPlayerHP]) == true
    
    setPlayerHP()
    eventPlayer.setPlayerHP = false


rule "[VishkarEvent]: 保持距离 (易伤光环)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.KEEP_DISTANCE_AURA]) == true
    
    eventPlayer.target = sorted(getPlayersInRadius(eventPlayer, EVT_DEBUFF_16_RADIUS, Team.1, LosCheck.SURFACES).exclude(eventPlayer), lambda i: distance(eventPlayer, i))[0]
    if eventPlayer.target != null:
        eventPlayer.mod_dmg_taken = min(EVT_DEBUFF_16_MAX, max(0, (EVT_DEBUFF_16_RADIUS - distance(eventPlayer, eventPlayer.target)) * EVT_DEBUFF_16_FACTOR))
        eventPlayer.hudText = "受到伤害 +{0}%".format(eventPlayer.mod_dmg_taken)
    else:
        eventPlayer.mod_dmg_taken = 0
        eventPlayer.hudText = ""
    updatePlayerStats()
    wait(1)
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.hudText = ""
    updatePlayerStats()
    clearEventEffect()


rule "[VishkarEvent]: 404 (随机禁用技能)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.ERROR_404]) == true
    
    if eventPlayer.getHero() == Hero.LIFEWEAVER:
        eventPlayer.eventMission = 3
        goto lbl_1

    if eventPlayer.getHero() == Hero.TORBJORN or eventPlayer.getHero() == Hero.SYMMETRA:
        eventPlayer.eventMission = 2
        goto lbl_1
        
    lbl_0:
    eventPlayer.eventMission = random.randint(1, 3)
    wait()

    lbl_1:
    if eventPlayer.eventMission == 1:
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(false)
        smallMessage(eventPlayer, "  {0}  你的技能 1 已被禁用".format(iconString(Icon.WARNING)))
    elif eventPlayer.eventMission == 2:
        eventPlayer.disallowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(false)
        smallMessage(eventPlayer, "  {0}  你的技能 2 已被禁用".format(iconString(Icon.WARNING)))
    else:
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(false)
        smallMessage(eventPlayer, "  {0}  你的辅助攻击 已被禁用".format(iconString(Icon.WARNING)))
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)
    if eventPlayer.eventMission == 1:
        eventPlayer.allowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(true)
    elif eventPlayer.eventMission == 2:
        eventPlayer.allowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(true)
    else:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.eventMission = 0
    clearEventEffect()


rule "[VishkarEvent]: 连锁过载 (扁平循环版)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.CHAIN_OVERLOAD]) == true
    
    if any([eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0, eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0, eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > 0, eventPlayer.getAbilityCooldown(Button.RELOAD) > 0, eventPlayer.getAbilityCooldown(Button.JUMP) > 0]) == true:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, max(eventPlayer.getAbilityCooldown(Button.ABILITY_1), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, max(eventPlayer.getAbilityCooldown(Button.ABILITY_2), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, max(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, max(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.RELOAD, max(eventPlayer.getAbilityCooldown(Button.RELOAD), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.JUMP, max(eventPlayer.getAbilityCooldown(Button.JUMP), random.randint(15, 30)))
    wait(eventPlayer.eventDuration)
    if ruleCondition:
        loop()
    clearEventEffect()


rule "[VishkarEvent]: 我和你 (生命同步)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.HEALTH_SYNC]) == true
    
    eventPlayer.passiveRegenBlocked = true

    eventPlayer.target = (sorted(getLivingPlayers(Team.1).exclude(eventPlayer), lambda i: i.getHealth() / i.getMaxHealth()))[0]

    if eventPlayer.target != null:
        if eventPlayer.getHealth() / eventPlayer.getMaxHealth() > eventPlayer.target.getHealth() / eventPlayer.target.getMaxHealth():
        eventPlayer.setHealth(eventPlayer.getMaxHealth() * (eventPlayer.target.getHealth() / eventPlayer.target.getMaxHealth()))
    wait(1)
    if ruleCondition:
        loop()
    clearEventEffect()
    eventPlayer.target = null
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()


rule "[VishkarEvent]: 吸血鬼 (按需吸血)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.VAMPIRE, eventPlayer.getNormalizedHealth() != 1]) == true
    
    eventPlayer.passiveRegenBlocked = true
    
    eventPlayer.target = [i for i in getPlayersInRadius(eventPlayer, EVT_DEBUFF_20_RADIUS, Team.1, LosCheck.SURFACES).exclude(eventPlayer) if i.isAlive()]
    if len(eventPlayer.target) > 0:
        damage(eventPlayer.target, eventPlayer, EVT_DEBUFF_20_DAMAGE_PER_TARGET)
        heal(eventPlayer, eventPlayer.target, len(eventPlayer.target) * EVT_DEBUFF_20_HEAL_PER_TARGET)
        eventPlayer.dlcTimeChallenge[4] += len(eventPlayer.target) * EVT_DEBUFF_20_DAMAGE_PER_TARGET
        playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.RED, eventPlayer.target, 200)
    wait(EVT_DEBUFF_20_INTERVAL)
    if ruleCondition:
        loop()
    clearEventEffect()
    eventPlayer.target = null
    eventPlayer.passiveRegenBlocked = false
    startCombatRegen()


rule "[VishkarEvent]: 成吨的减益 (全属性削弱)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.TONS_OF_DEBUFFS]) == true
    
    eventPlayer.mod_speed_event -= 50
    eventPlayer.mod_dmg_taken += 50
    eventPlayer.mod_heal_event -= 50
    eventPlayer.heal_recv -= 50
    # createEffect(getAllPlayers(), Effect.ZENYATTA_ORB_OF_DISCORD_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    # eventPlayer.eventEffect.append(getLastCreatedEntity())
    # createEffect(getAllPlayers(), Effect.ZENYATTA_ORB_OF_DISCORD_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    # eventPlayer.eventEffect.append(getLastCreatedEntity())
    # createEffect(getAllPlayers(), Effect.ANA_BIOTIC_GRENADE_NO_HEALING, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    # eventPlayer.eventEffect.append(getLastCreatedEntity())
    playEffect(eventPlayer, DynamicEffect.ANA_BIOTIC_GRENAGE_NO_HEALING_SOUND, Color.WHITE, eventPlayer, 200)
    # createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    # eventPlayer.eventEffect.append(getLastCreatedEntity())
    # createEffect(getAllPlayers(), Effect.SIGMA_GRAVITIC_FLUX_TARGET_SOUND, Color.TEAM_2, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    # eventPlayer.eventEffect.append(getLastCreatedEntity())
    updatePlayerStats()
    eventPlayer.sizeHealth = 0.5
    setPlayerHP()
    wait(eventPlayer.eventDuration)
    eventPlayer.mod_speed_event += 50
    eventPlayer.mod_dmg_taken -= 50
    eventPlayer.mod_heal_event += 50
    eventPlayer.heal_recv += 50
    eventPlayer.sizeHealth = 1
    setPlayerHP()
    updatePlayerStats()
    clearEventEffect()


rule "[VishkarEvent]: 登月火箭":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.MOON_ROCKET]) == true

    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    eventPlayer.setGravity(EVT_DEBUFF_22_GRAVITY)
    eventPlayer.applyImpulse(Vector.UP, EVT_DEBUFF_22_UPWARD_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(eventPlayer.eventDuration)
    eventPlayer.stopForcingThrottle()
    eventPlayer.setGravity(100)
