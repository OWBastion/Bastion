#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.DIVINE_REINFORCEMENT
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 天降神兵":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.DIVINE_REINFORCEMENT, eventPlayer.altFormTrigger != true, getTotalTimeElapsed() >= eventPlayer.eventMissionGoal, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_30_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.altFormTrigger = true
    eventPlayer.target = getLivingPlayers(Team.1).exclude(eventPlayer)
    eventPlayer.temp = len(eventPlayer.target) > 0
    if eventPlayer.temp:
        eventPlayer.target = (sorted(eventPlayer.target, lambda i: i.getHealth() / i.getMaxHealth()))[0]
        eventPlayer.teleport(nearestWalkablePosition(eventPlayer.target.getPosition() - vect(0, 0, -1)))
        eventPlayer.target.setHealth(min(eventPlayer.target.getMaxHealth(), eventPlayer.target.getHealth() + EVT_30_HEAL_FLAT + eventPlayer.getMaxHealth() * EVT_30_HEAL_MAXHP_FACTOR))
        playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.GREEN, eventPlayer.target, 100)
        eventPlayer.eventMissionGoal = getTotalTimeElapsed() + EVT_30_COOLDOWN
        wait(EVT_30_COOLDOWN)
    eventPlayer.altFormTrigger = false
    if eventPlayer.temp:
        smallMessage(eventPlayer, "  {0}  天降神兵已就绪".format(iconString(Icon.CLUB)))

rule "[VishkarEvent]: 天降神兵 (收尾)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 0, eventPlayer.eventId == BuffEventId.DIVINE_REINFORCEMENT]) == true

    wait(eventPlayer.eventDuration)
    eventPlayer.altFormTrigger = false
    eventPlayer.target = null
    eventPlayer.eventMissionGoal = 0
    clearEventEffect()
