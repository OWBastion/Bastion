#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.THIEF
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 窃贼":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.THIEF, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    wait(0.25)
    if len(getPlayers(Team.2).exclude(eventPlayer)) == 0:
        smallMessage(eventPlayer, "  {0}  没有可窃取的友方目标".format(iconString(Icon.WARNING)))
        eventPlayer.eventDuration = 0
        clearPlayerEvent()
    else:
        eventPlayer.target = random.choice(getPlayers(Team.2).exclude(eventPlayer))
        eventPlayer.eventForceRoll = EVT_MECH_7_FORCE_ROLL
        eventPlayer.eventForceCount = 0
        eventPlayer.target.thiefBuffStolen = true
        # 窃取影响的是“下一个增益”：目标已承诺的增益事件作废，下一次分配按新旗标重掷
        if eventPlayer.target.eventNextIndex != null:
            if eventCatalogType[eventPlayer.target.eventNextIndex] == EventType.BUFF:
                eventPlayer.target.eventNextIndex = null
        # 自身的已承诺事件也需按强制增益旗标重取，保证先知预览与实发一致
        if eventPlayer.eventNextIndex != null:
            rerollNextEvent()
        eventPlayer.dlcTimeChallenge[8]++
        smallMessage(eventPlayer, "  {0}  已窃取一名友方的下一个增益事件".format(iconString(Icon.DIAMOND)))
        smallMessage(eventPlayer.target, "  {0}  你的下一个增益事件已被窃取".format(iconString(Icon.WARNING)))
        eventPlayer.eventDuration = 0
        clearPlayerEvent()
