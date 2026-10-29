#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_FUGUE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运赋格曲":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventId == EventId.FATE_FUGUE]) == true
    # 额外伤害以无伤害来源施加，不满足此条件，因此不会再次触发本规则而连锁。
    @Condition attacker != null

    # 每次受伤各自独立延迟；eventDamage 为本次触发的事件上下文，等待后仍属于本次伤害。
    wait(EVT_DEBUFF_26_DELAY)
    if eventPlayer.eventId != EventId.FATE_FUGUE or eventPlayer.isAlive() != true:
        return
    damage(eventPlayer, null, eventDamage * EVT_DEBUFF_26_DAMAGE_PERCENT / 100)
