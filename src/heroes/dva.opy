#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Hero/D.Va"


rule "Enable remech":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.DVA
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 1.5)
    eventPlayer.setUltEnabled(false)
    wait(0.05)
    eventPlayer.dvaStart = eventPlayer.getPosition() * vect(1, 0, 1)
    wait(1)
    eventPlayer.setUltEnabled(true)


rule "Sync remech charge":
    @Event eachPlayer
    @Team 1
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.dvaStart != 0
    @Condition eventPlayer.getUltCharge() != 100
    
    eventPlayer.setUltCharge(3.333 * (distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.dvaStart)))
    wait(0.5 * getAverageServerLoad() / 100)
    if ruleCondition:
        loop()


rule "Complete remech goal":
    @Event eachPlayer
    @Team 1
    @Hero dva
    @Condition eventPlayer.isInAlternateForm() == true
    @Condition eventPlayer.dvaStart != 0
    
    waitUntil(distance(eventPlayer.getPosition() * vect(1, 0, 1), eventPlayer.dvaStart) >= 30 or eventPlayer.isDead(), Math.INFINITY)
    eventPlayer.dvaStart = 0
    if eventPlayer.isDead():
        return
    eventPlayer.setUltCharge(100)

rule "Display goal HUD":
    @Condition isHeroBeingPlayed(Hero.DVA, Team.1) == true
    
    wait(2, Wait.ABORT_WHEN_FALSE)
    hudHeader(localPlayer if localPlayer.getHero() == Hero.DVA and localPlayer.isInAlternateForm() and localPlayer.isAlive() and localPlayer.dvaStart != 0 else null, STR_DVA_DISTANCE_GOAL.format(max(0, 30 - distance(localPlayer.getPosition() * vect(1, 0, 1), localPlayer.dvaStart * vect(1, 0, 1)))), HudPosition.TOP, 5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    textIDs[1] = getLastCreatedText()
    waitUntil(not isHeroBeingPlayed(Hero.DVA, Team.1), Math.INFINITY)
    destroyHudText(textIDs[1])
