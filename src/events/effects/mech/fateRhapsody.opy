#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_RHAPSODY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运狂想曲":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.FATE_RHAPSODY]) == true

    # 减免 = 已损失生命值百分比，上限 EVT_MECH_27_MAX_REDUCTION；事件结束时 clearPlayerEvent() 清零 mod_dmg_taken，条件转假即中止。
    eventPlayer.mod_dmg_taken = -min(EVT_MECH_27_MAX_REDUCTION, 100 - eventPlayer.getNormalizedHealth() * 100)
    updatePlayerStats()
    wait(EVT_MECH_27_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
