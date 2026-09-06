#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.MIRROR_INVERSION
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 镜像反转":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.MIRROR_INVERSION
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.eventMission == 0
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.temp = []
    if eventPlayer.mod_dmg_perma < 0:
        eventPlayer.temp.append(MirrorInversionStat.DAMAGE)
    if eventPlayer.mod_speed_perma < 0:
        eventPlayer.temp.append(MirrorInversionStat.SPEED)
    if eventPlayer.mod_heal_perma < 0:
        eventPlayer.temp.append(MirrorInversionStat.HEALING)
    if eventPlayer.heart_steel[HeartSteelData.STACKS] < 0:
        eventPlayer.temp.append(MirrorInversionStat.HEART_STEEL)

    if len(eventPlayer.temp) > 0:
        eventPlayer.temp = random.choice(eventPlayer.temp)
        if eventPlayer.temp == MirrorInversionStat.DAMAGE:
            eventPlayer.mod_dmg_perma = negToPos(eventPlayer.mod_dmg_perma)
        elif eventPlayer.temp == MirrorInversionStat.SPEED:
            eventPlayer.mod_speed_perma = negToPos(eventPlayer.mod_speed_perma)
        elif eventPlayer.temp == MirrorInversionStat.HEALING:
            eventPlayer.mod_heal_perma = negToPos(eventPlayer.mod_heal_perma)
        elif eventPlayer.temp == MirrorInversionStat.HEART_STEEL:
            eventPlayer.heart_steel[HeartSteelData.STACKS] = negToPos(eventPlayer.heart_steel[HeartSteelData.STACKS])
        eventPlayer.eventMission = 1
        updatePlayerStats()
        setPlayerHP()
        smallMessage(eventPlayer, "  {0}  永久反转已生效".format(iconString(Icon.CHECKMARK)))
