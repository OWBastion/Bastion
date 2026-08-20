#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine buildCandidatePool

# Whether this hero has any supported input that can activate a phase trigger.
macro Player.supportsPhaseTrigger():
    any([
        self.getHero() in phaseHero[0],
        self.getHero() in phaseHero[1],
        self.getHero() in phaseHero[2],
        self.getHero() in phaseHero[3],
        isHero(self, Hero.BRIGITTE),
        self.getHero() in phaseHero[4]
    ])

# Whether this hero is currently using its supported phase-trigger input.
macro Player.usesPhaseTrigger():
    any([
        (self.getHero() in phaseHero[0] and self.isUsingAbility1()),
        (self.getHero() in phaseHero[1] and self.isUsingAbility2()),
        (self.getHero() in phaseHero[2] and self.isFiringSecondaryFire()),
        (self.getHero() in phaseHero[3] and self.isHoldingButton(Button.JUMP)),
        (isHero(self, Hero.BRIGITTE) and self.isFiringSecondaryFire() and self.isHoldingButton(Button.PRIMARY_FIRE)),
        (self.getHero() in phaseHero[4] and self.zenSnapKick)
    ])

def buildCandidatePool():
    @Name "[VishkarEvent]: build player event candidate pool"

    if eventPlayer.eventType == EventType.BUFF:
        eventPlayer.eventTempId = buffEventId.slice(0, len(buffEventId))
        wait(getAverageServerLoad() / 100 * 0.032)
        if not eventPlayer.supportsPhaseTrigger():
            eventPlayer.eventTempId.remove(BuffEventId.PHASE_SURGE)
            eventPlayer.eventTempId.remove(BuffEventId.BODYGUARD)
        if eventPlayer.playerOnceEventState != null:
            if len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.NONE:
                eventPlayer.eventTempId.remove(BuffEventId.TEMPER_HEART)
        eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
            buffEventWeight[id] != 0 and buffEventWeight[id] > 0 and
            (eventPlayer.eventLastId == null or (EventType.BUFF * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = buffEventId.slice(0, len(buffEventId))
            if not eventPlayer.supportsPhaseTrigger():
                eventPlayer.eventTempId.remove(BuffEventId.PHASE_SURGE)
                eventPlayer.eventTempId.remove(BuffEventId.BODYGUARD)
            if eventPlayer.playerOnceEventState != null:
                if len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.NONE:
                    eventPlayer.eventTempId.remove(BuffEventId.TEMPER_HEART)
            eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
                buffEventWeight[id] != 0 and buffEventWeight[id] > 0
            )
    elif eventPlayer.eventType == EventType.DEBUFF:
        eventPlayer.eventTempId = debuffEventId.slice(0, len(debuffEventId))
        wait(getAverageServerLoad() / 100 * 0.032)
        if eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL:
            eventPlayer.eventTempId.remove(DebuffEventId.SELFLESS_GIVEAWAY)
        eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
            debuffEventWeight[id] != 0 and debuffEventWeight[id] > 0 and
            (eventPlayer.eventLastId == null or (EventType.DEBUFF * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.slice(0, len(debuffEventId))
            if eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL:
                eventPlayer.eventTempId.remove(DebuffEventId.SELFLESS_GIVEAWAY)
            eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
                debuffEventWeight[id] != 0 and debuffEventWeight[id] > 0
            )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = debuffEventId.filter(lambda id:
                debuffEventWeight[id] != 0 and debuffEventWeight[id] > 0
            )
    else:
        eventPlayer.eventTempId = mechEventId.slice(0, len(mechEventId))
        wait(getAverageServerLoad() / 100 * 0.032)
        if gamblerHeartsteelJackpot < EVT_MECH_24_POOL_MIN or eventPlayer.heart_steel[HeartSteelData.STACKS] < EVT_MECH_24_PLAYER_STACKS_MIN:
            eventPlayer.eventTempId.remove(MechEventId.GAMBLER_WINNER_TAKE_ALL)
        if eventPlayer.heart_steel[HeartSteelData.STACKS] <= 0:
            eventPlayer.eventTempId.remove(MechEventId.GAMBLER_SPEED_CHALLENGE)
            eventPlayer.eventTempId.remove(MechEventId.GAMBLER_HEART_OF_STEEL)
            eventPlayer.eventTempId.remove(MechEventId.GAMBLER_ALL_IN_ART_5)
        if not (eventPlayer.mod_dmg_perma < 0 or eventPlayer.mod_speed_perma < 0 or eventPlayer.mod_heal_perma < 0 or eventPlayer.heart_steel[HeartSteelData.STACKS] < 0):
            eventPlayer.eventTempId.remove(MechEventId.MIRROR_INVERSION)
        eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
            mechEventWeight[id] != 0 and mechEventWeight[id] > 0 and
            (eventPlayer.eventLastId == null or (EventType.MECH * EVT_DEDUP_TYPE_MULTIPLIER + id) not in eventPlayer.eventLastId)
        )
        if len(eventPlayer.eventTempId) <= 0:
            eventPlayer.eventTempId = mechEventId.slice(0, len(mechEventId))
            if gamblerHeartsteelJackpot < EVT_MECH_24_POOL_MIN or eventPlayer.heart_steel[HeartSteelData.STACKS] < EVT_MECH_24_PLAYER_STACKS_MIN:
                eventPlayer.eventTempId.remove(MechEventId.GAMBLER_WINNER_TAKE_ALL)
            if eventPlayer.heart_steel[HeartSteelData.STACKS] <= 0:
                eventPlayer.eventTempId.remove(MechEventId.GAMBLER_SPEED_CHALLENGE)
                eventPlayer.eventTempId.remove(MechEventId.GAMBLER_HEART_OF_STEEL)
                eventPlayer.eventTempId.remove(MechEventId.GAMBLER_ALL_IN_ART_5)
            if not (eventPlayer.mod_dmg_perma < 0 or eventPlayer.mod_speed_perma < 0 or eventPlayer.mod_heal_perma < 0 or eventPlayer.heart_steel[HeartSteelData.STACKS] < 0):
                eventPlayer.eventTempId.remove(MechEventId.MIRROR_INVERSION)
            eventPlayer.eventTempId = eventPlayer.eventTempId.filter(lambda id:
                mechEventWeight[id] != 0 and mechEventWeight[id] > 0
            )
