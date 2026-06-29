#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine normalizePlayerOnceEventState

def normalizePlayerOnceEventState():
    @Name "[VishkarEvent]: normalize player once event state"

    eventPlayer.playerOnceEventState = eventPlayer.playerOnceEventState.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
    while len(eventPlayer.playerOnceEventState) < PLAYER_ONCE_EVENT_SLOT_COUNT:
        eventPlayer.playerOnceEventState.append(DEFAULT_PLAYER_ONCE_EVENT_STATE[len(eventPlayer.playerOnceEventState)])
    if not any([
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] == PlayerOnceEventStateBraveAct.NEW,
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] == PlayerOnceEventStateBraveAct.DRAWN,
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] == PlayerOnceEventStateBraveAct.ACCEPTED
    ]):
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.NEW
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_HP_LEGACY] == true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.ACCEPTED
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_HP] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_DMG_REDUCTION_LEGACY] == true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.ACCEPTED
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_DMG_REDUCTION] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SPEED_LEGACY] == true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.ACCEPTED
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SPEED] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_HEALING_LEGACY] == true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.ACCEPTED
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_HEALING] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REGEN_LEGACY] == true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.ACCEPTED
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REGEN] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_ULT_LEGACY] == true:
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE] = PlayerOnceEventStateBraveAct.ACCEPTED
        eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_ULT] = true
        goto lbl_0
    lbl_0:
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_STATE_LEGACY] = PlayerOnceEventStateBraveAct.NEW
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_HP_LEGACY] = false
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_DMG_REDUCTION_LEGACY] = false
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SPEED_LEGACY] = false
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_HEALING_LEGACY] = false
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_REGEN_LEGACY] = false
    eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_ULT_LEGACY] = false
