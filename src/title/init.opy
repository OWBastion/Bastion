#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Title"

rule "Load player title data":
    @Event playerJoined
    @Team 1

    wait(6)
    waitUntil(len(titlePlayer) > 0, Math.INFINITY)
    if eventPlayer.key in titlePlayer:
        eventPlayer.playerTitleRelationIndex = titlePlayer.index(eventPlayer.key)
        setPlayerTitle()
        wait(0.032)
        smallMessage(eventPlayer, "  称号已加载")

        eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]

        if titleColor[eventPlayer.playerTitleAndColor] == null:
            eventPlayer.info_pvar = 0
            eventPlayer.rgb_vect = rgbList[eventPlayer.info_pvar]
            eventPlayer.rgb_activated = true
        elif len(titleColor[eventPlayer.playerTitleAndColor]) >= 1:
            eventPlayer.info_pvar = 0
            eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor][0]
            eventPlayer.rgb_activated = true
        else:
            eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor]
            eventPlayer.rgb_activated = false

rule "Initialize map title colors":
    @Event global
    @Condition __currentMapPioneerText___ != null

    waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
    if __currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860:
        titleColor[TITLE.PIONEER] = vect(250, 120, 115)
    elif __currentMap___ == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177:
        titleColor[TITLE.PIONEER] = vect(109, 171, 235)
    elif __currentMap___ == Map.WATCHPOINT_GIBRALTAR:
        if __currentMapPioneerText___ == "守望先锋":
            titleColor[TITLE.PIONEER] = vect(240, 101, 20)
        else:
            titleColor[TITLE.PIONEER] = vect(227, 3, 3)

rule "Create in-world title":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition eventPlayer.titleTextID == null
    
    wait(eventPlayer.getSlot() * 0.08)
    eventPlayer.info_pvar = 0

    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(eventPlayer, player)], 
        "{0} {1}".format(
                abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if eventPlayer.isDev else "", 
                titleText[eventPlayer.playerTitleAndColor]
            ), 
            eventPlayer, 
            1 if eventPlayer.isDev else 0.8, 
            Clip.NONE, 
            WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, 
            rgb(eventPlayer.rgb_vect.x, eventPlayer.rgb_vect.y, eventPlayer.rgb_vect.z)
        )
    eventPlayer.titleTextID = getLastCreatedText()


rule "Cycle dev rainbow":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition titleColor[eventPlayer.playerTitleAndColor] == null
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.info_pvar = (eventPlayer.info_pvar + 1) % len(rgbList)
    chaseOverTime(eventPlayer.rgb_vect, rgbList[eventPlayer.info_pvar], 2.5, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.rgb_vect == rgbList[eventPlayer.info_pvar], Math.INFINITY)
    if ruleCondition:
        loop()
    stopChasingVariable(eventPlayer.rgb_vect)
    eventPlayer.info_pvar = 0


rule "Cycle palette":
    @Event eachPlayer
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition titleColor[eventPlayer.playerTitleAndColor] != null
    @Condition len(titleColor[eventPlayer.playerTitleAndColor]) > 1
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.info_pvar = (eventPlayer.info_pvar + 1) % len(titleColor[eventPlayer.playerTitleAndColor])
    chaseOverTime(
        eventPlayer.rgb_vect,
        titleColor[eventPlayer.playerTitleAndColor][eventPlayer.info_pvar],
        2.5,
        ChaseTimeReeval.NONE
    )
    waitUntil(
        eventPlayer.rgb_vect == titleColor[eventPlayer.playerTitleAndColor][eventPlayer.info_pvar]
        or not eventPlayer.rgb_activated,
        Math.INFINITY
    )
    if ruleCondition:
        loop()
    wait()
    stopChasingVariable(eventPlayer.rgb_vect)
    eventPlayer.info_pvar = 0
    eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor][0]
