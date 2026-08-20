#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Hero/Lifeweaver"

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
