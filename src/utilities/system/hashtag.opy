#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "hashTag | Event Weight Sum Verify":
    @Event global
    @Condition hashTag == true
    @Condition vishkarEventActivated == true
    @Condition hashTagWeightVerifyState[0] != true
    @Condition getTotalTimeElapsed() > 125

    waitUntil(len(buffEventId) > 0 and len(debuffEventId) > 0 and len(mechEventId) > 0, 125)

    hashTagWeightVerifyState[1] = 0
    I = 0
    for I in range(len(buffEventId)):
        hashTagWeightVerifyState[1] += buffEventWeight[buffEventId[I]]
    for I in range(len(debuffEventId)):
        hashTagWeightVerifyState[1] += debuffEventWeight[debuffEventId[I]]
    for I in range(len(mechEventId)):
        hashTagWeightVerifyState[1] += mechEventWeight[mechEventId[I]]

    if round(hashTagWeightVerifyState[1] * 1000) != round(EVENT_MANIFEST_ACTIVE_WEIGHT_SUM * 1000):
        hashTag = false
    hashTagWeightVerifyState[0] = true
    logToInspector("[hashTag]: {0},{1}".format(round(hashTagWeightVerifyState[1] * 1000), round(EVENT_MANIFEST_ACTIVE_WEIGHT_SUM * 1000)))

rule "Hashtag":
    @Condition hashTag == true
    @Condition vishkarEventActivated == true
    @Condition getTotalTimeElapsed() > 125
    @Condition any([
            len(buffEventId) < EVENT_MANIFEST_ACTIVE_BUFF_COUNT,
            len(debuffEventId) < EVENT_MANIFEST_ACTIVE_DEBUFF_COUNT,
            len(mechEventId) < EVENT_MANIFEST_ACTIVE_MECH_COUNT
        ]) == true

    wait()
    hashTag = false
