#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Player"


rule "Track progression death":
    @Event playerDied
    @Team 1
    @Condition all([eventPlayer.getHero() == heroList[eventPlayer.heroNumber], eventPlayer.progressionDeathCount < maxDeath, eventPlayer.heroNumber + 1 < len(heroList), attacker != null, attacker != eventPlayer]) == true
    
    eventPlayer.progressionDeathCount++


rule "Sync ult progress":
    @Event eachPlayer
    @Team 1
    @Condition difficulty != 5
    @Condition all([dlcVishkarEvent, eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM]) == false
    @Condition not (eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_REWARD and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.ULT)
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
    @Condition all([dlcVishkarEvent, eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.ULT_MOMENTUM]) != true
    @Condition not (eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_REWARD and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.ULT)
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
    @Condition not (eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_REWARD and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.ULT)
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
    eventPlayer.runDeathCount = 0
    eventPlayer.progressionDeathCount = 0
    eventPlayer.isWinner = false
    eventPlayer.winnerTime = 0
    eventPlayer.heroNumber = 0
    eventPlayer.skipCount = 0
    while len(eventPlayer.playerOnceEventState) < PLAYER_ONCE_EVENT_SLOT_COUNT:
        eventPlayer.playerOnceEventState.append(DEFAULT_PLAYER_ONCE_EVENT_STATE[len(eventPlayer.playerOnceEventState)])
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] = TemperHeartState.NONE
    if eventPlayer.inSaved(savedIndex) and savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)] != null:
        while len(savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)]) < PLAYER_ONCE_EVENT_SLOT_COUNT:
            savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)].append(DEFAULT_PLAYER_ONCE_EVENT_STATE[len(savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)])])
        savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)][PlayerOnceEventSlot.TEMPER_HEART] = TemperHeartState.NONE
    smallMessage(getAllPlayers(), STR_MSG_PLAYER_RESET_PROGRESS.format(eventPlayer))
    wait()
    eventPlayer.startForcingHero(heroList[0])
    wait()
    eventPlayer.stopForcingCurrentHero()
    wait(getServerLoad() / 100 * 0.5)
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    savePlayerData()
