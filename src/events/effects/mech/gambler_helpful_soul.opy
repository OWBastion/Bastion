#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.GAMBLER_HELPFUL_SOUL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 赌徒：乐于助人":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.GAMBLER_HELPFUL_SOUL, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if random.randint(1, 100) <= EVT_MECH_20_WIN_RATE:
        eventPlayer.target = getLivingPlayers(Team.1)
        eventPlayer.temp = 0
        for eventPlayer.temp in range(len(eventPlayer.target)):
            heal(eventPlayer.target[eventPlayer.temp], eventPlayer, eventPlayer.target[eventPlayer.temp].maxHealthPercent(EVT_MECH_20_HEAL_MAXHP_FACTOR * 100))
        smallMessage(getLivingPlayers(Team.1), "  {0}  赌赢了！恢复{1}%最大生命值".format(iconString(Icon.CLUB), percent(EVT_MECH_20_HEAL_MAXHP_FACTOR)))
    else:
        getLivingPlayers(Team.1).setHealth(1)
        smallMessage(getLivingPlayers(Team.1), "  {0}  赌输了！所有友方生命值降至 1".format(iconString(Icon.DIAMOND)))
    eventPlayer.target = null
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
