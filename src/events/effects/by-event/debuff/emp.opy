# Event: DebuffEventId.EMP
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 电磁脉冲":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.EMP]) == true
    
    stopChasingVariable(eventPlayer.hack_timer)
    eventPlayer.setStatusEffect(getPlayersOnHero(Hero.BASTION, Team.2)[0], Status.HACKED, EVT_DEBUFF_1_HACK_DURATION)
    playEffect(getAllPlayers(), DynamicEffect.SOMBRA_HACKED_STARTING, Color.TEAM_2, eventPlayer, 200)
    eventPlayer.hack_timer = EVT_DEBUFF_1_HACK_DURATION
    chaseAtRate(eventPlayer.hack_timer, 0, 1, ChaseRateReeval.NONE)
