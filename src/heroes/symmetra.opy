#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Hero/Symmetra"


rule "Break teleporter on interact":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    wait(0.5)
    if eventPlayer.isUsingAbility2() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
        eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "Break teleporter timeout":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    wait(1.25, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isUsingAbility2() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
        eventPlayer.forceButtonPress(Button.ABILITY_2)

rule "Disable ability 1":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.getHero() == Hero.SYMMETRA
    @Condition eventPlayer.isWinner != true
    @Disabled

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(false)
    waitUntil(eventPlayer.isWinner == true or eventPlayer.getHero() != Hero.SYMMETRA, Math.INFINITY)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)
