#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "when a mercy might rez, respawn time is increased":
    @Event playerDied
    @Team 2
    @Condition isHeroBeingPlayed(Hero.MERCY, Team.2) == true
    @Condition eventPlayer.controlPlayerRespawnPosition == null

    if eventPlayer.eventId == EventId.NESTING_DOLL:
        return
    
    if eventPlayer.eventId == EventId.HEART_OF_STEEL:
        return
    if getPlayersOnHero(Hero.MERCY, Team.2).any(lambda player:
        distance(eventPlayer.getPosition(), player.getPosition()) < 40 and player.isAlive() and player.getAbilityCooldown(Button.ABILITY_2) < 8
    ):
        bigMessage(eventPlayer, STR_MSG_MERCY_NEARBY)
        eventPlayer.disableRespawn()
        wait(4)
        eventPlayer.enableRespawn()
