#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.FATE_PRELUDE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 命运序曲":
    @Event playerTookDamage
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventId == EventId.FATE_PRELUDE]) == true

    # 受伤事件在伤害结算后触发，故以等量回复抵消；无持久状态，事件结束后规则条件自然失效。
    heal(eventPlayer, null, min(EVT_38_ABSORB, eventDamage))
