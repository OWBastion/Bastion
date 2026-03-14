# Event: DebuffEventId.EMP_PROMAX
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 电磁脉冲 ProMax":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.EMP_PROMAX]) == true
    
    ([player for player in getPlayers(Team.1) if distance(eventPlayer, player) <= EVT_DEBUFF_7_RADIUS]).empProMax = eventPlayer
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_EMP_EXPLOSION_EFFECT, Color.TEAM_2, eventPlayer, 200)
    wait(eventPlayer.eventDuration - 1)
    getPlayers(Team.1).empProMax = null

rule "[VishkarEvent]: 电磁脉冲 ProMax":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.hasStatus(Status.HACKED) != true, eventPlayer.empProMax != null, eventPlayer.hack_timer == 0]) == true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.hack_timer = max(0, EVT_DEBUFF_7_HACK_BASE_DURATION if eventPlayer.empProMax == eventPlayer else EVT_DEBUFF_7_HACK_BASE_DURATION - distance(eventPlayer, eventPlayer.empProMax) * EVT_DEBUFF_7_DIST_FACTOR)
    if eventPlayer.hack_timer <= EVT_DEBUFF_7_MIN_HACK_THRESHOLD:
        goto lbl_0
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_HACKED_STARTING, Color.TEAM_2, eventPlayer, 200)
    lbl_0:
    eventPlayer.setStatusEffect(eventPlayer.empProMax, Status.HACKED, eventPlayer.hack_timer)
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)
    wait(eventPlayer.hack_timer)
    eventPlayer.hack_timer = 0
    eventPlayer.empProMax = null
