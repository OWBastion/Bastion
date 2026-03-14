# Event: DebuffEventId.SHARE_THE_PAIN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 有难同当 Effect":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SHARE_THE_PAIN]) == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    wait(eventPlayer.eventDuration)
    clearEventEffect()

rule "[VishkarEvent]: 有难同当":
    @Event playerTookDamage
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.SHARE_THE_PAIN]) == true
    @Condition attacker.getHero() == Hero.BASTION
    @Condition eventAbility != null
    
    wait()
    damage([player for player in getLivingPlayers(Team.1) if not player.hasStatus(Status.PHASED_OUT) and not player.hasStatus(Status.INVINCIBLE) and distance(eventPlayer, player) <= EVT_DEBUFF_10_RADIUS and eventPlayer != player], attacker, eventDamage * EVT_DEBUFF_10_DMG_FACTOR)
    wait()
