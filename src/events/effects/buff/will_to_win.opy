#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.WILL_TO_WIN
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 胜利意志（预备态）":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventId == EventId.WILL_TO_WIN, eventPlayer.eventMission == 0, eventPlayer.eventDuration > 0, eventPlayer.eventDurationHud > 0, eventPlayer.hasStatus(Status.UNKILLABLE) != true]) == true

    eventPlayer.setStatusEffect(eventPlayer, Status.UNKILLABLE, eventPlayer.eventDuration)
    waitUntil(eventPlayer.eventId != EventId.WILL_TO_WIN, eventPlayer.eventDuration)
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)

rule "[VishkarEvent]: 胜利意志":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventId == EventId.WILL_TO_WIN, eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN] == null]) == true
    @Condition any([eventDamage >= eventPlayer.getHealth(), eventPlayer.healthAtMostPercent(EVT_14_TRIGGER_HP_PERCENT * 100)]) == true

    # Exception: multi-phase revive/invincible flow keeps explicit phase waits.
    # eventMission 哨兵标记本事件已消耗：预备态据此不再重复武装
    eventPlayer.eventMission = 1
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
    waitUntil(eventPlayer.isDead(), 5)
    eventPlayer.eventDuration = 0
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN])
    eventPlayer.invincibleEffect[InvincibleEffectSlot.WILL_TO_WIN] = null
