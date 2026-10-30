#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "[VishkarEvent]: get player event":
    @Event eachPlayer
    @Team 1
    @Condition getNumberOfPlayers(Team.2) == len(bastionPosition)
    @Condition all([vishkarEventActivated, eventPlayer.hasSpawned(), eventPlayer.eventId == -1]) == true
    @Condition eventPlayer.eventCompatibleBasePool != null
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer)

    if eventPlayer.hudTextId:
        goto lbl_0
    eventPlayer.hudText = ""
    hudText(eventPlayer, null, "{0}".format(HUD_PAD_BOTTOM), eventPlayer.hudText, HudPosition.TOP, 20, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    eventPlayer.hudTextId = getLastCreatedText()
        
    
    lbl_0:
    wait(10 if evalOnce(debugMode) else random.randint(30, 35) if not eventPlayer.isWinner else 40, Wait.ABORT_WHEN_FALSE)
    waitLoadBrief()
    setPlayerEvent()
    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    waitLoadBrief()
    if eventPlayer.eventId != -1 and eventPlayer.eventEndTime <= getTotalTimeElapsed():
        clearPlayerEvent()
    waitLoadBrief()
    if ruleCondition:
        loop()
