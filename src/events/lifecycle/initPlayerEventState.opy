#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Player"

subroutine initPlayerEventState

def initPlayerEventState():
    @Name "[VishkarEvent]: init player event state"

    eventPlayer.eventId = -1
    # -1 哨兵：Workshop 中 0 与 null 比较相等，EventType.BUFF=0 必须用 -1 表示无契约
    eventPlayer.eventForceType = -1
    eventPlayer.eventForceCount = 0
    eventPlayer.eventForceSourceId = -1
    eventPlayer.eventLastId = []
    eventPlayer.eventNextIndex = -1
    eventPlayer.eventAssigning = false
    eventPlayer.eventCompatibleBasePool = null
    eventPlayer.playerOnceEventState = DEFAULT_PLAYER_ONCE_EVENT_STATE.slice(0, PLAYER_ONCE_EVENT_SLOT_COUNT)
    eventPlayer.heart_steel = DEFAULT_HEART_STEEL_DATA.slice(0, HeartSteelData.COUNT)
    eventPlayer.sizeHealth = 1
