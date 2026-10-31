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
    applyTitleColor()
