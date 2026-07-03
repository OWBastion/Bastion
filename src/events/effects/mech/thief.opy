#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.THIEF
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 窃贼":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.THIEF, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.target = getPlayers(Team.1).exclude(eventPlayer)
    wait(0.25)
    if len(eventPlayer.target) == 0:
        smallMessage(eventPlayer, "  {0}  没有可窃取的友方目标".format(iconString(Icon.WARNING)))
        eventPlayer.eventDuration = 0
        clearPlayerEvent()
    else:
        eventPlayer.target = random.choice(eventPlayer.target)
        eventPlayer.eventForceRoll = EVT_MECH_7_FORCE_ROLL
        eventPlayer.eventForceCount = 0
        eventPlayer.target.thiefBuffStolen = true
        smallMessage(eventPlayer, "  {0}  已窃取 {1} 的下一个增益事件".format(iconString(Icon.DIAMOND), eventPlayer.target))
        smallMessage(eventPlayer.target, "  {0}  你的下一个增益事件已被窃取".format(iconString(Icon.WARNING)))
        eventPlayer.eventDuration = 0
        clearPlayerEvent()
