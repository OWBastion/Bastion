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
    eventPlayer.sizeHealth = 1
    eventPlayer.earnedAchievements = []
    lbl_0:
    wait(getAverageServerLoad() / 200 * random.uniform(1, 3))
    if eventPlayer.inSaved(savedIndex):
        eventPlayer.heroNumber = savedHero[eventPlayer.savedIndex(savedIndex)]
        wait(eventPlayer.getSlot() * 0.032 + random.uniform(1, 3) * 0.05)
        eventPlayer.runDeathCount = savedDeaths[eventPlayer.savedIndex(savedIndex)]
        eventPlayer.isWinner = savedIsWinner[eventPlayer.savedIndex(savedIndex)]
        eventPlayer.skipCount = savedSkipCount[eventPlayer.savedIndex(savedIndex)]
        eventPlayer.winnerTime = savedWinnerTime[eventPlayer.savedIndex(savedIndex)]
        wait(eventPlayer.getSlot() * 0.032)
        eventPlayer.A36TGrenadeAlive = savedA36TGrenadeAlive[eventPlayer.savedIndex(savedIndex)]
        if eventPlayer.joinTime == null or eventPlayer.joinTime == 0:
            eventPlayer.joinTime = savedJoinTime[eventPlayer.savedIndex(savedIndex)]
    else:
        if eventPlayer.joinTime == null or eventPlayer.joinTime == 0:
            eventPlayer.joinTime = evalOnce(getTotalTimeElapsed())
    eventPlayer.dmgReduc = false
    eventPlayer.invincible = false
    eventPlayer.startForcingHero(heroList[eventPlayer.heroNumber])
    eventPlayer.stopForcingCurrentHero()
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
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
