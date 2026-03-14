# Event: MechEventId.TRINITY_SSR
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 三位一体 (SSR)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.TRINITY_SSR]) == true
    
    if eventPlayer.isAlive():
        eventPlayer.mod_dmg_taken = negToPos(min(EVT_MECH_19_DMG_REDUCE_CAP, eventPlayer.getMaxHealth() / EVT_MECH_19_DMG_REDUCE_DIVISOR))
        eventPlayer.mod_speed_event = eventPlayer.mod_dmg_taken * -EVT_MECH_19_SPEED_FACTOR
        updatePlayerStats()
        eventPlayer.heart_steel += EVT_MECH_19_HEART_STEEL_PER_TICK
        setPlayerHP()
        eventPlayer.hudText = "伤害减免：{0}% / 移速加成：{1}% / 心之钢：{2}层".format(negToPos(eventPlayer.mod_dmg_taken), eventPlayer.mod_speed_event, round(eventPlayer.heart_steel))
    wait(EVT_MECH_19_INTERVAL)
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    eventPlayer.mod_speed_event = 0
    updatePlayerStats()
