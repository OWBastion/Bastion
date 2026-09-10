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

    eventPlayer.eventTempIndex = eventCatalogId
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex:
        eventCatalogWeight[candidateIndex] > 0 and
        (eventPlayer.thiefBuffStolen == true or eventPlayer.eventForceRoll == null or
            (eventPlayer.eventForceRoll < 42.5 and eventCatalogType[candidateIndex] == EventType.BUFF) or
            (eventPlayer.eventForceRoll >= 42.5 and eventPlayer.eventForceRoll < 80 and eventCatalogType[candidateIndex] == EventType.DEBUFF) or
            (eventPlayer.eventForceRoll >= 80 and eventCatalogType[candidateIndex] == EventType.MECH)) and
        (eventCatalogType[candidateIndex] != EventType.BUFF or eventPlayer.supportsPhaseTrigger() or
            (eventCatalogEffectId[candidateIndex] != BuffEventId.PHASE_SURGE and eventCatalogEffectId[candidateIndex] != BuffEventId.BODYGUARD)) and
        (eventCatalogType[candidateIndex] != EventType.BUFF or eventPlayer.playerOnceEventState == null or
            len(eventPlayer.playerOnceEventState) <= PlayerOnceEventSlot.TEMPER_HEART or
            eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.COMPLETED or
            eventCatalogEffectId[candidateIndex] != BuffEventId.TEMPER_HEART) and
        not (eventCatalogType[candidateIndex] == EventType.DEBUFF and
            eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL and
            eventCatalogEffectId[candidateIndex] == DebuffEventId.SELFLESS_GIVEAWAY) and
        (eventCatalogType[candidateIndex] != EventType.MECH or
            eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_SPEED_CHALLENGE or
            eventPlayer.heart_steel[HeartSteelData.STACKS] > 0) and
        (eventCatalogType[candidateIndex] != EventType.MECH or
            (eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_WINNER_TAKE_ALL or
                (gamblerHeartsteelJackpot >= EVT_MECH_24_POOL_MIN and
                    eventPlayer.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_24_PLAYER_STACKS_MIN)) and
            (eventPlayer.heart_steel[HeartSteelData.STACKS] > 0 or
                (eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_SPEED_CHALLENGE and
                    eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_HEART_OF_STEEL and
                    eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_ALL_IN_ART_5)) and
            ((eventPlayer.mod_dmg_perma < 0 or eventPlayer.mod_speed_perma < 0 or
                eventPlayer.mod_heal_perma < 0 or eventPlayer.heart_steel[HeartSteelData.STACKS] < 0) or
                eventCatalogEffectId[candidateIndex] != MechEventId.MIRROR_INVERSION)) and
        (eventPlayer.eventLastId == null or candidateIndex not in eventPlayer.eventLastId)
    )
    if len(eventPlayer.eventTempIndex) <= 0:
        eventPlayer.eventTempIndex = eventCatalogId.filter(lambda candidateIndex:
            eventCatalogWeight[candidateIndex] > 0 and
            (eventPlayer.thiefBuffStolen == true or eventPlayer.eventForceRoll == null or
                (eventPlayer.eventForceRoll < 42.5 and eventCatalogType[candidateIndex] == EventType.BUFF) or
                (eventPlayer.eventForceRoll >= 42.5 and eventPlayer.eventForceRoll < 80 and eventCatalogType[candidateIndex] == EventType.DEBUFF) or
                (eventPlayer.eventForceRoll >= 80 and eventCatalogType[candidateIndex] == EventType.MECH)) and
            (eventCatalogType[candidateIndex] != EventType.BUFF or eventPlayer.supportsPhaseTrigger() or
                (eventCatalogEffectId[candidateIndex] != BuffEventId.PHASE_SURGE and eventCatalogEffectId[candidateIndex] != BuffEventId.BODYGUARD)) and
            (eventCatalogType[candidateIndex] != EventType.BUFF or eventPlayer.playerOnceEventState == null or
                len(eventPlayer.playerOnceEventState) <= PlayerOnceEventSlot.TEMPER_HEART or
                eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.COMPLETED or
                eventCatalogEffectId[candidateIndex] != BuffEventId.TEMPER_HEART) and
            not (eventCatalogType[candidateIndex] == EventType.DEBUFF and
                eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL and
                eventCatalogEffectId[candidateIndex] == DebuffEventId.SELFLESS_GIVEAWAY) and
            (eventCatalogType[candidateIndex] != EventType.MECH or
                eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_SPEED_CHALLENGE or
                eventPlayer.heart_steel[HeartSteelData.STACKS] > 0) and
            (eventCatalogType[candidateIndex] != EventType.MECH or
                (eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_WINNER_TAKE_ALL or
                    (gamblerHeartsteelJackpot >= EVT_MECH_24_POOL_MIN and
                        eventPlayer.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_24_PLAYER_STACKS_MIN)) and
                (eventPlayer.heart_steel[HeartSteelData.STACKS] > 0 or
                    (eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_SPEED_CHALLENGE and
                        eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_HEART_OF_STEEL and
                        eventCatalogEffectId[candidateIndex] != MechEventId.GAMBLER_ALL_IN_ART_5)) and
                ((eventPlayer.mod_dmg_perma < 0 or eventPlayer.mod_speed_perma < 0 or
                    eventPlayer.mod_heal_perma < 0 or eventPlayer.heart_steel[HeartSteelData.STACKS] < 0) or
                    eventCatalogEffectId[candidateIndex] != MechEventId.MIRROR_INVERSION))
        )
