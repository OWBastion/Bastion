#!mainFile "../anniversary2026.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "BerserkerHeart"

#!define BERSERKER_HEART_INTERVAL 60
#!define BERSERKER_HEART_DURATION 30

rule "Periodically berserk one Bastion bot":
    @Condition len([player for player in getPlayersOnHero(Hero.BASTION, Team.1) if player.isDummy() and player.isAlive()]) > 0

    wait(BERSERKER_HEART_INTERVAL, Wait.ABORT_WHEN_FALSE)
    random.choice([player for player in getPlayersOnHero(Hero.BASTION, Team.1) if player.isDummy() and player.isAlive()]).hasNano = true
    berserkerTime = BERSERKER_HEART_DURATION
    if ruleCondition:
        loop()
