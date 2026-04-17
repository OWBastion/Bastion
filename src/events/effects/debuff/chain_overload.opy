# Event: DebuffEventId.CHAIN_OVERLOAD
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 连锁过载 (扁平循环版)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.CHAIN_OVERLOAD]) == true
    
    # 语义重做：仅在技能键按下时触发一次联动冷却（上升沿语义），松开后才允许再次触发。
    if any([eventPlayer.isHoldingButton(Button.ABILITY_1), eventPlayer.isHoldingButton(Button.ABILITY_2), eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)]) == true:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, max(eventPlayer.getAbilityCooldown(Button.ABILITY_1), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, max(eventPlayer.getAbilityCooldown(Button.ABILITY_2), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, max(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE), random.randint(15, 30)))
        waitUntil(any([eventPlayer.isHoldingButton(Button.ABILITY_1), eventPlayer.isHoldingButton(Button.ABILITY_2), eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)]) == false, eventPlayer.eventDuration)
    wait(1, Wait.ABORT_WHEN_FALSE)
    if ruleCondition:
        loop()
    clearEventEffect()
