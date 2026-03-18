#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "Lifeweaver disable Life Grip if no winners":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.LIFEWEAVER
    @Condition eventPlayer.isWinner != true
    
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.setAbility2Enabled(false)
    waitUntil(eventPlayer.isWinner == true or eventPlayer.getHero() != Hero.LIFEWEAVER, MAX_TIME)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.setAbility2Enabled(true)


rule "Lifeweaver auto-breaks Petal Platform after time limit":
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
