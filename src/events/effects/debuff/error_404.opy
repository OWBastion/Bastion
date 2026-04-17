# Event: DebuffEventId.ERROR_404
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

playervar event404DisabledSlot

rule "[VishkarEvent]: 404 (随机禁用技能)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.ERROR_404]) == true
    
    if eventPlayer.getHero() == Hero.LIFEWEAVER:
        eventPlayer.event404DisabledSlot = 3
        goto lbl_1

    if eventPlayer.getHero() == Hero.TORBJORN or eventPlayer.getHero() == Hero.SYMMETRA:
        eventPlayer.event404DisabledSlot = 2
        goto lbl_1
        
    lbl_0:
    eventPlayer.event404DisabledSlot = random.randint(1, 3)
    wait()

    lbl_1:
    if eventPlayer.event404DisabledSlot == 1:
        eventPlayer.disallowButton(Button.ABILITY_1)
        eventPlayer.setAbility1Enabled(false)
        smallMessage(eventPlayer, "  {0}  你的技能 1 已被禁用".format(iconString(Icon.WARNING)))
    elif eventPlayer.event404DisabledSlot == 2:
        eventPlayer.disallowButton(Button.ABILITY_2)
        eventPlayer.setAbility2Enabled(false)
        smallMessage(eventPlayer, "  {0}  你的技能 2 已被禁用".format(iconString(Icon.WARNING)))
    else:
        eventPlayer.disallowButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(false)
        smallMessage(eventPlayer, "  {0}  你的辅助攻击 已被禁用".format(iconString(Icon.WARNING)))
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)
    if eventPlayer.event404DisabledSlot == 1:
        if not (eventPlayer.getHero() == Hero.SYMMETRA and eventPlayer.isWinner != true):
            eventPlayer.allowButton(Button.ABILITY_1)
            eventPlayer.setAbility1Enabled(true)
    elif eventPlayer.event404DisabledSlot == 2:
        if not (eventPlayer.getHero() == Hero.LIFEWEAVER and eventPlayer.isWinner != true):
            eventPlayer.allowButton(Button.ABILITY_2)
            eventPlayer.setAbility2Enabled(true)
    else:
        eventPlayer.allowButton(Button.SECONDARY_FIRE)
        eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.event404DisabledSlot = 0
    clearEventEffect()
