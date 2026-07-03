#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine buildCandidatePool

def buildCandidatePool():
    @Name "[VishkarEvent]: build player event candidate pool"

    if eventPlayer.eventType == EventType.BUFF:
        eventPlayer.eventTempId = buffEventId.filter(lambda id:
            buffEvent[id] != 0 and buffEvent[id].last() > 0 and
            id != (BuffEventId.TEMPER_HEART if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.NONE else -1) and
            (eventPlayer.eventLastId == null or (EventType.BUFF * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = buffEventId.filter(lambda id:
                buffEvent[id] != 0 and buffEvent[id].last() > 0 and
                id != (BuffEventId.TEMPER_HEART if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.NONE else -1)
            )
    elif eventPlayer.eventType == EventType.DEBUFF:
        eventPlayer.eventTempId = debuffEventId.filter(lambda id:
            debuffEvent[id] != 0 and debuffEvent[id].last() > 0 and
            (eventPlayer.eventForceRoll != EVT_MECH_8_FORCE_ROLL or id != DebuffEventId.SELFLESS_GIVEAWAY) and
            (eventPlayer.eventLastId == null or (EventType.DEBUFF * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id:
                debuffEvent[id] != 0 and debuffEvent[id].last() > 0 and
                (eventPlayer.eventForceRoll != EVT_MECH_8_FORCE_ROLL or id != DebuffEventId.SELFLESS_GIVEAWAY)
            )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id:
                debuffEvent[id] != 0 and debuffEvent[id].last() > 0
            )
    else:
        eventPlayer.eventTempId = mechEventId.filter(lambda id:
            mechEvent[id] != 0 and mechEvent[id].last() > 0 and
            id != (MechEventId.BRAVE_ACT if eventPlayer.heroNumber + 1 >= EVT_MECH_21_MAX_HERO_ORDER_EXCLUSIVE or (eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_SEEN and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SEEN] == true) else -1) and
            (eventPlayer.eventLastId == null or (EventType.MECH * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = mechEventId.filter(lambda id:
                mechEvent[id] != 0 and mechEvent[id].last() > 0 and
                id != (MechEventId.BRAVE_ACT if eventPlayer.heroNumber + 1 >= EVT_MECH_21_MAX_HERO_ORDER_EXCLUSIVE or (eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.BRAVE_ACT_SEEN and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.BRAVE_ACT_SEEN] == true) else -1)
            )
