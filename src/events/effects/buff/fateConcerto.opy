#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_CONCERTO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运协奏曲":
    @Event playerReceivedHealing
    @Team 1
    @Condition eventHealing() > 0

    # 额外治疗以“治疗者 = 接收者 = 持有者”标记：持有者之间不互相触发，不会递归放大。
    if eventPlayer.eventId == EventId.FATE_CONCERTO and attacker == eventPlayer:
        return
    for I in range(len(getPlayers(Team.1))):
        if getPlayers(Team.1)[I].eventId == EventId.FATE_CONCERTO and getPlayers(Team.1)[I] != eventPlayer:
            heal(getPlayers(Team.1)[I], getPlayers(Team.1)[I], eventHealing() * EVT_40_HEAL_BONUS / 100)
