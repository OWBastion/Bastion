#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine clearPlayerEvent

def clearPlayerEvent():
    @Name "[VishkarEvent]: player event end"
    
    if eventPlayer.eventType == EventType.BUFF and eventPlayer.eventId == BuffEventId.WHERE_YOU_FALL:
        eventPlayer.clearStatusEffect(Status.UNKILLABLE)
        if eventPlayer.eventMission == 1:
            eventPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
            eventPlayer.eventMission = 0
            kill(eventPlayer, eventPlayer)

    clearEventEffect()
    eventPlayer.stopForcingThrottle()
    eventPlayer.stopThrottleInDirection()
    eventPlayer.combatRegen = false
    eventPlayer.passiveRegenBlocked = false
    eventPlayer.eventId = -1
    eventPlayer.eventType = null
    eventPlayer.eventCategoryCommitted = false
    eventPlayer.eventCandidateIndex = null
    eventPlayer.eventTempIndex = []
    eventPlayer.eventLoopCount = 0
    eventPlayer.eventIsSelected = false
    eventPlayer.eventDuration = null
    eventPlayer.eventDurationHud = 0
    eventPlayer.eventName = null
    eventPlayer.eventDesc = null
    eventPlayer.eventEffectPlayers = null
    eventPlayer.mod_speed_event = null
    eventPlayer.mod_heal_event = null
    eventPlayer.heal_recv = null
    eventPlayer.mod_dmg_taken = null
    eventPlayer.targetWeight = null
    eventPlayer.targetSilence = false
    eventPlayer.knockback = null
    eventPlayer.sizeHealth = 1
    eventPlayer.eventSize = 0
    eventPlayer.eventTargetHP = 0
    eventPlayer.altFormActive = false
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.DEATH_DELAY])
    eventPlayer.invincibleEffect[InvincibleEffectSlot.DEATH_DELAY] = null
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN])
    eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN] = null
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.hudText = ""
    eventPlayer.target = null
    eventPlayer.possess = null
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.stopModifyingVoicelinePitch()
    updatePlayerStats()
    smallMessage(
        eventPlayer, 
        STR_MSG_EVENT_ENDED.format(
            abilityIconString(Hero.MOIRA, Button.ABILITY_2)
        )
    )
