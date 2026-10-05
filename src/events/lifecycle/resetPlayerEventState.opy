#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保持发射规则名 "[Player] [VishkarEvent]: reset player event state" 不变
#!rulePrefix "Player"

subroutine resetPlayerEventState

def resetPlayerEventState():
    @Name "[VishkarEvent]: reset player event state"

    eventPlayer.eventCompatibleBasePool = null
    clearPlayerEvent()
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.REGROUP_CALL])
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.DEV_TOOL])
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.invincibleEffect = DEFAULT_INVINCIBLE_EFFECTS.slice(0, InvincibleEffectSlot.COUNT)
    eventPlayer.nanoEffect = null
    eventPlayer.hasNano = false
    eventPlayer.eventLastId = []
    eventPlayer.eventCount = [0, 0, 0]
    eventPlayer.eventLucky = 0
    eventPlayer.eventDurationHud = 0
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    eventPlayer.eventCandidateIndex = null
    eventPlayer.eventTempIndex = []
    wait(getAverageServerLoad() / 100 * 0.032)
