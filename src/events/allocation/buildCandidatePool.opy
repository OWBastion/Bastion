#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine buildCandidatePool

def buildCandidatePool():
    @Name "[VishkarEvent]: build player event candidate pool"

    if eventPlayer.eventType == 0:
        eventPlayer.eventTempId = buffEventId.filter(lambda id:
            buffEvent[id] != 0 and buffEvent[id].last() > 0 and
            id != (BuffEventId.TEMPER_HEART if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PLAYER_ONCE_EVENT_SLOT_TEMPER_HEART and eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_TEMPER_HEART] == true else -1) and
            (eventPlayer.eventLastId == null or (0 * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = buffEventId.filter(lambda id:
                buffEvent[id] != 0 and buffEvent[id].last() > 0 and
                id != (BuffEventId.TEMPER_HEART if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PLAYER_ONCE_EVENT_SLOT_TEMPER_HEART and eventPlayer.playerOnceEventState[PLAYER_ONCE_EVENT_SLOT_TEMPER_HEART] == true else -1)
            )
    elif eventPlayer.eventType == 1:
        eventPlayer.eventTempId = debuffEventId.filter(lambda id:
            debuffEvent[id] != 0 and debuffEvent[id].last() > 0 and
            (eventPlayer.eventFilterContractType != PLAYER_EVENT_FILTER_CONTRACT_NO_SELFLESS_GIVEAWAY or eventPlayer.eventFilterContractCount <= 0 or id != DebuffEventId.SELFLESS_GIVEAWAY) and
            (eventPlayer.eventLastId == null or (1 * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id:
                debuffEvent[id] != 0 and debuffEvent[id].last() > 0 and
                (eventPlayer.eventFilterContractType != PLAYER_EVENT_FILTER_CONTRACT_NO_SELFLESS_GIVEAWAY or eventPlayer.eventFilterContractCount <= 0 or id != DebuffEventId.SELFLESS_GIVEAWAY)
            )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id:
                debuffEvent[id] != 0 and debuffEvent[id].last() > 0
            )
    else:
        eventPlayer.eventTempId = mechEventId.filter(lambda id:
            mechEvent[id] != 0 and mechEvent[id].last() > 0 and
            (eventPlayer.eventLastId == null or (2 * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = mechEventId.filter(lambda id:
                mechEvent[id] != 0 and mechEvent[id].last() > 0
            )
