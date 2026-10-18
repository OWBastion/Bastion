#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/我独自决定"

# Event: EventId.SOLO_DECIDE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# eventMission 兼作"已决定"哨兵：长按换弹或互动任一落定后事件即消耗，防止重复按键叠加。
# 续时/提前结束统一改 eventEndTime（运行时权威截止），交由各玩家 assignPlayerEvent
# 的到期分支走 clearPlayerEvent 全量清理；自身消耗经 requestPlayerEventEnd 走同一路径。

rule "Extend everyone's event on reload":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SOLO_DECIDE, eventPlayer.eventMission == 0, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.eventId != EventId.SOLO_DECIDE or eventPlayer.eventMission != 0:
        return
    eventPlayer.eventMission = 1
    eventPlayer.temp = [player for player in getPlayers(Team.1) if player != eventPlayer and player.eventId != -1 and player.eventEndTime > getTotalTimeElapsed()]
    for I in range(len(eventPlayer.temp)):
        # 我觉得可以 挑战：续期对象覆盖队友的「我独自升级」即达成
        if eventPlayer.temp[I].eventId == EventId.SOLO_LEVEL_UP:
            eventPlayer.dlcTimeChallenge[5] = 1
        eventPlayer.temp[I].eventEndTime += EVT_26_EXTEND_SECONDS
        eventPlayer.temp[I].eventDurationHud = ceil(max(0, eventPlayer.temp[I].eventEndTime - getTotalTimeElapsed()))
    eventPlayer.temp = null
    bigMessage(eventPlayer, "我独自决定：全员事件延长 {0} 秒".format(EVT_26_EXTEND_SECONDS))
    requestPlayerEventEnd()

rule "End everyone's event on interact":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SOLO_DECIDE, eventPlayer.eventMission == 0, eventPlayer.isHoldingButton(Button.INTERACT)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.eventId != EventId.SOLO_DECIDE or eventPlayer.eventMission != 0:
        return
    eventPlayer.eventMission = 1
    eventPlayer.temp = [player for player in getPlayers(Team.1) if player != eventPlayer and player.eventId != -1]
    for I in range(len(eventPlayer.temp)):
        eventPlayer.temp[I].eventEndTime = getTotalTimeElapsed()
        eventPlayer.temp[I].eventDurationHud = 0
    # 我觉得不行 挑战：被同时结束的队友事件中，减益事件 ID 至少有两种
    eventPlayer.eventTempIndex = [player.eventId for player in eventPlayer.temp if player.eventType == EventType.DEBUFF]
    if len(eventPlayer.eventTempIndex.filter(lambda id: id != eventPlayer.eventTempIndex[0])) > 0:
        eventPlayer.dlcTimeChallenge[4] = 1
    eventPlayer.eventTempIndex = []
    eventPlayer.temp = null
    bigMessage(eventPlayer, "我独自决定：全员事件立即结束")
    requestPlayerEventEnd()
