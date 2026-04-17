# Event: BuffEventId.KONAMI_CODE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: ↑↑↓↓←→←→BABA":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.KONAMI_CODE]) == true

    eventPlayer.controlPlayerRespawnPosition = [eventPlayer.getPosition(), eventPlayer.getFacingDirection(), eventPlayer.getHero()]
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_TRANSLOCATING_MATERIAL, Color.TEAM_1, eventPlayer, 200)
    playEffect(eventPlayer, DynamicEffect.SOMBRA_TRANSLOCATING_SOUND, Color.WHITE, eventPlayer, 100)
    if eventPlayer.eventEffect == null:
        createEffect(eventPlayer, Effect.SPARKLES, Color.YELLOW, eventPlayer.controlPlayerRespawnPosition[0], 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        eventPlayer.eventEffect = getLastCreatedEntity()
    wait(EVT_11_CHECKPOINT_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()

rule "[VishkarEvent]: ↑↑↓↓←→←→BABA sync 3in1 checkpoint":
    @Event eachPlayer
    @Team 1
    @Condition controlRespawnPosition != null
    @Condition controlRespawnPosition[eventPlayer.controlJumpIndex] != null
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.KONAMI_CODE, eventPlayer.controlPlayerRespawnPosition != null]) == true
    @Condition any([eventPlayer.hasStatus(Status.PHASED_OUT), eventPlayer.hasStatus(Status.INVINCIBLE)]) == true
    @Condition distance(eventPlayer.getPosition(), controlRespawnPosition[eventPlayer.controlJumpIndex]) <= 4
    @Condition eventPlayer.controlPlayerRespawnPosition[0] != controlRespawnPosition[eventPlayer.controlJumpIndex]

    eventPlayer.controlPlayerRespawnPosition = [controlRespawnPosition[eventPlayer.controlJumpIndex], eventPlayer.getFacingDirection(), eventPlayer.getHero()]

rule "[VishkarEvent]: ↑↑↓↓←→←→BABA":
    @Event playerDied
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.KONAMI_CODE]) == true
    @Condition eventPlayer.isWinner != true
    @Condition eventPlayer.controlPlayerRespawnPosition != []
    
    bigMessage(eventPlayer, "↑↑↓↓←→←→BABA")
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_DISAPPEAR, Color.TEAM_1, eventPlayer, 200)
    eventPlayer.disableRespawn()
    wait(EVT_11_RESPAWN_DELAY)
    eventPlayer.enableRespawn()
    eventPlayer.resurrect()
    eventPlayer.teleport(eventPlayer.controlPlayerRespawnPosition[0])
    eventPlayer.setFacing(eventPlayer.controlPlayerRespawnPosition[1], Relativity.TO_WORLD)
    playEffect(getAllPlayers(), DynamicEffect.TRACER_RECALL_REAPPEAR, Color.TEAM_1, eventPlayer, 200)
    wait(0.5)
    eventPlayer.controlPlayerRespawnPosition = null
    clearEventEffect()
    eventPlayer.eventDuration = 0
