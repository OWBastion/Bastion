#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Hero/Lifeweaver"

rule "Enable Life Grip for eligible players":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.LIFEWEAVER
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.playerTitleRelationIndex != null
    @Condition eventPlayer.isWinner == false

    eventPlayer.setAbility2Enabled(true)


rule "Lock Life Grip while ineligible":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.LIFEWEAVER
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.playerTitleRelationIndex == null or eventPlayer.isWinner == true

    eventPlayer.setAbility2Enabled(false)
    waitUntil(
        eventPlayer.getHero() != Hero.LIFEWEAVER
        or (eventPlayer.playerTitleRelationIndex != null and eventPlayer.isWinner == false),
        Math.INFINITY
    )
    eventPlayer.setAbility2Enabled(true)


rule "Break Petal Platform":
    @Event eachPlayer
    @Team 1
    @Hero lifeweaver
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0
    
    wait(0.2, Wait.IGNORE_CONDITION)

    waitUntil(
        not (eventPlayer.isUsingAbility1() or eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0),
        3
    )
    if eventPlayer.isUsingAbility1():
        eventPlayer.forceButtonPress(Button.ABILITY_1)
