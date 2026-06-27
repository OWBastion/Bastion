#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

playervar zenSnapKick

rule "[Zenyatta] Snap Kick (Self Ground)  - created by 他又 from 77QS1":
    @Event eachPlayer
    @Team 1
    @Hero zenyatta
    @Condition eventPlayer.isMeleeing() == true
    @Condition eventPlayer.getVerticalFacingAngle() >= 45
    
    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        eventPlayer.zenSnapKick = true
        wait()
        eventPlayer.applyImpulse(negToPos(eventPlayer.getFacingDirection()), 15.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.applyImpulse(Vector.UP, 15.5 * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "[Zenyatta] Snap Kick (Self Wall)  - created by 他又 from 77QS1":
    @Event eachPlayer
    @Hero zenyatta
    @Condition eventPlayer.isMeleeing() == Button.MELEE
    @Condition eventPlayer.getVerticalFacingAngle() < 45
    
    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        if raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 5, getAllPlayers(), eventPlayer, true).getPlayerHit() == null:
            eventPlayer.zenSnapKick = true
            wait()
            eventPlayer.applyImpulse(negToPos(eventPlayer.getFacingDirection()), 15.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            eventPlayer.applyImpulse(Vector.UP, 15.5 * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "zenyatta's melee knocks him back":
    @Event eachPlayer
    @Team 1
    @Hero zenyatta
    @Condition eventPlayer.isMeleeing() == true
    @Condition eventPlayer.getVerticalFacingAngle() >= 45
    @Disabled
    
    if distance(raycast(eventPlayer.getEyePosition(), eventPlayer.getEyePosition() + eventPlayer.getFacingDirection() * 2.51, getAllPlayers(), eventPlayer, true).getHitPosition(), eventPlayer.getEyePosition()) <= 2.5:
        eventPlayer.zenSnapKick = true
        wait()
        eventPlayer.applyImpulse(negToPos(eventPlayer.getFacingDirection()), 15.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        eventPlayer.applyImpulse(Vector.UP, 15.5 * 0.3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)

rule "zenyatta's melee knocks him back":
    @Event eachPlayer
    @Team 1
    @Hero zenyatta
    @Condition eventPlayer.zenSnapKick == true
    @Condition eventPlayer.phase_trigger == true

    wait()
    eventPlayer.zenSnapKick = false
    eventPlayer.phase_trigger = false

rule "zenyatta's jump can levitate if held":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.ZENYATTA
    @Condition eventPlayer.isJumping() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    #don't activate the rule if the player is just jumping normally and not holding jump
    wait(0.12, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setGravity(0)
    eventPlayer.startAcceleration(Vector.UP if eventPlayer.getVelocity().y < 2 else Vector.DOWN, 5 if eventPlayer.getVelocity().y < 2.05 else 17.5 if eventPlayer.getVelocity().y > 1.95 else 0, 100, Relativity.TO_WORLD)
    waitUntil(not eventPlayer.isHoldingButton(Button.JUMP), 1.5)
    eventPlayer.setGravity(100)
    eventPlayer.stopAcceleration()
    #ability is only available again once you touch the ground
    waitUntil(eventPlayer.isOnGround(), 10)

rule "create zen instructions":
    @Condition isHeroBeingPlayed(Hero.ZENYATTA, Team.1) == true
    @Disabled
    
    hudHeader(localPlayer if localPlayer.getHero() == Hero.ZENYATTA and localPlayer.isInSpawnRoom() else null, STR_ZEN_KICK_HINT.format(abilityIconString(Hero.ZENYATTA, Button.MELEE), iconString(Icon.ARROW_UP)), HudPosition.TOP, 5, Color.WHITE, HudReeval.VISIBILITY)
    textIDs[2] = getLastCreatedText()
    waitUntil(not isHeroBeingPlayed(Hero.ZENYATTA, Team.1), Math.INFINITY)
    destroyHudText(textIDs[2])
