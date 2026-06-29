#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "System"

playervar combatRegen 75
playervar passiveRegenBlocked

rule "Run passive regen":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.passiveRegenBlocked != true
    @Condition eventPlayer.combatRegen == true

    eventPlayer.combatRegen = false
    if any([
        eventPlayer.isDead(),
        eventPlayer.getNormalizedHealth() == 1,
        eventPlayer.heal_recv <= -100
    ]):
        return

    smallMessage(
        eventPlayer,
        STR_MSG_PASSIVE_HEAL_START.format(
            abilityIconString(Hero.BAPTISTE, Button.ABILITY_1)
        )
    )
    eventPlayer.startHealingOverTime(eventPlayer, Math.INFINITY, 50 + eventPlayer.getMaxHealth() * 0.08)
    eventPlayer.healID = getLastHealingOverTimeId()
    waitUntil(any([
        eventPlayer.passiveRegenBlocked,
        eventPlayer.isDead(),
        eventPlayer.getNormalizedHealth() == 1,
        eventPlayer.heal_recv <= -100,
        eventPlayer.healID == 0
    ]), Math.INFINITY)
    if eventPlayer.healID != 0:
        stopHealingOverTime(eventPlayer.healID)
        eventPlayer.healID = 0


rule "Arm passive regen":
    @Event playerTookDamage
    @Team 1
    # @Condition attacker.getHero() == Hero.BASTION and attacker != eventPlayer

    eventPlayer.combatRegen = false
    if eventPlayer.healID != 0:
        stopHealingOverTime(eventPlayer.healID)
        eventPlayer.healID = 0
    wait(3, Wait.RESTART_WHEN_TRUE)
    eventPlayer.combatRegen = true
