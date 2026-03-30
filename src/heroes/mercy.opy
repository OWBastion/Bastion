#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "when a mercy might rez, respawn time is increased":
    @Event playerDied
    @Team 1
    @Condition isHeroBeingPlayed(Hero.MERCY, Team.1) == true
    @Condition eventPlayer.controlPlayerRespawnPosition == null

    if dlcVishkarEvent and eventPlayer.eventType == 2 and eventPlayer.eventId == MechEventId.NESTING_DOLL:
        return
    
    if dlcVishkarEvent and eventPlayer.eventType == 0 and eventPlayer.eventId == BuffEventId.HEART_OF_STEEL:
        return
    if getPlayersOnHero(Hero.MERCY, Team.1).any(lambda player:
        distance(eventPlayer.getPosition(), player.getPosition()) < 40 and player.isAlive() and player.getAbilityCooldown(Button.ABILITY_2) < 8
    ):
        bigMessage(eventPlayer, STR_MSG_MERCY_NEARBY)
        eventPlayer.disableRespawn()
        wait(4)
        eventPlayer.enableRespawn()
