#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Player"

#!define ULT_SYNC_DT_MIN 0.1
#!define ULT_SYNC_DT_MAX 0.5

subroutine resetPlayerEventState
subroutine resetPlayerProgressState
subroutine resetPlayerSavedState
subroutine finishResetProgress

def resetPlayerEventState():
    @Name "[VishkarEvent]: reset player event state"

    eventPlayer.eventCompatibleBasePool = null
    clearPlayerEvent()
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.REGROUP_CALL])
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.DEV_TOOL])
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.invincibleEffect = DEFAULT_INVINCIBLE_EFFECTS.slice(0, InvincibleEffectSlot.COUNT)
    eventPlayer.nanoEffect = null
    eventPlayer.hasNano = false
    eventPlayer.eventLastId = []
    eventPlayer.eventCount = [0, 0, 0]
    eventPlayer.eventLucky = 0
    eventPlayer.eventDurationHud = 0
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    eventPlayer.eventCandidateIndex = null
    eventPlayer.eventTempIndex = []
    eventPlayer.eventNextIndex = null
    wait(getAverageServerLoad() / 100 * 0.032)

def resetPlayerProgressState():
    @Name "[VishkarEvent]: reset player progress state"

    eventPlayer.heroNumber = 0
    eventPlayer.progressionDeathCount = 0
    eventPlayer.skipCount = 0
    eventPlayer.runDeathCount = 0
    eventPlayer.isWinner = false
    eventPlayer.winnerTime = 0
    eventPlayer.dmgReduc = false
    eventPlayer.invincible = false
    eventPlayer.isAirWalkEnabled = false
    eventPlayer.isPortalEnabled = false
    eventPlayer.controlJumpIndex = 0
    eventPlayer.controlPlayerRespawnPosition = null
    eventPlayer.mod_speed_perma = 0
    eventPlayer.mod_dmg_perma = 0
    eventPlayer.mod_heal_perma = 0
    eventPlayer.heart_steel = DEFAULT_HEART_STEEL_DATA.slice(0, HeartSteelData.COUNT)
    eventPlayer.possess = null
    eventPlayer.possessed = []
    # dlcTimeChallenge: [0:窃贼]
    eventPlayer.dlcTimeChallenge = [0]
    eventPlayer.eventForceRoll = null
    eventPlayer.eventForceCount = 0
    eventPlayer.playerOnceEventState = DEFAULT_PLAYER_ONCE_EVENT_STATE.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
    PROFILE_RESET_ACHIEVEMENT_STATE()
    PROFILE_RESET_ACHIEVEMENT_LIST()
    eventPlayer.thiefBuffStolen = false
    wait(getAverageServerLoad() / 100 * 0.032)
    setPlayerHP()
    updatePlayerStats()
    wait(getAverageServerLoad() / 100 * 0.032)

def resetPlayerSavedState():
    @Name "[VishkarEvent]: reset player saved state"

    if not eventPlayer.inSaved(savedIndex):
        return

    savedData.savedHero[eventPlayer.savedIndex(savedIndex)] = 0
    savedData.savedDeaths[eventPlayer.savedIndex(savedIndex)] = 0
    savedData.savedWinner[eventPlayer.savedIndex(savedIndex)] = false
    savedData.savedSkipCount[eventPlayer.savedIndex(savedIndex)] = 0
    savedData.savedJoinTime[eventPlayer.savedIndex(savedIndex)] = eventPlayer.joinTime
    savedData.savedWinnerTime[eventPlayer.savedIndex(savedIndex)] = 0
    savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)] = DEFAULT_PLAYER_ONCE_EVENT_STATE.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
    wait(getAverageServerLoad() / 100 * 0.032)

def finishResetProgress():
    @Name "[VishkarEvent]: finish reset progress"

    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.startForcingHero(heroList[0])
    wait()
    eventPlayer.stopForcingCurrentHero()
    # 与 progressHero 一致：换英雄后按大厅配置重断言技能可用性，清除粘性覆盖标志
    if eventPlayer.possess == null:
        eventPlayer.setAbility1Enabled(heroList[0] not in [Hero.TORBJORN, Hero.SYMMETRA])
        eventPlayer.setAbility2Enabled(heroList[0] != Hero.LIFEWEAVER or PROFILE_LIFEWEAVER_GRIP_ELIGIBLE(eventPlayer))
    wait(getServerLoad() / 100 * 0.5)
    eventPlayer.setAllowedHeroes(heroList.slice(0, 1))
    refreshCompatibleEventPool()


rule "Track progression death":
    @Event playerDied
    @Team 2
    @Condition all([eventPlayer.getHero() == heroList[eventPlayer.heroNumber], eventPlayer.progressionDeathCount < maxDeath, eventPlayer.heroNumber + 1 < len(heroList), attacker != null, attacker != eventPlayer]) == true
    
    eventPlayer.progressionDeathCount++


rule "Sync ult progress":
    @Event eachPlayer
    @Team 2
    @Condition difficulty != 5
    @Condition eventPlayer.eventId != EventId.ULT_MOMENTUM
    @Condition eventPlayer.progressionDeathCount < maxDeath
    @Condition eventPlayer.isWinner == false
    @Condition (eventPlayer.getHero() == Hero.DVA and eventPlayer.isInAlternateForm()) == false
    @Condition round(eventPlayer.getUltCharge() / (100 / maxDeath)) != eventPlayer.progressionDeathCount
    
    wait(random.uniform(ULT_SYNC_DT_MIN, ULT_SYNC_DT_MAX), Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100 * eventPlayer.progressionDeathCount / maxDeath)
    if ruleCondition:
        loop()


rule "Display skip ready":
    @Event eachPlayer
    @Team 2
    @Condition difficulty != 5
    @Condition eventPlayer.eventId != EventId.ULT_MOMENTUM
    @Condition eventPlayer.progressionDeathCount == maxDeath
    @Condition eventPlayer.heroNumber + 1 < len(heroList)
    @Condition (eventPlayer.getHero() == Hero.DVA and eventPlayer.isInAlternateForm()) == false
    @Condition eventPlayer.isAlive() == true
    
    wait(getAverageServerLoad() / 100)
    if eventPlayer.getUltCharge() == 100:
        eventPlayer.setUltCharge(0)
        wait(0.2)
    bigMessage(eventPlayer, STR_MSG_SKIP_AVAILABLE)
    eventPlayer.I = 0
    while eventPlayer.getUltCharge() != 100:
        eventPlayer.setUltCharge(100)
        wait(0.05)
        eventPlayer.I++
        if I == 5:
            return


rule "Skip hero with ultimate":
    @Event eachPlayer
    @Team 2
    @Condition difficulty != 5
    @Condition eventPlayer.progressionDeathCount >= maxDeath
    @Condition (eventPlayer.isUsingUltimate() or eventPlayer.isDuplicatingAHero()) == true
    @Condition eventPlayer.heroNumber + 1 < len(heroList)
    @Condition eventPlayer.getHero() != Hero.BASTION
    
    wait(1)
    eventPlayer.respawn()
    eventPlayer.progressionDeathCount = 0
    eventPlayer.skipCount++
    progressHero()



rule "Display reset hint":
    @Event eachPlayer
    @Team 2
    @Condition (eventPlayer.heroNumber > 0 or eventPlayer.runDeathCount > 0) == true
    @Condition eventPlayer in getPlayersInRadius(resetPosition, 20, Team.2) == true
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), resetPosition * vect(1, 0, 1)) <= 1.2
    
    bigMessage(eventPlayer, STR_MSG_HOLD_RELOAD_RESET)


rule "Reset progress":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition (eventPlayer.runDeathCount > 0 or eventPlayer.heroNumber > 0) == true
    @Condition distance(eventPlayer * vect(1, 0, 1), resetPosition * vect(1, 0, 1)) <= 1.2
    
    eventPlayer.preloadHero(heroList[0])
    smallMessage(eventPlayer, STR_MSG_RESETTING_PROGRESS)
    wait(2, Wait.ABORT_WHEN_FALSE)
    playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, null, eventPlayer.getPosition(), 100)
    resetPlayerEventState()
    resetPlayerProgressState()
    resetPlayerSavedState()
    smallMessage(getAllPlayers(), STR_MSG_PLAYER_RESET_PROGRESS.format(eventPlayer))
    finishResetProgress()
