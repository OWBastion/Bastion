#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

def clearEventEffect():
    @Name "[VishkarEvent]: clear Player event effect"
    
    if len(eventPlayer.eventEffect) > 0:
        destroyEffect(eventPlayer.eventEffect[0])
        if len(eventPlayer.eventEffect) > 1:
            destroyEffect(eventPlayer.eventEffect[1])
    else:
        destroyEffect(eventPlayer.eventEffect)
    eventPlayer.eventEffect = null
