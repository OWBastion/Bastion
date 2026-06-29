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
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] == PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_NEW,
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] == PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_DRAWN,
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] == PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
    ]):
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_NEW
    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HP_LEGACY] == true:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HP] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_DMG_REDUCTION_LEGACY] == true:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_DMG_REDUCTION] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_SPEED_LEGACY] == true:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_SPEED] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HEALING_LEGACY] == true:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HEALING] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_REGEN_LEGACY] == true:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_REGEN] = true
        goto lbl_0
    if eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_ULT_LEGACY] == true:
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_ACCEPTED
        eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_ULT] = true
        goto lbl_0
    lbl_0:
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_STATE_LEGACY] = PLAYER_ONCE_EVENT_STATE_BRAVE_ACT_NEW
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HP_LEGACY] = false
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_DMG_REDUCTION_LEGACY] = false
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_SPEED_LEGACY] = false
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_HEALING_LEGACY] = false
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_REGEN_LEGACY] = false
    eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_BRAVE_ACT_ULT_LEGACY] = false
