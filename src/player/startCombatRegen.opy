#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine startCombatRegen

def startCombatRegen():
    @Name "[VishkarEvent]: stop Combat Regen"

    if eventPlayer.combatRegen:
        goto lbl_0
    eventPlayer.combatRegen = true
    lbl_0:
