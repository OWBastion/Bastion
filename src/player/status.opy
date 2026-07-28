#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Player"

subroutine resetPlayerEventState
subroutine resetPlayerProgressState
subroutine resetPlayerSavedState
subroutine finishResetProgress

def resetPlayerEventState():
    @Name "[VishkarEvent]: reset player event state"

    clearPlayerEvent()
    destroyEffect(eventPlayer.invincibleEffect)
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.invincibleEffect = null
    eventPlayer.nanoEffect = null
    eventPlayer.hasNano = false
    eventPlayer.eventLastId = []
    eventPlayer.eventCount = [0, 0, 0]
    eventPlayer.eventLucky = 0
    eventPlayer.eventDurationHud = 0
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    eventPlayer.eventTempId = []
    eventPlayer.eventTempWeight = 0
    eventPlayer.categoryRoll = null
    eventPlayer.categoryRollSnapshot = null
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
    # dlcTimeChallenge: [0:赌徒竞速, 1:吸血鬼吸血量, 2:作弊事件ID, 3:赌徒总胜, 4:赌徒总负, 5:短期投资胜, 6:长期投资胜, 7:有难同当, 8:掷骰狂人, 9:舍己为人, 10:登月火箭, 11:保持距离, 12:EMP_ProMax, 13:吸血鬼击杀, 14:窃贼]
    eventPlayer.dlcTimeChallenge = [0, 0, [], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    eventPlayer.eventForceRoll = null
    eventPlayer.eventForceCount = 0
    eventPlayer.playerOnceEventState = DEFAULT_PLAYER_ONCE_EVENT_STATE.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
    eventPlayer.tempUnlockId = null
    eventPlayer.earnedAchievements = []
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
    wait(getServerLoad() / 100 * 0.5)
    eventPlayer.setAllowedHeroes(heroList.slice(0, 1))


rule "Track progression death":
    @Event playerDied
    @Team 1
    @Condition all([eventPlayer.getHero() == heroList[eventPlayer.heroNumber], eventPlayer.progressionDeathCount < maxDeath, eventPlayer.heroNumber + 1 < len(heroList), attacker != null, attacker != eventPlayer]) == true
    
    eventPlayer.progressionDeathCount++


rule "Sync ult progress":
    @Event eachPlayer
    @Team 1
    @Condition difficulty != 5
    @Condition not (eventPlayer.eventType == EventType.BUFF and eventPlayer.eventId == BuffEventId.ULT_MOMENTUM)
    @Condition eventPlayer.progressionDeathCount < maxDeath
    @Condition eventPlayer.isWinner == false
    @Condition (eventPlayer.getHero() == Hero.DVA and eventPlayer.isInAlternateForm()) == false
    @Condition round(eventPlayer.getUltCharge() / (100 / maxDeath)) != eventPlayer.progressionDeathCount
    
    wait(random.uniform(0.1, 0.5) * getAverageServerLoad() / 100, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(100 * eventPlayer.progressionDeathCount / maxDeath)
    if ruleCondition:
        loop()


rule "Display skip ready":
    @Event eachPlayer
    @Team 1
    @Condition difficulty != 5
    @Condition not (eventPlayer.eventType == EventType.BUFF and eventPlayer.eventId == BuffEventId.ULT_MOMENTUM)
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
    @Team 1
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
    @Team 1
    @Condition (eventPlayer.heroNumber > 0 or eventPlayer.runDeathCount > 0) == true
    @Condition eventPlayer in getPlayersInRadius(resetPosition, 20, Team.1) == true
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), resetPosition * vect(1, 0, 1)) <= 1.2
    
    bigMessage(eventPlayer, STR_MSG_HOLD_RELOAD_RESET)


rule "Reset progress":
    @Event eachPlayer
    @Team 1
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
