# Event: BuffEventId.HEART_OF_STEEL_PRO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 心之钢 Pro":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.HEART_OF_STEEL_PRO]) == true
    
    eventPlayer.heart_steel += EVT_16_HP_GAIN_FLAT
    smallMessage(eventPlayer, "  {0}  已获得 {1} 层（{2}%）心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_16_HP_GAIN_FLAT, EVT_16_HP_GAIN_FLAT * EVT_8_HP_PERCENT_PER_STACK))
    if eventPlayer.heart_steel > 0:
        eventPlayer.setMaxHealth(100 + eventPlayer.heart_steel * EVT_16_HP_MULTIPLIER)
        wait(eventPlayer.eventDuration)
        setPlayerHP()
    else:
        eventPlayer.eventDuration = 0
