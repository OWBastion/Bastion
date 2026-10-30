#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "reinhardt cannot charge bastions":
    @Event eachPlayer
    @Team 1
    @Hero reinhardt
    @Condition eventPlayer.isUsingAbility1()
    
    waitUntil(getPlayersInRadius(eventPlayer, 2, Team.2)[0] or not eventPlayer.isUsingAbility1(), 5)
    if not eventPlayer.isUsingAbility1() or eventPlayer.isFiringSecondaryFire():
        return
    wait()
    eventPlayer.cancelPrimaryAction()