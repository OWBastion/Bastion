#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.SHARE_THE_PAIN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 有难同当 Effect":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SHARE_THE_PAIN]) == true
    
    wait(getAverageServerLoad() * 0.00032)
    createEffect(getAllPlayers(), Effect.TORBJORN_OVERLOADING, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)

rule "[VishkarEvent]: 有难同当":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.SHARE_THE_PAIN]) == true
    @Condition attacker != null
    @Condition any([eventAbility != null, attacker.getTeam() == Team.1])
    
    # 扩散不会二次触发：本事件全队唯一持有（见 buildCandidatePool 唯一持有门控），
    # 受扩散者必不持有此 debuff，其 eventId 条件必然不满足。
    damage([player for player in getLivingPlayers(Team.1) if not player.hasStatus(Status.PHASED_OUT) and not player.hasStatus(Status.INVINCIBLE) and eventPlayer != player], attacker, eventDamage * EVT_DEBUFF_9_DMG_FACTOR)
