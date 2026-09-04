#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Hero/Lifeweaver"

rule "Manage Life Grip availability":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.LIFEWEAVER
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.playerTitleRelationIndex != null
    @Condition eventPlayer.isWinner == false

    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.setAbility2Enabled(true)
    waitUntil(
        eventPlayer.hasSpawned() == false
        or eventPlayer.getHero() != Hero.LIFEWEAVER
        or eventPlayer.playerTitleRelationIndex == null
        or eventPlayer.isWinner == true,
        Math.INFINITY
    )
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setAbility2Enabled(false)


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
