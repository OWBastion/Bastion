#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine updatePlayerStats
subroutine syncPermaDamageReduction

def syncPermaDamageReduction():
    @Name "[VishkarEvent]: sync Perma Damage Reduction"

    if eventPlayer.permaDmgModId != null:
        stopDamageModification(eventPlayer.permaDmgModId)
        eventPlayer.permaDmgModId = null

    if eventPlayer.mod_dmg_perma != 0:
        startDamageModification(
            eventPlayer,
            getPlayers(Team.2),
            max(0.01, 1 + eventPlayer.mod_dmg_perma / 100),
            DamageReeval.RECEIVERS_AND_DAMAGERS
        )
        eventPlayer.permaDmgModId = getLastDamageModification()

def updatePlayerStats():
    @Name "[VishkarEvent]: update Player Stats"
    
    eventPlayer.setMoveSpeed(100 + eventPlayer.mod_speed_perma + eventPlayer.mod_speed_event)
    eventPlayer.setDamageReceived(max(1, 100 + eventPlayer.mod_dmg_taken))
    eventPlayer.setHealingDealt(100 + eventPlayer.mod_heal_event)
    eventPlayer.setHealingReceived(100 + eventPlayer.heal_recv)
    eventPlayer.setKnockbackReceived(100 + eventPlayer.knockback)
    syncPermaDamageReduction()
