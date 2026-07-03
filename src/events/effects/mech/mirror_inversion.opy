#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.MIRROR_INVERSION
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 镜像反转":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.MIRROR_INVERSION, eventPlayer.eventMission == 0, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.mod_dmg_perma *= -1
    eventPlayer.mod_speed_perma *= -1
    eventPlayer.mod_heal_perma *= -1
    eventPlayer.heart_steel *= -1
    eventPlayer.eventMission = 1
    updatePlayerStats()
    setPlayerHP()
    smallMessage(eventPlayer, "  {0}  永久反转已生效".format(iconString(Icon.CHECKMARK)))
