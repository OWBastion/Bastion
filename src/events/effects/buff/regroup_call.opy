# Event: BuffEventId.REGROUP_CALL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 向我靠拢":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.REGROUP_CALL]) == true
    
    wait(EVT_13_CHECK_INTERVAL, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventEffectPlayers = [player for player in getLivingPlayers(Team.1) if distance(eventPlayer, player) <= EVT_13_RADIUS and isInLoS(eventPlayer, player) == true and not player.hasStatus(Status.INVINCIBLE)]
    eventPlayer.eventEffectPlayers.invincible = [true, eventPlayer, EVT_13_INVINCIBLE_DURATION]
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.eventEffectPlayers = null
    if ruleCondition:
        loop()

rule "[VishkarEvent]: 向我靠拢":
    @Event eachPlayer
    @Team 1
    @Condition (all([eventPlayer.hasSpawned(), not eventPlayer.hasStatus(Status.INVINCIBLE), len(eventPlayer.invincible) >= 3])) == true
    
    eventPlayer.setStatusEffect(eventPlayer.invincible[1], Status.INVINCIBLE, eventPlayer.invincible[2])
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.invincibleEffect = getLastCreatedEntity()
    smallMessage(eventPlayer, "  {0}  {1}（{2}） 为你提供 {3}秒无敌效果".format(abilityIconString(Hero.BAPTISTE, Button.ABILITY_2), eventPlayer.invincible[1], eventPlayer.invincible[1].getHero(), EVT_13_INVINCIBLE_DURATION))
    wait(EVT_13_INVINCIBLE_DURATION)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    destroyEffect(eventPlayer.invincibleEffect)
    eventPlayer.invincibleEffect = null
    eventPlayer.invincible = null
