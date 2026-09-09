#!mainFile "../main.opy"

#!optimizeStrict

rule "hashTag | Host Title Whitelist Verify":
    @Event global
    @Condition getTotalTimeElapsed() > 30
    @Condition hashTag == true

    waitUntil(len(titlePlayer) > 0 and hostPlayer != null, Math.INFINITY)

    if "{0}".format(hostPlayer) not in titlePlayer:
        hashTag = false

rule "hashTag | Host Emre Ability1 Duration Verify":
    @Event global
    @Condition hashTag == true

    waitUntil(hostPlayer != null and hostPlayer.getHero() == Hero.EMRE and hostPlayer.isUsingAbility1(), Math.INFINITY)
    waitUntil(hostPlayer == null or hostPlayer.getHero() != Hero.EMRE or hostPlayer.isUsingAbility1() == false, 6)

    if hostPlayer != null and hostPlayer.getHero() == Hero.EMRE and hostPlayer.isUsingAbility1() == true:
        hashTag = false
