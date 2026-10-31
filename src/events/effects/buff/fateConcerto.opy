#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_CONCERTO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

# 异步结算：治疗事件只累加 concertoPending，由分发循环按间隔统一结算，避免每次治疗都遍历持有者。
rule "[VishkarEvent]: 命运协奏曲 (记录治疗)":
    @Event playerReceivedHealing
    @Team 1
    @Condition eventHealing() > 0

    # 额外治疗以“治疗者 = 接收者 = 持有者”标记：持有者之间不互相触发，不会递归放大。
    if eventPlayer.eventId == EventId.FATE_CONCERTO and attacker == eventPlayer:
        return
    eventPlayer.concertoPending += eventHealing()

rule "[VishkarEvent]: 命运协奏曲 (分发治疗)":
    @Event global
    @Condition len(getPlayers(Team.1).filter(lambda owner: owner.eventId == EventId.FATE_CONCERTO)) > 0

    # 丢弃无持有者期间累积的治疗量。
    getPlayers(Team.1).concertoPending = 0
    while len(getPlayers(Team.1).filter(lambda owner: owner.eventId == EventId.FATE_CONCERTO)) > 0:
        wait(EVT_40_DISPATCH_INTERVAL)
        concertoTotal = 0
        for I in range(len(getPlayers(Team.1))):
            concertoTotal += getPlayers(Team.1)[I].concertoPending
        # 持有者获得“除自己以外的友方”本周期受治疗总量。
        for I in range(len(getPlayers(Team.1))):
            if getPlayers(Team.1)[I].eventId == EventId.FATE_CONCERTO:
                heal(getPlayers(Team.1)[I], getPlayers(Team.1)[I], (concertoTotal - getPlayers(Team.1)[I].concertoPending) * EVT_40_HEAL_BONUS / 100)
        getPlayers(Team.1).concertoPending = 0
