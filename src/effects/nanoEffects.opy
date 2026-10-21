#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "initialize player nano effects":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.hasNano == true
    
    if eventPlayer.nanoEffect != null:
        goto lbl_0
    createEffect(getAllPlayers() if eventPlayer.hasNano else null, Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.nanoEffect = getLastCreatedEntity()
    lbl_0:
    eventPlayer.setStatusEffect(null, Status.BURNING, 60)
    waitUntil(berserkerTime == 0 or not eventPlayer.hasNano, 60)
    eventPlayer.hasNano = false
    eventPlayer.clearStatusEffect(Status.BURNING)


rule "clear nano effect when bastion leaves":
    @Event playerLeft
    @Team 2

    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.nanoEffect = null
    eventPlayer.hasNano = false
