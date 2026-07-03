#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerHP

def setPlayerHP():
    @Name "[VishkarEvent]: set player HP"

    eventPlayer.temp = eventPlayer.getNormalizedHealth()
    eventPlayer.setMaxHealth(100 * eventPlayer.sizeHealth + eventPlayer.heart_steel * (EVT_8_HP_PERCENT_PER_STACK + (EVT_31_PERCENT_PER_STACK_BONUS if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 0)))
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.setHealth(eventPlayer.getMaxHealth().scaledBy(eventPlayer.temp))
