#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.THIEF
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 窃贼":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.THIEF, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.temp = len(getPlayers(Team.1).exclude(eventPlayer))
    eventPlayer.categoryRoll -= EVT_MECH_19_LUCK_SHIFT * eventPlayer.temp
    getPlayers(Team.1).exclude(eventPlayer).categoryRoll += EVT_MECH_19_LUCK_SHIFT
    smallMessage(eventPlayer, "  {0}  偷走 {1} 名队友的幸运值".format(iconString(Icon.DIAMOND), eventPlayer.temp))
    smallMessage(getPlayers(Team.1).exclude(eventPlayer), "  {0}  你的幸运值被偷走了，抽到增益事件的概率降低{1}%".format(iconString(Icon.DIAMOND), EVT_MECH_19_LUCK_SHIFT))
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
