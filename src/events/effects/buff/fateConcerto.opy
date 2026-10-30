#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_CONCERTO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运协奏曲":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.FATE_CONCERTO]) == true

    # 重复触发（如重生）时先释放旧修正，避免叠加。
    if len(eventPlayer.eventModificationId) > 0:
        stopHealingModification(eventPlayer.eventModificationId[0])
    # 治疗者由引擎持续重新求值，排除自己即排除自我治疗；额外 300% = 总计 400%。
    startHealingModification(eventPlayer, getPlayers(Team.1).exclude(eventPlayer), 100 + EVT_40_HEAL_BONUS, HealingReeval.RECEIVERS_HEALERS_AND_HEALPERCENT)
    eventPlayer.eventModificationId = [getLastHealingModification()]
    waitPlayerEventEnd()
    if len(eventPlayer.eventModificationId) > 0:
        stopHealingModification(eventPlayer.eventModificationId[0])
        eventPlayer.eventModificationId = []

rule "[VishkarEvent]: 命运协奏曲 (玩家离开)":
    @Event playerLeft
    @Team 1
    @Condition all([eventPlayer.eventId == EventId.FATE_CONCERTO, len(eventPlayer.eventModificationId) > 0]) == true

    stopHealingModification(eventPlayer.eventModificationId[0])
    eventPlayer.eventModificationId = []
