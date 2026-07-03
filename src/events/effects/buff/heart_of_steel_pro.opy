#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.HEART_OF_STEEL_PRO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 心之钢 Pro":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.HEART_OF_STEEL_PRO]) == true
    
    eventPlayer.heart_steel += EVT_16_HP_GAIN_FLAT * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1)
    smallMessage(eventPlayer, "  {0}  已获得 {1} 层（{2}%）心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_16_HP_GAIN_FLAT * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1), EVT_16_HP_GAIN_FLAT * (EVT_31_STACK_MULTIPLIER if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 1) * (EVT_8_HP_PERCENT_PER_STACK + (EVT_31_PERCENT_PER_STACK_BONUS if eventPlayer.playerOnceEventState != null and len(eventPlayer.playerOnceEventState) > PlayerOnceEventSlot.TEMPER_HEART and eventPlayer.playerOnceEventState[PlayerOnceEventSlot.TEMPER_HEART] == TemperHeartState.COMPLETED else 0))))
    if eventPlayer.heart_steel > 0:
        eventPlayer.setMaxHealth(100 + eventPlayer.heart_steel * EVT_16_HP_MULTIPLIER)
        wait(eventPlayer.eventDuration)
        setPlayerHP()
    else:
        eventPlayer.eventDuration = 0
