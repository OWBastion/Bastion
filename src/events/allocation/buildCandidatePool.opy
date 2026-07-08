#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine buildCandidatePool

def buildCandidatePool():
    @Name "[VishkarEvent]: build player event candidate pool"

    if eventPlayer.eventType == EventType.BUFF:
        eventPlayer.eventTempId = buffEventId.slice(0, len(buffEventId))
        if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.NONE:
            eventPlayer.eventTempId.remove(BuffEventId.TEMPER_HEART)
        if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.IM_DEVELOPING and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.IM_DEVELOPING] != TemperHeartState.NONE:
            eventPlayer.eventTempId.remove(BuffEventId.IM_DEVELOPING)
        eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
            buffEvent[id] != 0 and buffEvent[id].last() > 0 and
            (eventPlayer.eventLastId == null or (EventType.BUFF * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = buffEventId.slice(0, len(buffEventId))
            if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.NONE:
                eventPlayer.eventTempId.remove(BuffEventId.TEMPER_HEART)
            if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.IM_DEVELOPING and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.IM_DEVELOPING] != TemperHeartState.NONE:
                eventPlayer.eventTempId.remove(BuffEventId.IM_DEVELOPING)
            eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
                buffEvent[id] != 0 and buffEvent[id].last() > 0
            )
    elif eventPlayer.eventType == EventType.DEBUFF:
        eventPlayer.eventTempId = debuffEventId.slice(0, len(debuffEventId))
        if eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL:
            eventPlayer.eventTempId.remove(DebuffEventId.SELFLESS_GIVEAWAY)
        eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
            debuffEvent[id] != 0 and debuffEvent[id].last() > 0 and
            (eventPlayer.eventLastId == null or (EventType.DEBUFF * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.slice(0, len(debuffEventId))
            if eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL:
                eventPlayer.eventTempId.remove(DebuffEventId.SELFLESS_GIVEAWAY)
            eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
                debuffEvent[id] != 0 and debuffEvent[id].last() > 0
            )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id:
                debuffEvent[id] != 0 and debuffEvent[id].last() > 0
            )
    else:
        eventPlayer.eventTempId = mechEventId.slice(0, len(mechEventId))
        if gamblerHeartsteelJackpot < EVT_MECH_24_POOL_MIN or eventPlayer.heart_steel[HeartSteelData.STACKS] < EVT_MECH_24_PLAYER_STACKS_MIN:
            eventPlayer.eventTempId.remove(MechEventId.GAMBLER_WINNER_TAKE_ALL)
        eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
            mechEvent[id] != 0 and mechEvent[id].last() > 0 and
            (eventPlayer.eventLastId == null or (EventType.MECH * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = mechEventId.slice(0, len(mechEventId))
            if gamblerHeartsteelJackpot < EVT_MECH_24_POOL_MIN or eventPlayer.heart_steel[HeartSteelData.STACKS] < EVT_MECH_24_PLAYER_STACKS_MIN:
                eventPlayer.eventTempId.remove(MechEventId.GAMBLER_WINNER_TAKE_ALL)
            eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
                mechEvent[id] != 0 and mechEvent[id].last() > 0
            )
