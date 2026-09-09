#!mainFile "../main.opy"

#!optimizeStrict

rule "Initialize CN player title state":
    @Event playerJoined
    @Team 1

    eventPlayer.playerTitleRelationIndex = null
    eventPlayer.tempUnlockId = null
    eventPlayer.earnedAchievements = []
    wait(6)
    if eventPlayer.key not in titlePlayer:
        return
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
