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

    eventPlayer.eventTempIndex = eventCatalogId.filter(lambda candidateIndex: eventCatalogWeight[candidateIndex] > 0)
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.thiefBuffStolen == true:
        eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] != EventType.BUFF)
    elif eventPlayer.eventForceRoll != null:
        if eventPlayer.eventForceRoll < 42.5:
            eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] == EventType.BUFF)
        elif eventPlayer.eventForceRoll < 80:
            eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] == EventType.DEBUFF)
        else:
            eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: eventCatalogType[candidateIndex] == EventType.MECH)

    if eventPlayer.supportsPhaseTrigger() == false:
        eventPlayer.eventTempIndex.remove(BuffEventId.PHASE_SURGE)
        eventPlayer.eventTempIndex.remove(BuffEventId.BODYGUARD)
    if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED:
        eventPlayer.eventTempIndex.remove(BuffEventId.TEMPER_HEART)
    if eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL:
        eventPlayer.eventTempIndex.remove(BUFF_EVENT_ID_COUNT + DebuffEventId.SELFLESS_GIVEAWAY)
    if eventPlayer.heart_steel[HeartSteelData.STACKS] <= 0:
        eventPlayer.eventTempIndex.remove(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_SPEED_CHALLENGE)
        eventPlayer.eventTempIndex.remove(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_HEART_OF_STEEL)
        eventPlayer.eventTempIndex.remove(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_ALL_IN_ART_5)
    if gamblerHeartsteelJackpot < EVT_MECH_24_POOL_MIN or eventPlayer.heart_steel[HeartSteelData.STACKS] < EVT_MECH_24_PLAYER_STACKS_MIN:
        eventPlayer.eventTempIndex.remove(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.GAMBLER_WINNER_TAKE_ALL)
    if eventPlayer.mod_dmg_perma >= 0 and eventPlayer.mod_speed_perma >= 0 and eventPlayer.mod_heal_perma >= 0 and eventPlayer.heart_steel[HeartSteelData.STACKS] >= 0:
        eventPlayer.eventTempIndex.remove(BUFF_EVENT_ID_COUNT + DEBUFF_EVENT_ID_COUNT + MechEventId.MIRROR_INVERSION)

    eventPlayer.eventHardCandidateIndex = eventPlayer.eventTempIndex
    if eventPlayer.eventLastId != null:
        eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda candidateIndex: candidateIndex not in eventPlayer.eventLastId)
    if len(eventPlayer.eventTempIndex) <= 0:
        eventPlayer.eventTempIndex = eventPlayer.eventHardCandidateIndex
