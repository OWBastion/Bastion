#!mainFile "../main.opy"


#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "bastion init position, unkillable status, and damage dealt scaling with difficulty setting":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    
    wait(0.25)
    eventPlayer.setDamageDealt(100 + 50 * difficulty)
    eventPlayer.teleport(bastionPosition[eventPlayer.getSlot()])
    if not eventPlayer.hasStatus(Status.UNKILLABLE):
        eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 99999)
        eventPlayer.setKnockbackReceived(1)


rule "infinite match time":
    @Condition isInSetup() == false
    
    if not debugMode:
        disableInspector()
    disableGamemodeCompletion()
    disableAnnouncer()
    disableMusic()
    disableScoring()
    wait(1)
    pauseMatchTime()
    setSlowMotion(90)


rule "if someone starts the game mode, restart the match":
    @Condition getCurrentGamemode() != Gamemode.SKIRMISH
    @Condition (isInSetup() or isAssemblingHeroes() or isGameInProgress()) == true
    
    disableAnnouncer()
    wait()
    destroyAllDummies()
    destroyAllEffects()
    destroyAllHudTexts()
    destroyAllIcons()
    destroyAllInWorldTexts()
    destroyAllProgressBarHuds()
    wait()
    getPlayers(Team.1).disableMessages()
    getPlayers(Team.1).disableGamemodeHud()
    getPlayers(Team.1).disableGamemodeInWorldUi()
    getPlayers(Team.1).disableRespawn()
    unpauseMatchTime()
    while not isGameInProgress():
        setMatchTime(0)
        wait()
    createIcon(getPlayers(Team.1), vect(0, 101, -0.25), Icon.WARNING, IconReeval.COLOR, rgb(220 + sin(getTotalTimeElapsed() * 3.141) * 35, 0, 0), false)
    createInWorldText(getPlayers(Team.1), STR_TEXT_HOST_RESTARTING, vect(0, 101, 0), 3, Clip.NONE, WorldTextReeval.COLOR, rgb(220 + sin(getTotalTimeElapsed() * 3.141) * 35, 0, 0), SpecVisibility.ALWAYS)
    for I in range(5):
        createEffect(getPlayers(Team.1), Effect.ORB, Color.BLACK, vect(0, 100 + ((0.5 * (I + 1)) / 5), 0), 2 + (2 * (I + 5)), EffectReeval.NONE)
        createEffect(getPlayers(Team.1), Effect.SPHERE, Color.BLACK, vect(0, 100, 0), 2 + (2 * (I + 5)), EffectReeval.NONE)
        createEffect(getPlayers(Team.1), Effect.BAD_AURA, Color.BLACK, vect(0, 100 + ((3 * (I + 1)) / 5), 0), 2 + (2 * (I + 5)), EffectReeval.NONE)
        wait()
    getPlayers(Team.1).startForcingHero(Hero.SOMBRA)
    wait()
    kill(getPlayers(Team.1), hostPlayer)
    getPlayers(Team.1).disableHeroHud()
    getPlayers(Team.1).startCamera(vect(0, 100, 0), vect(0, 101, 0.01))
    wait(5)
    enableMusic()
    declareTeamVictory(Team.2)
    destroyAllInWorldTexts()
    destroyAllIcons()
    wait(2)
    waitUntil(getTotalTimeElapsed() > 30, 30)
    restartMatch()

rule "bastions are numbered and list their kills (by changing their names when they spawn)":
    @Event playerJoined
    @Team 2
    
    eventPlayer.startForcingName(STR_BOT_NAME_FORMAT.format(eventPlayer.getSlot() + 1, kills[eventPlayer.getSlot()]))


rule "damage modifier: players can't hurt bastions":
    @Condition difficulty != 5
    @Condition dmgReduction == false
    
    startDamageModification(getPlayers(Team.2), [player for player in getPlayers(Team.1) if not "{0}".format(player) in devList], 0.1, DamageReeval.RECEIVERS_AND_DAMAGERS)


rule "disable gamemode hud and player collision for all players":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    
    eventPlayer.disableGamemodeHud()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disablePlayerCollision()


# 可调参数
## 威胁态心跳间隔
#!define FORM_FIX_DT_THREAT 0.064
## 安全态心跳间隔
#!define FORM_FIX_DT_SAFE 0.25
## 关键：威胁态保持时间 防止 target 瞬断导致窗口期
#!define THREAT_HOLD_SEC 1.0
## 快速纠正次数上限
#!define BURST_MAX 2
## 快速纠正间隔
#!define BURST_DT 0.032

## 当前循环内的“是否威胁态”
macro isThreat(target):
    (target != null) or (getTotalTimeElapsed() - eventPlayer.lastThreatTime <= THREAT_HOLD_SEC)

rule "enemy bastions must stay in configuration: assault (AKA machine gun/sentry/alternate form)":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition getTotalTimeElapsed() > 10
    # 必须技能冷却完成才会触发本规则
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) == 0
    # @Condition eventPlayer.isInAlternateForm() == false

    if eventPlayer.target != null:
        eventPlayer.lastThreatTime = getTotalTimeElapsed()
    
    #this cancels bastion's "standing up" animation so he can sit back down faster
    if eventPlayer.isInAlternateForm() == false:
        eventPlayer.cancelPrimaryAction()
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
        eventPlayer.forceButtonPress(Button.ABILITY_1)
    
    
    wait(FORM_FIX_DT_THREAT if isThreat(eventPlayer.target) else FORM_FIX_DT_SAFE, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()


rule "bastions periodically refresh their configuration when there are enemies nearby but out of sight":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition getTotalTimeElapsed() > 10
    @Condition eventPlayer.isInAlternateForm() == false
    @Condition eventPlayer.target == false
    @Condition getPlayersInRadius(eventPlayer.getPosition(), 110, Team.1)[0] != false
    
    wait(random.uniform(0.2, 1), Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait(random.uniform(1, 3))
    if ruleCondition:
        loop()


#!define SCAN_DT_NO_TARGET_MIN 0.06
#!define SCAN_DT_NO_TARGET_MAX 0.12
#!define SCAN_DT_HAS_TARGET_MIN 0.20
#!define SCAN_DT_HAS_TARGET_MAX 0.35

macro isBastionTargetEligible(target):
    target != null and target.hasSpawned() and not target.isWinner and not target.hasStatus(Status.PHASED_OUT) and not target.targetSilence and distance(eventPlayer, target) < 100

macro hasBastionTargetLoS(target):
    isInLoS(eventPlayer.getEyePosition(), target.getEyePosition()) or isInLoS(eventPlayer.getEyePosition(), target.getPosition())

rule "bastion constantly searches for targets in line of sight":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true

    wait(random.uniform(
        SCAN_DT_HAS_TARGET_MIN if eventPlayer.target != null else SCAN_DT_NO_TARGET_MIN,
        SCAN_DT_HAS_TARGET_MAX if eventPlayer.target != null else SCAN_DT_NO_TARGET_MAX
    ), Wait.IGNORE_CONDITION)

    if isBastionTargetEligible(eventPlayer.target) and hasBastionTargetLoS(eventPlayer.target):
        goto lbl_1

    if getPlayersInRadius(eventPlayer.getEyePosition(), 105, Team.1, LosCheck.SURFACES)[0] == false:
        eventPlayer.target = null
        wait(random.uniform(SCAN_DT_NO_TARGET_MIN, SCAN_DT_NO_TARGET_MAX), Wait.ABORT_WHEN_FALSE)
        loop()
    
    eventPlayer.temp = [player for player in getLivingPlayers(Team.1) if player.hasSpawned() and not player.isWinner and not player.hasStatus(Status.PHASED_OUT) and not player.targetSilence and distance(eventPlayer, player) < 100]
    wait()
    eventPlayer.temp = [player for player in eventPlayer.temp if hasBastionTargetLoS(player)]
    wait()

    if not eventPlayer.temp:
        eventPlayer.target = null
        goto lbl_1

    if len(eventPlayer.temp) > 1:
        if not dlcVishkarEvent:
            eventPlayer.temp = sorted(eventPlayer.temp, lambda player: player.getHealth() * distance(eventPlayer, player) if bastionBotTargetPrefer == 0 else distance(eventPlayer, player) if bastionBotTargetPrefer == 1 else player.getHealth())
        else:
            eventPlayer.temp = sorted(eventPlayer.temp, lambda player: player.targetWeight * -1)
        eventPlayer.target = eventPlayer.temp[0]
        wait()
    elif eventPlayer.temp[0] != null:
        eventPlayer.target = eventPlayer.temp[0]
    else:
        eventPlayer.target = null

    lbl_1:
    wait(0.2)
    if ruleCondition:
        loop()
    eventPlayer.target = null


rule "bastion fires if he has a target":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasNano != true
    @Condition eventPlayer.isFiringPrimaryFire() == false
    @Condition eventPlayer.target != false
    
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(0.5)
    if ruleCondition:
        loop()


rule "bastion stops firing when there aren't targets":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.target == false
    @Condition eventPlayer.isAlive() == true
    
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(1, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isFiringPrimaryFire():
        loop()


rule "bastion secondary fires if he has a target":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition any([difficulty == 5, bastionBotSeconFire]) == true
    @Condition eventPlayer.hasNano == false
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isFiringPrimaryFire() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    @Condition eventPlayer.target != false
    
    wait(random.uniform(0.032, 0.16), Wait.ABORT_WHEN_FALSE)
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    wait(1.488)
    if ruleCondition:
        loop()


rule "bastion secondary fires if he has nano":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.hasNano == true
    @Condition getPlayersInRadius(eventPlayer.getEyePosition(), 150, Team.1)[0] != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) == 0
    
    wait(random.uniform(0.016, 0.032), Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    if eventPlayer.target == null:
        goto lbl_0
    lbl_0:
    wait(getAverageServerLoad() / 100 * 0.032)
    if ruleCondition:
        loop()
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)


rule "bastion aims at whichever part of his target is most exposed":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.target != null
    
    eventPlayer.tempAimPosition = (eventPlayer.target.getPosition() + eventPlayer.target.getEyePosition()) / 2
    if isInLoS(eventPlayer.getEyePosition(), eventPlayer.tempAimPosition):
        eventPlayer.aimPosition = eventPlayer.tempAimPosition
    elif isInLoS(eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition()):
        eventPlayer.aimPosition = eventPlayer.target.getEyePosition()
    else:
        eventPlayer.aimPosition = eventPlayer.target.getPosition()
    wait(0.064)
    if ruleCondition:
        loop()


rule "bastion places his crosshair near the closest potential target if he doesn't currently have one":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.target == false
    
    wait(getAverageServerLoad() / 100, Wait.ABORT_WHEN_FALSE)
    #eventPlayer.nearestTargetOutOfLoS = (sorted([player for player in getLivingPlayers(Team.1) if player.hasSpawned() and not eventPlayer.isWinner and (not (player.getHero() == Hero.SOMBRA and player.isUsingAbility1()))], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]
    eventPlayer.nearestTargetOutOfLoS = (sorted([player for player in getLivingPlayers(Team.1) if player.hasSpawned() and not eventPlayer.isWinner], lambda i: distance(eventPlayer.getEyePosition(), i.getEyePosition())))[0]
    if eventPlayer.nearestTargetOutOfLoS == null:
        goto lbl_0
    eventPlayer.aimPosition = eventPlayer.nearestTargetOutOfLoS.getEyePosition() + vect(random.uniform(-1, 1), random.uniform(-1, 1), random.uniform(-1, 1))
    lbl_0:
    wait(random.uniform(1, 4))
    if ruleCondition:
        loop()


rule "determine bastion's aim speed, to improve smooth tracking":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.target != false
    
    eventPlayer.turnSpeed = angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.target.getEyePosition())) * turnSpeedMultiplier
    eventPlayer.turnSpeed += eventPlayer.target.getSpeed() * turnSpeedMultiplier
    wait(max(0.016, getAverageServerLoad() / 1000))
    if ruleCondition:
        loop()


rule "increase bastion's aim speed to prep for flicking to a target entering range":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.target == false
    @Condition eventPlayer.aimPosition != null
    @Condition angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.aimPosition)) >= 1
    
    eventPlayer.turnSpeed = angleBetweenVectors(eventPlayer.getFacingDirection(), directionTowards(eventPlayer.getEyePosition(), eventPlayer.aimPosition) * turnSpeedMultiplier)
    wait(getPeakServerLoad() / 1000)
    if ruleCondition:
        loop()


rule "start facing bastion bots":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isDummy() != false
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.hasSpawned() == true
    @Condition getTotalTimeElapsed() > 10
    
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), eventPlayer.aimPosition), 0 if eventPlayer.hasStatus(Status.ASLEEP) else eventPlayer.turnSpeed)


rule "set bastion's target to null once he kills them":
    @Event playerDealtFinalBlow
    @Team 2
    
    eventPlayer.target = null
    eventPlayer.nearestTargetOutOfLoS = null


rule "bastion punches the ground a few times at first to destroy railings":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition getTotalTimeElapsed() < 10
    @Condition getTotalTimeElapsed() > 5
    
    eventPlayer.setFacing(Vector.DOWN, Relativity.TO_WORLD)
    for eventPlayer.I in range(3):
        eventPlayer.forceButtonPress(Button.MELEE)
        wait(1.2)


rule "bastion fully heals periodically":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.getNormalizedHealth() < 1
    
    wait(60)
    eventPlayer.startHealingOverTime(null, 59.5, 9999)
    if ruleCondition:
        loop()


rule "bastion immediately respawns upon death":
    @Event playerDied
    @Team 2
    @Hero bastion
    
    wait()
    eventPlayer.respawn()


rule "teleport bastions back and reset velocity when they are displaced":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition distance(eventPlayer.getPosition(), bastionPosition[eventPlayer.getSlot()]) > 2
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.isInPosition = false
    eventPlayer.enableEnvironmentCollision()
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 7)
    eventPlayer.teleport(bastionPosition[eventPlayer.getSlot()])
    wait()
    eventPlayer.startForcingPosition(bastionPosition[eventPlayer.getSlot()], false)
    wait()
    waitUntil(eventPlayer.getSpeed() < 1, 2)
    eventPlayer.stopForcingPosition()
    if ruleCondition:
        loop()


rule "bastions stay where they initially land":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition getTotalTimeElapsed() > 10
    @Condition eventPlayer.isInPosition == false
    @Condition eventPlayer.isMoving() == false
    
    wait(5, Wait.ABORT_WHEN_FALSE)
    waitUntil(eventPlayer.isUsingAbility1(), 2)
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.startForcingPosition(eventPlayer.getPosition(), false)
    eventPlayer.disableEnvironmentCollision(true)
    eventPlayer.isInPosition = true


rule "bastions whose position is far above the ground instead stay at that position":
    @Event eachPlayer
    @Team 2
    @Hero bastion
    @Condition eventPlayer.isInPosition == false
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition distance(raycast(bastionPosition[eventPlayer.getSlot()] + Vector.UP, bastionPosition[eventPlayer.getSlot()] + Vector.DOWN * 5, null, null, false).getHitPosition(), bastionPosition[eventPlayer.getSlot()] + Vector.DOWN * 5) == 0
    
    eventPlayer.teleport(bastionPosition[eventPlayer.getSlot()])
    wait()
    eventPlayer.startForcingPosition(bastionPosition[eventPlayer.getSlot()], false)


rule "bastion A-36 Tactical Grenade hit player":
    @Event playerTookDamage
    @Team 1
    @Condition any([difficulty == 5, bastionBotSeconFire, dlcVishkarEvent]) == true
    @Condition attacker.getHero() == Hero.BASTION
    @Condition attacker != eventPlayer
    @Condition eventAbility == Button.SECONDARY_FIRE
    
    if not attacker.hasNano:
        goto lbl_0
    eventPlayer.setStatusEffect(attacker, Status.BURNING, 3)
    eventPlayer.startDamageOverTime(attacker, 3, ceil(ceil(victim.getMaxHealth() * 0.5 / 3) / 4))
    lbl_0:
    wait()


rule "push players away from bastions":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.debugInfo != true
    @Condition getPlayersInRadius(eventPlayer, 2, Team.2)[0] != false
    
    eventPlayer.applyImpulse(directionFromAngles(horizontalAngleOfDirection(eventPlayer.getPosition() - getRealClosestPlayer(eventPlayer, Team.2).getPosition()), -20), 15, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.5, Wait.RESTART_WHEN_TRUE)

rule "bastion counts kills and marks himself after killing you":
    @Event playerDealtFinalBlow
    @Team 2
    
    kills[eventPlayer.getSlot()]++
    eventPlayer.startForcingName(STR_BOT_NAME_FORMAT.format(eventPlayer.getSlot() + 1, kills[eventPlayer.getSlot()]))
    victim.attacker.stopForcingOutlineFor(victim)
    wait(0.032)
    victim.attacker = attacker
    victim.attacker.startForcingOutlineFor(victim, true, Color.RED, OutlineVisibility.ALWAYS)
