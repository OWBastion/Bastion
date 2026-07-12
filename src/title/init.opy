#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Title"

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
