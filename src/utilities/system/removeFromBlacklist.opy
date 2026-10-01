#!mainFile "../../main.opy"

rule "Remove Player from Blacklist":
    @Event playerJoined
    @Team 2
    @Condition "{0}".format(eventPlayer) in blackList == true
    
    eventPlayer.removeFromGame()