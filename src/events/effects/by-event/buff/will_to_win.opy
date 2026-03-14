# Event: BuffEventId.WILL_TO_WIN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 胜利意志":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive() == true
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.WILL_TO_WIN, eventPlayer.getHealth() <= eventPlayer.getMaxHealth() * EVT_19_TRIGGER_HP_PERCENT]) == true
    
    # Exception: multi-phase revive/invincible flow keeps explicit phase waits.
    waitUntil(eventPlayer.isAlive(), MAX_TIME)
    eventPlayer.setStatusEffect(eventPlayer, Status.PHASED_OUT, 0.016)
    wait()
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    destroyEffect(eventPlayer.invincibleEffect)
    wait()
    if not eventPlayer.isAlive():
        return
    eventPlayer.setStatusEffect(eventPlayer, Status.INVINCIBLE, EVT_19_INVINCIBLE_DURATION)
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.invincibleEffect = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED_SOUND, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    bigMessage(eventPlayer, "胜利意志！")
    resetPlayerCD()
    heal(eventPlayer, eventPlayer, 99999)
    waitUntil(eventPlayer.isDead(), 5)
    eventPlayer.eventDuration = 0
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    destroyEffect(eventPlayer.invincibleEffect)
    eventPlayer.invincibleEffect = null
    clearEventEffect()
