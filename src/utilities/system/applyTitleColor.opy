#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine applyTitleColor

def applyTitleColor():
    @Name "apply title color"

    stopChasingVariable(eventPlayer.rgb_vect)
    eventPlayer.info_pvar = 0
    if titleColor[eventPlayer.playerTitleAndColor] == null:
        eventPlayer.rgb_vect = rgbList[0]
        eventPlayer.rgb_activated = true
    elif len(titleColor[eventPlayer.playerTitleAndColor]) >= 1:
        eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor][0]
        eventPlayer.rgb_activated = true
    else:
        eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor]
        eventPlayer.rgb_activated = false
