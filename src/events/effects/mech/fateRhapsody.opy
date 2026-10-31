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
    # 受到的伤害比例 = max(100 - 上限, 当前生命值%)，即减免 = 已损失生命值%；引擎按受击时的生命值持续重估。
    startDamageModification(eventPlayer, getAllPlayers(), max(100 - EVT_MECH_27_MAX_REDUCTION, eventPlayer.getNormalizedHealth() * 100), DamageReeval.RECEIVERS_DAMAGERS_AND_DMGPERCENT)
    eventPlayer.eventModificationId = [getLastDamageModification()]
    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    if len(eventPlayer.eventModificationId) > 0:
        stopDamageModification(eventPlayer.eventModificationId[0])
        eventPlayer.eventModificationId = []
