#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Title"

rule "Initialize title colors":
    rgbList = [vect(255, 0, 0), vect(255, 165, 0), vect(255, 255, 0), vect(0, 255, 0), vect(0, 0, 255), vect(75, 0, 130), vect(238, 130, 238)]

rule "Create in-world title":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition eventPlayer.titleTextID == null
    
    wait(eventPlayer.getSlot() * 0.08)
    eventPlayer.info_pvar = 0

    createInWorldText(
        getAllPlayers(),
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


# 称号调色板：无自带颜色的称号用开发者彩虹表，其余用自身色板
macro Player.titlePalette = (rgbList if titleColor[self.playerTitleAndColor] == null else titleColor[self.playerTitleAndColor])

rule "Cycle title color":
    @Event eachPlayer
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition (titleColor[eventPlayer.playerTitleAndColor] == null and eventPlayer.isDev == true) or (titleColor[eventPlayer.playerTitleAndColor] != null and len(titleColor[eventPlayer.playerTitleAndColor]) > 1)

    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.info_pvar = (eventPlayer.info_pvar + 1) % len(eventPlayer.titlePalette)
    chaseOverTime(eventPlayer.rgb_vect, eventPlayer.titlePalette[eventPlayer.info_pvar], 2.5, ChaseTimeReeval.NONE)
    waitUntil(
        eventPlayer.rgb_vect == eventPlayer.titlePalette[eventPlayer.info_pvar]
        or not eventPlayer.rgb_activated,
        Math.INFINITY
    )
    if ruleCondition:
        loop()
    wait()
    stopChasingVariable(eventPlayer.rgb_vect)
    eventPlayer.info_pvar = 0
