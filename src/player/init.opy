#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "when a player joins, load player data if they have it and initialize them":
    @Event playerJoined
    @Team 1
    
    eventPlayer.isDev = eventPlayer.key in devList
    if not dlcVishkarEvent:
        goto lbl_0
    eventPlayer.eventId = -1
    eventPlayer.eventLastId = []
    eventPlayer.playerOnceEventState = DEFAULT_PLAYER_ONCE_EVENT_STATE.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
    eventPlayer.heart_steel = DEFAULT_HEART_STEEL_DATA.slice(0, HeartSteelData.COUNT)
    eventPlayer.sizeHealth = 1
    eventPlayer.earnedAchievements = []
    lbl_0:
    wait(getAverageServerLoad() / 200 * random.uniform(1, 3))
    if eventPlayer.inSaved(savedIndex):
        eventPlayer.heroNumber = savedData.savedHero[eventPlayer.savedIndex(savedIndex)]
        wait(eventPlayer.getSlot() * 0.032 + random.uniform(1, 3) * 0.05)
        eventPlayer.runDeathCount = savedData.savedDeaths[eventPlayer.savedIndex(savedIndex)]
        eventPlayer.isWinner = savedData.savedWinner[eventPlayer.savedIndex(savedIndex)]
        eventPlayer.skipCount = savedData.savedSkipCount[eventPlayer.savedIndex(savedIndex)]
        eventPlayer.winnerTime = savedData.savedWinnerTime[eventPlayer.savedIndex(savedIndex)]
        wait(eventPlayer.getSlot() * 0.032)
        if savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)] != null:
            eventPlayer.playerOnceEventState = savedData.savedPlayerOnceEventState[eventPlayer.savedIndex(savedIndex)].slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
        if eventPlayer.joinTime == null or eventPlayer.joinTime == 0:
            eventPlayer.joinTime = savedData.savedJoinTime[eventPlayer.savedIndex(savedIndex)]
    else:
        if eventPlayer.joinTime == null or eventPlayer.joinTime == 0:
            eventPlayer.joinTime = evalOnce(getTotalTimeElapsed())
    eventPlayer.dmgReduc = false
    eventPlayer.invincible = false
    if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED:
        eventPlayer.heart_steel[HeartSteelData.STACKS] = DEFAULT_HEART_STEEL_DATA[HeartSteelData.STACKS]
        eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER] = EVT_31_STACK_MULTIPLIER
        eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK] = EVT_8_HP_PERCENT_PER_STACK + EVT_31_PERCENT_PER_STACK_BONUS
    eventPlayer.startForcingHero(heroList[eventPlayer.heroNumber])
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_REWARD:
        if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.HP:
            eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_MECH_21_HP_BONUS_HEART_STEEL * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
            setPlayerHP()
        elif eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.DMG_REDUCTION:
            eventPlayer.mod_dmg_perma += EVT_MECH_21_DMG_REDUCTION_PERMA
            updatePlayerStats()
        elif eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.SPEED:
            eventPlayer.mod_speed_perma += EVT_MECH_21_SPEED_PERMA
            updatePlayerStats()
        elif eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REWARD] == BraveActReward.HEALING:
            eventPlayer.mod_heal_perma += EVT_MECH_21_HEALING_PERMA
            updatePlayerStats()
    wait(6)
    if eventPlayer.key in titlePlayer:
        eventPlayer.playerTitleRelationIndex = titlePlayer.index(eventPlayer.key)
        setPlayerTitle()
        wait(0.032)
        
        
        smallMessage(eventPlayer, "  称号已加载")

        eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]

        if allTitle[eventPlayer.playerTitleAndColor][1] == null:
            eventPlayer.info_pvar = 0
            eventPlayer.rgb_vect = rgbList[eventPlayer.info_pvar]
            eventPlayer.rgb_activated = true
        elif len(allTitle[eventPlayer.playerTitleAndColor][1]) >= 1:
            eventPlayer.info_pvar = 0
            eventPlayer.rgb_vect = allTitle[eventPlayer.playerTitleAndColor][1][0]
            eventPlayer.rgb_activated = true
        else:
            # 单色向量（或你定义的其他形式）
            eventPlayer.rgb_vect = allTitle[eventPlayer.playerTitleAndColor][1]
            eventPlayer.rgb_activated = false

    eventPlayer.obstrucVis = []
    if eventPlayer.inSaved(savedIndex):
        smallMessage(eventPlayer, "  你的进度已成功加载")
        smallMessage(getAllPlayers().exclude(eventPlayer), "  {0} 载入 {1}{2}".format(eventPlayer, heroIcon(heroList[eventPlayer.heroNumber]), heroList[eventPlayer.heroNumber]))
