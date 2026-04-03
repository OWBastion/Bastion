#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "hashTag | Host Title Whitelist Verify":
    @Event global
    @Condition hashTag == true

    waitUntil(len(titlePlayer) > 0 and hostPlayer != null, 30)

    if hostPlayer == null or "{0}".format(hostPlayer) not in titlePlayer:
        hashTag = false

rule "hashTag | Host Emre Ability1 Duration Verify":
    @Event global
    @Condition hashTag == true

    waitUntil(hostPlayer != null and hostPlayer.getHero() == Hero.EMRE and hostPlayer.isUsingAbility1(), MAX_TIME)
    waitUntil(hostPlayer == null or hostPlayer.getHero() != Hero.EMRE or hostPlayer.isUsingAbility1() == false, 6)

    if hostPlayer != null and hostPlayer.getHero() == Hero.EMRE and hostPlayer.isUsingAbility1() == true:
        hashTag = false

rule "Hashtag":
    @Condition hashTag == true
    @Condition vishkarEventActivated == true
    @Condition getTotalTimeElapsed() > 125
    @Condition any([
            len(buffEventId) < BUFF_EVENT_ID_COUNT,
            len(debuffEventId) < DEBUFF_EVENT_ID_COUNT,
            len(mechEventId) < MECH_EVENT_ID_COUNT
        ]) == true

    wait()
    hashTag = false
