#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/我独自闯关"

# Event: EventId.SOLO_RUN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 独行判定：半径 EVT_36_TEAMMATE_RADIUS 米内没有存活队友时加成生效；
# eventMission 兼作"加成已施加"哨兵（0/1），只在状态翻转时写修正并刷新属性。
# 事件到期/替换时由 clearPlayerEvent 统一清零四类修正字段，循环退出前的兜底
# 清理覆盖哨兵仍置位但事件字段已被先行重置的迟到路径。

rule "Toggle solo bonuses":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SOLO_RUN]) == true

    while eventPlayer.eventId == EventId.SOLO_RUN and eventPlayer.eventEndTime > getTotalTimeElapsed():
        wait(EVT_36_CHECK_INTERVAL)
        if len(getLivingPlayers(Team.1).filter(lambda p: p != eventPlayer and distance(p, eventPlayer) <= EVT_36_TEAMMATE_RADIUS)) == 0:
            if eventPlayer.eventMission != 1:
                eventPlayer.eventMission = 1
                eventPlayer.mod_dmg_taken = -EVT_36_DMG_REDUCTION
                eventPlayer.mod_heal_event = EVT_36_HEAL_BONUS
                eventPlayer.mod_speed_event = EVT_36_SPEED_BONUS
                eventPlayer.knockback = -EVT_36_KNOCKBACK_RESIST
                updatePlayerStats()
        elif eventPlayer.eventMission == 1:
            eventPlayer.eventMission = 0
            eventPlayer.mod_dmg_taken = null
            eventPlayer.mod_heal_event = null
            eventPlayer.mod_speed_event = null
            eventPlayer.knockback = null
            updatePlayerStats()
    if eventPlayer.eventMission == 1:
        eventPlayer.eventMission = 0
        eventPlayer.mod_dmg_taken = null
        eventPlayer.mod_heal_event = null
        eventPlayer.mod_speed_event = null
        eventPlayer.knockback = null
        updatePlayerStats()
