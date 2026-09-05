#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.F5_REFRESH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: F5 (循环刷新)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.BUFF
    @Condition eventPlayer.eventId == BuffEventId.F5_REFRESH
    @Condition eventPlayer.hasSpawned()
    
    resetPlayerCD()
    wait(EVT_24_REFRESH_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
