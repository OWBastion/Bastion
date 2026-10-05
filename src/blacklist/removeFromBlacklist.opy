#!mainFile "../main.opy"

rule "Remove Player from Blacklist":
    @Event playerJoined
    @Team 1
    @Condition "{0}".format(eventPlayer) in blackList == true
    
    eventPlayer.removeFromGame()