#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine resetPlayerCD

def resetPlayerCD():
    @Name "[VishkarEvent]: reset Player Ability CD"
    
    eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, 0)
    eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_1, 0)
    eventPlayer.setAbilityCooldown(Button.ABILITY_2, 0)
    eventPlayer.setAbilityCooldown(Button.JUMP, 0)
    eventPlayer.setAbilityCooldown(Button.RELOAD, 0)
    wait(getAverageServerLoad() / 100 * 0.032)