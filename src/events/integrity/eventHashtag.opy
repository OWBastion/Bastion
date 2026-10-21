#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

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

# eventCatalogWeightTotal 由对局码生成规则维护（开发菜单权重页改权重会置空 masteryRunCode 触发重算）；
# 0.05 为半个权重调整步长，任意有效加权即判负，同时容忍浮点噪声
rule "hashTag | Event Weight Over-Limit":
    @Event global
    @Condition hashTag == true
    @Condition vishkarEventActivated == true
    @Condition eventCatalogWeightTotal > EVENT_MANIFEST_ACTIVE_WEIGHT_SUM + 0.05

    hashTag = false

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
