#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/足力健"

# Event: BuffEventId.SPEED_STACK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "Create effect":
    @Event eachPlayer
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.SPEED_STACK, eventPlayer.eventEffect == null]) == true
    
    createEffect(getAllPlayers() if (eventPlayer.isMoving() and eventPlayer.getSpeed() != 0) else null, Effect.SOLDIER_SPRINTING, Color.TEAM_1, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != BuffEventId.SPEED_STACK or eventPlayer.eventType != EventType.BUFF, eventPlayer.eventDuration)
    clearEventEffect()


rule "Stack movement speed":
    @Event eachPlayer
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.SPEED_STACK, eventPlayer.isMoving(), eventPlayer.getSpeed() != 0]) == true
    
    wait(1, Wait.ABORT_WHEN_FALSE)
    eventPlayer.mod_speed_event += EVT_6_SPEED_INC_PER_SEC
    eventPlayer.hudText = "移速+{0}%".format(eventPlayer.mod_speed_event)
    updatePlayerStats()
    if ruleCondition:
        loop()
    wait(0.032)
    eventPlayer.mod_speed_event = 0
    eventPlayer.hudText = ""
    updatePlayerStats()
