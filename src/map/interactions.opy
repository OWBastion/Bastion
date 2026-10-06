#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.

#!optimizeStrict
#!define INTERACTION_GATE_DT 0.032

rule "3rd person":
    @Event eachPlayer
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition distance(eventPlayer * vect(1, 0, 1), thirdPersonPosition * vect(1, 0, 1)) <= 1.2

    wait(INTERACTION_GATE_DT)
    setThirdPerson()


rule "springboard":
    @Event eachPlayer
    @Condition springBoardPosition != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.getPosition().y >= springBoardPosition.y
    @Condition distance(eventPlayer * vect(1, 0, 1), springBoardPosition * vect(1, 0, 1)) <= 1.2

    wait(INTERACTION_GATE_DT, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.applyImpulse(Vector.UP, 14, Relativity.TO_PLAYER)
    wait(0.032)
    eventPlayer.applyImpulse(worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION), 3.5, Relativity.TO_WORLD)
    wait(5)


rule "portalPosition":
    @Event eachPlayer
    @Condition portalPosition != null
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.getPosition().y >= portalPosition[0].y
    @Condition distance(eventPlayer * vect(1, 0, 1), portalPosition[0] * vect(1, 0, 1)) <= 1.2

    wait(INTERACTION_GATE_DT, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.teleport(nearestWalkablePosition(portalPosition.last()))
    wait(5)
