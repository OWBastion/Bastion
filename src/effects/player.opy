#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "devs can toggle rainbow effect":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Disabled
    
    eventPlayer.rainbowOff = false if eventPlayer.rainbowOff else true
    eventPlayer.stopForcingOutlineFor(getAllPlayers())
    smallMessage(eventPlayer, "DEV 特效{0}".format("关闭" if eventPlayer.rainbowOff else "开启"))


rule "outline winners in green periodically":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isWinner != false
    @Condition eventPlayer.isAlive() == true
    
    wait(getAverageServerLoad() / 100)
    eventPlayer.startForcingOutlineFor(getPlayers(Team.1), true, Color.GREEN, OutlineVisibility.ALWAYS)
    wait(30, Wait.RESTART_WHEN_TRUE)
    if ruleCondition:
        loop()


rule "outline winners for new players as soon as they join":
    @Event playerJoined
    @Team 1
    @Condition getPlayers(Team.1).any(lambda player: player.isWinner) == true
    
    wait(getAverageServerLoad() / 100)
    getPlayers(Team.1).filter(lambda player: player.isWinner).startForcingOutlineFor(eventPlayer, true, Color.GREEN, OutlineVisibility.ALWAYS)


rule "stop outline for non-winners":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isWinner == false
    
    wait(getAverageServerLoad() / 100)
    eventPlayer.stopForcingOutlineFor(getPlayers(Team.1))
