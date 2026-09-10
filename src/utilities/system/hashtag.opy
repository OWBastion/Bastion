#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
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

rule "hashTag | Event Weight Sum Verify":
    @Event global
    @Condition hashTag == true
    @Condition vishkarEventActivated == true
    @Condition hashTagWeightVerifyState[0] != true
    @Condition getTotalTimeElapsed() > 125

    waitUntil(len(eventCatalogId) > 0, 125)

    hashTagWeightVerifyState[1] = 0
    I = 0
    for I in range(len(eventCatalogId)):
        hashTagWeightVerifyState[1] += eventCatalogWeight[eventCatalogId[I]]

    if round(hashTagWeightVerifyState[1] * 1000) != round(EVENT_MANIFEST_ACTIVE_WEIGHT_SUM * 1000):
        hashTag = false
    hashTagWeightVerifyState[0] = true
    logToInspector("[hashTag]: {0},{1}".format(round(hashTagWeightVerifyState[1] * 1000), round(EVENT_MANIFEST_ACTIVE_WEIGHT_SUM * 1000)))

rule "Hashtag":
    @Condition hashTag == true
    @Condition vishkarEventActivated == true
    @Condition getTotalTimeElapsed() > 125
    @Condition any([
            len(eventCatalogId.filter(lambda id: eventCatalogType[id] == EventType.BUFF)) < EVENT_MANIFEST_ACTIVE_BUFF_COUNT,
            len(eventCatalogId.filter(lambda id: eventCatalogType[id] == EventType.DEBUFF)) < EVENT_MANIFEST_ACTIVE_DEBUFF_COUNT,
            len(eventCatalogId.filter(lambda id: eventCatalogType[id] == EventType.MECH)) < EVENT_MANIFEST_ACTIVE_MECH_COUNT
        ]) == true

    wait()
    hashTag = false
