# Event: DebuffEventId.CHAIN_OVERLOAD
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 连锁过载 (扁平循环版)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.CHAIN_OVERLOAD]) == true
    
    if any([eventPlayer.getAbilityCooldown(Button.ABILITY_1) > 0, eventPlayer.getAbilityCooldown(Button.ABILITY_2) > 0, eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE) > 0, eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE) > 0, eventPlayer.getAbilityCooldown(Button.RELOAD) > 0, eventPlayer.getAbilityCooldown(Button.JUMP) > 0]) == true:
        eventPlayer.setAbilityCooldown(Button.ABILITY_1, max(eventPlayer.getAbilityCooldown(Button.ABILITY_1), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.ABILITY_2, max(eventPlayer.getAbilityCooldown(Button.ABILITY_2), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.SECONDARY_FIRE, max(eventPlayer.getAbilityCooldown(Button.SECONDARY_FIRE), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.PRIMARY_FIRE, max(eventPlayer.getAbilityCooldown(Button.PRIMARY_FIRE), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.RELOAD, max(eventPlayer.getAbilityCooldown(Button.RELOAD), random.randint(15, 30)))
        eventPlayer.setAbilityCooldown(Button.JUMP, max(eventPlayer.getAbilityCooldown(Button.JUMP), random.randint(15, 30)))
    wait(eventPlayer.eventDuration)
    if ruleCondition:
        loop()
    clearEventEffect()
