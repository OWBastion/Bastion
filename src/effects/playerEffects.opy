#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Effects"

rule "Toggle dev rainbow":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDev
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Disabled
    
    eventPlayer.rainbowOff = not eventPlayer.rainbowOff
    eventPlayer.stopForcingOutlineFor(getAllPlayers())
    smallMessage(eventPlayer, "DEV 特效{0}".format("关闭" if eventPlayer.rainbowOff else "开启"))


rule "Refresh winner outlines":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isWinner
    @Condition eventPlayer.isAlive()
    
    waitLoadLong()
    eventPlayer.startForcingOutlineFor(getPlayers(Team.1), true, Color.GREEN, OutlineVisibility.ALWAYS)
    wait(30, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "Outline winners for joiners":
    @Event playerJoined
    @Team 1
    @Condition getPlayers(Team.1).any(lambda player: player.isWinner) == true
    
    waitLoadLong()
    getPlayers(Team.1).filter(lambda player: player.isWinner).startForcingOutlineFor(eventPlayer, true, Color.GREEN, OutlineVisibility.ALWAYS)


rule "Clear non-winner outlines":
    @Event eachPlayer
    @Team 1
    @Condition not eventPlayer.isWinner
    
    waitLoadLong()
    eventPlayer.stopForcingOutlineFor(getPlayers(Team.1))
