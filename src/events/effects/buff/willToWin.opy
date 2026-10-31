#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.WILL_TO_WIN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 胜利意志（预备态）":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.isAlive() and eventPlayer.eventId == EventId.WILL_TO_WIN and eventPlayer.eventEndTime > getTotalTimeElapsed() and not eventPlayer.hasStatus(Status.UNKILLABLE)

    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, Math.INFINITY)

rule "[VishkarEvent]: 胜利意志":
    @Event playerTookDamage
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.isAlive() and eventPlayer.eventId == EventId.WILL_TO_WIN and not eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN]
    @Condition eventDamage >= eventPlayer.getHealth() or eventPlayer.healthAtMostPercent(EVT_14_TRIGGER_HP_PERCENT * 100)

    # Exception: multi-phase revive/invincible flow keeps explicit phase waits.
    wait()
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN])
    wait()
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, EVT_14_INVINCIBLE_DURATION)
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    bigMessage(eventPlayer, "胜利意志！")
    resetPlayerCD()
    heal(eventPlayer, eventPlayer, 99999)
    waitUntil((eventPlayer.eventId == -1 or eventPlayer.isDead() or eventPlayer.eventEndTime <= getTotalTimeElapsed()), 5)
    if eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed():
        return
    requestPlayerEventEnd()
