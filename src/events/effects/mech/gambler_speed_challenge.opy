#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_SPEED_CHALLENGE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：竞速挑战":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.GAMBLER_SPEED_CHALLENGE, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.heart_steel <= 0:
        smallMessage(eventPlayer, "  {0}  心之钢层数不足".format(iconString(Icon.DIAMOND)))
    else:
        eventPlayer.heart_steel -= EVT_MECH_6_HP_PENALTY
        eventPlayer.temp = random.uniform(0, 100)
        if eventPlayer.temp <= EVT_MECH_6_PROB_WIN_NORMAL:
            eventPlayer.mod_speed_perma += EVT_MECH_6_VAL_NORMAL
            eventPlayer.dlcTimeChallenge[0]++
            eventPlayer.dlcTimeChallenge[3]++
            smallMessage(eventPlayer, "  {0}  赢！永久获得 {1}% 移动速度加成".format(iconString(Icon.CLUB), EVT_MECH_6_VAL_NORMAL))
        elif eventPlayer.temp <= EVT_MECH_6_PROB_LOSE_NORMAL:
            eventPlayer.mod_speed_perma -= EVT_MECH_6_VAL_NORMAL
            eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
            eventPlayer.dlcTimeChallenge[4]++
            smallMessage(eventPlayer, "  {0}  输！永久失去 {1}% 移动速度加成".format(iconString(Icon.DIAMOND), EVT_MECH_6_VAL_NORMAL))
        elif eventPlayer.temp <= EVT_MECH_6_PROB_WIN_RARE:
            eventPlayer.mod_speed_perma += EVT_MECH_6_VAL_RARE
            eventPlayer.dlcTimeChallenge[0]++
            eventPlayer.dlcTimeChallenge[3]++
            smallMessage(eventPlayer, "  {0}  赢！永久获得 {1}% 移动速度加成".format(iconString(Icon.CLUB), EVT_MECH_6_VAL_RARE))
        else:
            eventPlayer.mod_speed_perma -= EVT_MECH_6_VAL_RARE
            eventPlayer.dlcTimeChallenge[0] = 0 if eventPlayer.dlcTimeChallenge[0] > 0 else eventPlayer.dlcTimeChallenge[0] - 1
            eventPlayer.dlcTimeChallenge[4]++
            smallMessage(eventPlayer, "  {0}  输！永久失去 {1}% 移动速度加成".format(iconString(Icon.DIAMOND), EVT_MECH_6_VAL_RARE))
    wait()
    updatePlayerStats()
    eventPlayer.eventDuration = 0
