#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "symmetra auto-breaks tp after going through":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    wait(0.5)
    if eventPlayer.isUsingAbility2() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
        eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "symmetra auto-breaks tp after time limit":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0
    
    wait(1.25, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.isUsingAbility2() and eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0:
        eventPlayer.forceButtonPress(Button.ABILITY_2)

rule "symmetra ability 1 disabled":
    @Event eachPlayer
    @Team 1
    @Hero symmetra
    @Condition (eventPlayer.isUsingAbility1() and eventPlayer.isWinner != true) == true

    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(false)
    waitUntil(eventPlayer.getHero() != Hero.SYMMETRA, MAX_TIME)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.setAbility1Enabled(true)