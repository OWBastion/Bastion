#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine clearPlayerEvent

def clearPlayerEvent():
    @Name "[VishkarEvent]: player event end"
    
    eventPlayer.stopForcingThrottle()
    eventPlayer.stopThrottleInDirection()
    eventPlayer.combatRegen = false
    eventPlayer.passiveRegenBlocked = false
    eventPlayer.categoryRoll = null
    eventPlayer.eventId = -1
    eventPlayer.eventType = null
    eventPlayer.eventDuration = null
    eventPlayer.eventName = null
    eventPlayer.eventDesc = null
    eventPlayer.mod_speed_event = null
    eventPlayer.mod_heal_event = null
    eventPlayer.heal_recv = null
    eventPlayer.mod_dmg_taken = null
    eventPlayer.targetWeight = null
    eventPlayer.targetSilence = false
    eventPlayer.knockback = null
    eventPlayer.sizeHealth = 1
    eventPlayer.eventSize = 0
    eventPlayer.altFormTrigger = false
    if eventPlayer.isWinner:
        goto lbl_0
    destroyEffect(eventPlayer.invincibleEffect)
    lbl_0:
    eventPlayer.eventMission = 0
    eventPlayer.event404DisabledSlot = 0
    eventPlayer.hudText = ""
    eventPlayer.target = null
    eventPlayer.possess = null
    eventPlayer.stopScalingSize()
    eventPlayer.stopScalingBarriers()
    eventPlayer.stopModifyingVoicelinePitch()
    updatePlayerStats()
    clearEventEffect()
    smallMessage(
        eventPlayer, 
        STR_MSG_EVENT_ENDED.format(
            abilityIconString(Hero.MOIRA, Button.ABILITY_2)
        )
    )
