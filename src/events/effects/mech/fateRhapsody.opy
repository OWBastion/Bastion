#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_RHAPSODY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运狂想曲":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.FATE_RHAPSODY]) == true

    # 重复触发（如重生）时先释放旧修正，避免叠加。
    if len(eventPlayer.eventModificationId) > 0:
        stopDamageModification(eventPlayer.eventModificationId[0])
    # 受到的伤害百分比 = 剩余生命值百分比，下限为 100 - 减免上限；由引擎持续重新求值，无需轮询。
    startDamageModification(eventPlayer, getAllPlayers(), max(100 - EVT_MECH_27_MAX_REDUCTION, min(100, eventPlayer.getNormalizedHealth() * 100)), DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
    eventPlayer.eventModificationId = [getLastDamageModification()]
    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    if len(eventPlayer.eventModificationId) > 0:
        stopDamageModification(eventPlayer.eventModificationId[0])
        eventPlayer.eventModificationId = []

rule "[VishkarEvent]: 命运狂想曲 (玩家离开)":
    @Event playerLeft
    @Team 1
    @Condition all([eventPlayer.eventId == EventId.FATE_RHAPSODY, len(eventPlayer.eventModificationId) > 0]) == true

    stopDamageModification(eventPlayer.eventModificationId[0])
    eventPlayer.eventModificationId = []
