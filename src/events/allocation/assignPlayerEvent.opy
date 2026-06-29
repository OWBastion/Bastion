#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "[VishkarEvent]: get player event":
    @Event eachPlayer
    @Team 1
    @Condition getNumberOfPlayers(Team.2) == len(bastionPosition)
    @Condition all([vishkarEventActivated, eventPlayer.hasSpawned(), eventPlayer.eventId == -1]) == true
    @Condition not (eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_STATE and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] == PlayerOnceEventStateBraveAct.ACCEPTED)
    @Condition (any([eventPlayer.playerTitles[0][1] == vect(149, 239, 66) and eventPlayer.heroNumber >= 1, eventPlayer.heroNumber > 2])) == true

    if eventPlayer.hudTextId != null:
        goto lbl_0
    eventPlayer.hudText = ""
    hudText(eventPlayer, null, "{0}".format(HUD_PAD_BOTTOM), eventPlayer.hudText, HudPosition.TOP, 9, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.hudTextId = getLastCreatedText()
        
    
    lbl_0:
    wait(10 if evalOnce(debugMode) else random.randint(30, 35) if not eventPlayer.isWinner else 40, Wait.ABORT_WHEN_FALSE)
    wait(getAverageServerLoad() / 100 * 0.032)
    setPlayerEvent()
    waitUntil(eventPlayer.eventDuration == 0, eventPlayer.eventDuration)
    wait(getAverageServerLoad() / 100 * 0.032)
    clearPlayerEvent()
    wait(getAverageServerLoad() / 100 * 0.032)
    if ruleCondition:
        loop()
