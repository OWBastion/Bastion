#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.MIRROR_INVERSION
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

rule "[VishkarEvent]: 镜像反转":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.eventId == EventId.MIRROR_INVERSION and eventPlayer.eventMission == 0 and eventPlayer.isHoldingButton(Button.RELOAD)

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.temp = []
    if eventPlayer.mod_dmg_perma > 0:
        eventPlayer.temp.append(MirrorInversionStat.DAMAGE)
    if eventPlayer.mod_speed_perma < 0:
        eventPlayer.temp.append(MirrorInversionStat.SPEED)
    if eventPlayer.mod_heal_perma < 0:
        eventPlayer.temp.append(MirrorInversionStat.HEALING)
    if eventPlayer.heart_steel[HeartSteelData.STACKS] < 0:
        eventPlayer.temp.append(MirrorInversionStat.HEART_STEEL)

    if len(eventPlayer.temp) > 0:
        # o_O 挑战：激活时四个受支持项均为负才进入判定，反转结算后四项全部脱离负向即达成
        eventPlayer.dlcTimeChallenge[2] = len(eventPlayer.temp) == 4
        # eventTempIndex 是事件间候选池暂存槽，事件生效期间不被分配流程读写，此处复用为保底反转项；其余负向项各以 50% 概率独立纳入
        eventPlayer.eventTempIndex = random.choice(eventPlayer.temp)
        eventPlayer.temp = eventPlayer.temp.filter(lambda stat: stat == eventPlayer.eventTempIndex or random.randint(0, 1) == 0)
        if MirrorInversionStat.DAMAGE in eventPlayer.temp:
            eventPlayer.mod_dmg_perma = negToPos(eventPlayer.mod_dmg_perma)
        if MirrorInversionStat.SPEED in eventPlayer.temp:
            eventPlayer.mod_speed_perma = negToPos(eventPlayer.mod_speed_perma)
        if MirrorInversionStat.HEALING in eventPlayer.temp:
            eventPlayer.mod_heal_perma = negToPos(eventPlayer.mod_heal_perma)
        if MirrorInversionStat.HEART_STEEL in eventPlayer.temp:
            eventPlayer.heart_steel[HeartSteelData.STACKS] = negToPos(eventPlayer.heart_steel[HeartSteelData.STACKS])
        eventPlayer.eventMission = 1
        updatePlayerStats()
        setPlayerHP()
        if eventPlayer.dlcTimeChallenge[2] == 1:
            eventPlayer.dlcTimeChallenge[2] = 2 if (eventPlayer.mod_dmg_perma <= 0 and eventPlayer.mod_speed_perma >= 0 and eventPlayer.mod_heal_perma >= 0 and eventPlayer.heart_steel[HeartSteelData.STACKS] >= 0) else 0
        smallMessage(eventPlayer, "  {0}  永久反转已生效".format(iconString(Icon.CHECKMARK)))
