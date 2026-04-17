# Event: BuffEventId.HYPERACTIVE_HEAL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 多动症 (触发回血)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.HYPERACTIVE_HEAL, eventPlayer.phase_trigger == true]) == true
    
    if eventPlayer.getAbilityCooldown(Button.ABILITY_1) > EVT_22_CD_THRESHOLD:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, eventPlayer.getAbilityCooldown(Button.ABILITY_1) * 0.5)
    if eventPlayer.getAbilityCooldown(Button.ABILITY_2) > EVT_22_CD_THRESHOLD:
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, eventPlayer.getAbilityCooldown(Button.ABILITY_2) * 0.5)
    eventPlayer.startHealingOverTime(eventPlayer, EVT_22_HOT_DIVISOR, (round(50 + eventPlayer.getMaxHealth() * EVT_22_HOT_MAXHP_FACTOR)) / EVT_22_HOT_DIVISOR)
    wait(EVT_22_POST_WAIT)
