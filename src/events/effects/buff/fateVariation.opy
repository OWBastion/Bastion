#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_VARIATION
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运变奏曲 (受伤)":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventId == EventId.FATE_VARIATION]) == true

    # eventMission 借用为最近受伤时刻；clearPlayerEvent() 结束时统一清零。
    # 重复受伤只重置时刻与加成，不叠加。
    eventPlayer.eventMission = getTotalTimeElapsed()
    eventPlayer.mod_speed_event = EVT_39_SPEED_BOOST
    updatePlayerStats()

rule "[VishkarEvent]: 命运变奏曲 (衰减)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.FATE_VARIATION, eventPlayer.mod_speed_event > 0]) == true

    # 事件结束时 clearPlayerEvent() 会清零 mod_speed_event 并刷新属性，条件转假即中止。
    wait(EVT_39_DECAY_STEP, Wait.ABORT_WHEN_FALSE)
    eventPlayer.mod_speed_event = max(0, EVT_39_SPEED_BOOST * (1 - (getTotalTimeElapsed() - eventPlayer.eventMission) / EVT_39_DECAY_SECONDS))
    updatePlayerStats()
    if ruleCondition:
        loop()
