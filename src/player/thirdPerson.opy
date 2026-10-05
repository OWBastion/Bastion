#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setThirdPerson

def setThirdPerson():
    @Name "3rd camera function"
    
    eventPlayer.third = not eventPlayer.third
    if eventPlayer.third:
        #by overclocking
        eventPlayer.startCamera(raycast(eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5)), raycast(eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5)), eventPlayer + (Vector.UP * (distance(eventPlayer.getEyePosition(), eventPlayer) + 0.5)) + eventPlayer.getFacingDirection() * -3, null, eventPlayer, true).getHitPosition(), null, eventPlayer, true).getHitPosition(), eventPlayer + eventPlayer.getFacingDirection() * 100, 100)
    else:
        eventPlayer.stopCamera()
