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

    eventPlayer.eventTempIndex = eventPoolIndex
    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.eventTempIndex = eventPlayer.eventTempIndex.filter(lambda index:
        eventPoolWeight[index] > 0 and
        ((eventPlayer.thiefBuffStolen == true and eventPoolType[index] != EventType.BUFF) or
            (eventPlayer.thiefBuffStolen != true and
                (eventPlayer.eventForceRoll == null or
                    (eventPlayer.eventForceRoll < 42.5 and eventPoolType[index] == EventType.BUFF) or
                    (eventPlayer.eventForceRoll >= 42.5 and eventPlayer.eventForceRoll < 80 and eventPoolType[index] == EventType.DEBUFF) or
                    (eventPlayer.eventForceRoll >= 80 and eventPoolType[index] == EventType.MECH)))) and
        (eventPoolType[index] != EventType.BUFF or eventPlayer.supportsPhaseTrigger() or
            (eventPoolId[index] != BuffEventId.PHASE_SURGE and eventPoolId[index] != BuffEventId.BODYGUARD)) and
        (eventPoolType[index] != EventType.BUFF or eventPlayer.playerOnceEventState == null or
            len(eventPlayer.playerOnceEventState) <= PlayerOnceEventSlot.TEMPER_HEART or
            eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.COMPLETED or
            eventPoolId[index] != BuffEventId.TEMPER_HEART) and
        not (eventPoolType[index] == EventType.DEBUFF and
            eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL and
            eventPoolId[index] == DebuffEventId.SELFLESS_GIVEAWAY) and
        (eventPoolType[index] != EventType.MECH or
            eventPoolId[index] != MechEventId.GAMBLER_SPEED_CHALLENGE or
            eventPlayer.heart_steel[HeartSteelData.STACKS] > 0) and
        (eventPoolType[index] != EventType.MECH or
            (eventPoolId[index] != MechEventId.GAMBLER_WINNER_TAKE_ALL or
                (gamblerHeartsteelJackpot >= EVT_MECH_24_POOL_MIN and
                    eventPlayer.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_24_PLAYER_STACKS_MIN)) and
            (eventPlayer.heart_steel[HeartSteelData.STACKS] > 0 or
                (eventPoolId[index] != MechEventId.GAMBLER_SPEED_CHALLENGE and
                    eventPoolId[index] != MechEventId.GAMBLER_HEART_OF_STEEL and
                    eventPoolId[index] != MechEventId.GAMBLER_ALL_IN_ART_5)) and
            ((eventPlayer.mod_dmg_perma < 0 or eventPlayer.mod_speed_perma < 0 or
                eventPlayer.mod_heal_perma < 0 or eventPlayer.heart_steel[HeartSteelData.STACKS] < 0) or
                eventPoolId[index] != MechEventId.MIRROR_INVERSION)) and
        (eventPlayer.eventLastId == null or index not in eventPlayer.eventLastId)
    )
    if len(eventPlayer.eventTempIndex) <= 0:
        eventPlayer.eventTempIndex = eventPoolIndex.filter(lambda index:
            eventPoolWeight[index] > 0 and
            ((eventPlayer.thiefBuffStolen == true and eventPoolType[index] != EventType.BUFF) or
                (eventPlayer.thiefBuffStolen != true and
                    (eventPlayer.eventForceRoll == null or
                        (eventPlayer.eventForceRoll < 42.5 and eventPoolType[index] == EventType.BUFF) or
                        (eventPlayer.eventForceRoll >= 42.5 and eventPlayer.eventForceRoll < 80 and eventPoolType[index] == EventType.DEBUFF) or
                        (eventPlayer.eventForceRoll >= 80 and eventPoolType[index] == EventType.MECH)))) and
            (eventPoolType[index] != EventType.BUFF or eventPlayer.supportsPhaseTrigger() or
                (eventPoolId[index] != BuffEventId.PHASE_SURGE and eventPoolId[index] != BuffEventId.BODYGUARD)) and
            (eventPoolType[index] != EventType.BUFF or eventPlayer.playerOnceEventState == null or
                len(eventPlayer.playerOnceEventState) <= PlayerOnceEventSlot.TEMPER_HEART or
                eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] != TemperHeartState.COMPLETED or
                eventPoolId[index] != BuffEventId.TEMPER_HEART) and
            not (eventPoolType[index] == EventType.DEBUFF and
                eventPlayer.eventForceRoll == EVT_MECH_8_FORCE_ROLL and
                eventPoolId[index] == DebuffEventId.SELFLESS_GIVEAWAY) and
            (eventPoolType[index] != EventType.MECH or
                eventPoolId[index] != MechEventId.GAMBLER_SPEED_CHALLENGE or
                eventPlayer.heart_steel[HeartSteelData.STACKS] > 0) and
            (eventPoolType[index] != EventType.MECH or
                (eventPoolId[index] != MechEventId.GAMBLER_WINNER_TAKE_ALL or
                    (gamblerHeartsteelJackpot >= EVT_MECH_24_POOL_MIN and
                        eventPlayer.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_24_PLAYER_STACKS_MIN)) and
                (eventPlayer.heart_steel[HeartSteelData.STACKS] > 0 or
                    (eventPoolId[index] != MechEventId.GAMBLER_SPEED_CHALLENGE and
                        eventPoolId[index] != MechEventId.GAMBLER_HEART_OF_STEEL and
                        eventPoolId[index] != MechEventId.GAMBLER_ALL_IN_ART_5)) and
                ((eventPlayer.mod_dmg_perma < 0 or eventPlayer.mod_speed_perma < 0 or
                    eventPlayer.mod_heal_perma < 0 or eventPlayer.heart_steel[HeartSteelData.STACKS] < 0) or
                    eventPoolId[index] != MechEventId.MIRROR_INVERSION))
        )
