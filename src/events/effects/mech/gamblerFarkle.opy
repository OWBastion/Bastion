#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.GAMBLER_FARKLE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 状态全部放在事件 scratch 槽，clearPlayerEvent 统一清零：
# eventMission 本手未存档分数；eventMissionGoal 本手已保留的计分骰数量；altFormActive 输入互斥锁，必须松开按键才能再次触发。
# 无入场押注，没有真实心之钢损失，因此不涉及奖池。心之钢只在 farkleBank 中一次性发放；
# 事件到期、死亡重置、离开时未存档分数随状态清零作废，不自动存档。

macro farkleScore(dice): len(dice.filter(lambda die: die == 1)) * EVT_MECH_30_ONE_POINTS + len(dice.filter(lambda die: die == 5)) * EVT_MECH_30_FIVE_POINTS
macro farkleScoringCount(dice): len(dice.filter(lambda die: die == 1 or die == 5))
macro farkleDiceText(dice): "{0}{1}{2}".format(dice[0], "  {0}".format(dice[1]) if len(dice) > 1 else "", "  {0}".format(dice[2]) if len(dice) > 2 else "")

subroutine farkleBank

def farkleBank():
    @Name "[VishkarEvent]: 亡命骰局 bank"

    if eventPlayer.eventMission <= 0:
        return
    eventPlayer.temp = eventPlayer.eventMission / EVT_MECH_30_POINTS_PER_STACK * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
    eventPlayer.eventMission = 0
    eventPlayer.eventMissionGoal = 0
    eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.temp
    eventPlayer.hudText = STR_EVT_MECH_30_HUD_BANK.format(STR_EVT_MECH_30_BANK.format(eventPlayer.temp), inputBindingString(Button.RELOAD))
    smallMessage(eventPlayer, "  {0}  {1}".format(iconString(Icon.CLUB), STR_EVT_MECH_30_BANK.format(eventPlayer.temp)))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, Team.2, eventPlayer, 200)
    setPlayerHP()

rule "[VishkarEvent]: 赌徒：亡命骰局 (掷骰)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GAMBLER_FARKLE, eventPlayer.eventEndTime > getTotalTimeElapsed(), eventPlayer.altFormActive != true, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.altFormActive == true:
        return
    eventPlayer.altFormActive = true
    eventPlayer.temp = [random.randint(1, 6), random.randint(1, 6), random.randint(1, 6)].slice(0, EVT_MECH_30_DICE - eventPlayer.eventMissionGoal)
    if farkleScore(eventPlayer.temp) == 0:
        eventPlayer.hudText = STR_EVT_MECH_30_HUD_BUST.format(farkleDiceText(eventPlayer.temp), STR_EVT_MECH_30_BUST.format(eventPlayer.eventMission), inputBindingString(Button.RELOAD))
        smallMessage(eventPlayer, "  {0}  {1}".format(iconString(Icon.DIAMOND), STR_EVT_MECH_30_BUST.format(eventPlayer.eventMission)))
        playEffect(eventPlayer, DynamicEffect.DEBUFF_IMPACT_SOUND, Team.2, eventPlayer, 200)
        eventPlayer.eventMission = 0
        eventPlayer.eventMissionGoal = 0
    else:
        eventPlayer.eventMission += farkleScore(eventPlayer.temp)
        eventPlayer.eventMissionGoal += farkleScoringCount(eventPlayer.temp)
        eventPlayer.hudText = STR_EVT_MECH_30_HUD_ROLL.format(farkleDiceText(eventPlayer.temp), eventPlayer.eventMission, eventPlayer.eventMission / EVT_MECH_30_POINTS_PER_STACK, eventPlayer.eventMissionGoal, EVT_MECH_30_DICE - eventPlayer.eventMissionGoal, inputBindingString(Button.RELOAD), inputBindingString(Button.INTERACT))
        if eventPlayer.eventMissionGoal >= EVT_MECH_30_DICE:
            eventPlayer.eventMissionGoal = 0
        if eventPlayer.eventMission >= EVT_MECH_30_MAX_UNBANKED:
            farkleBank()
    wait(EVT_MECH_30_ROLL_INTERVAL)
    waitUntil(any([eventPlayer.isHoldingButton(Button.RELOAD) == false, eventPlayer.eventId != EventId.GAMBLER_FARKLE, eventPlayer.eventEndTime <= getTotalTimeElapsed()]), Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：亡命骰局 (存档)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GAMBLER_FARKLE, eventPlayer.eventEndTime > getTotalTimeElapsed(), eventPlayer.eventMission > 0, eventPlayer.altFormActive != true, eventPlayer.isHoldingButton(Button.INTERACT)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.altFormActive == true:
        return
    eventPlayer.altFormActive = true
    farkleBank()
    waitUntil(any([eventPlayer.isHoldingButton(Button.INTERACT) == false, eventPlayer.eventId != EventId.GAMBLER_FARKLE, eventPlayer.eventEndTime <= getTotalTimeElapsed()]), Math.INFINITY)
    eventPlayer.altFormActive = false
