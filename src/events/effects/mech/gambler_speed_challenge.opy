# Event: MechEventId.GAMBLER_SPEED_CHALLENGE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：竞速挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SPEED_CHALLENGE, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setHealth(eventPlayer.getMaxHealth() * EVT_MECH_6_HP_PENALTY)
    eventPlayer.categoryRoll = random.uniform(0, 100)
    if eventPlayer.categoryRoll <= EVT_MECH_6_PROB_WIN_NORMAL:
        eventPlayer.mod_speed_perma += EVT_MECH_6_VAL_NORMAL
        eventPlayer.dlcTimeChallenge[0]++
        smallMessage(eventPlayer, "  {0}  赢！永久获得 {1}% 移动速度加成".format(iconString(Icon.CLUB), EVT_MECH_6_VAL_NORMAL))
    elif eventPlayer.categoryRoll <= EVT_MECH_6_PROB_LOSE_NORMAL:
        eventPlayer.mod_speed_perma -= EVT_MECH_6_VAL_NORMAL
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        smallMessage(eventPlayer, "  {0}  输！永久失去 {1}% 移动速度加成".format(iconString(Icon.DIAMOND), EVT_MECH_6_VAL_NORMAL))
    elif eventPlayer.categoryRoll <= EVT_MECH_6_PROB_WIN_RARE:
        eventPlayer.mod_speed_perma += EVT_MECH_6_VAL_RARE
        eventPlayer.dlcTimeChallenge[0]++
        smallMessage(eventPlayer, "  {0}  赢！永久获得 {1}% 移动速度加成".format(iconString(Icon.CLUB), EVT_MECH_6_VAL_RARE))
    else:
        eventPlayer.mod_speed_perma -= EVT_MECH_6_VAL_RARE
        eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
        smallMessage(eventPlayer, "  {0}  输！永久失去 {1}% 移动速度加成".format(iconString(Icon.DIAMOND), EVT_MECH_6_VAL_RARE))
    eventPlayer.categoryRoll = 0
    updatePlayerStats()
    eventPlayer.eventDuration = 0
