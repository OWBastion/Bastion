#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.GAMBLER_BLACKJACK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 无实体牌：玩家起手 12~16 点，最多追加一次 1~10 点；庄家由系统在结算时一次性给出 12~16 + 1~10 点，对玩家不可见。
# 状态全部放在事件 scratch 槽，clearPlayerEvent 统一清零：
# eventMissionGoal = 筹码（买入时立即从心之钢扣除，兑回或到期收尾时一次性加回）；
# eventMission > 0 = 手牌进行中，值为本手全押的筹码；eventLoopCount = 玩家当前点数（发牌时覆盖抽选残留）；
# altFormActive 输入互斥锁，必须松开按键才能再次触发。死亡不会结束事件；玩家主动重置进度时未兑回的筹码随状态清零。

subroutine blackjackSettle

def blackjackSettle():
    @Name "[VishkarEvent]: 21点 settle"

    if eventPlayer.eventMission <= 0:
        return
    eventPlayer.temp = random.randint(12, 16) + random.randint(1, 10)
    # 玩家爆牌或庄家未爆牌且点数更高 = 输；点数相同 = 平；其余 = 赢
    eventPlayer.eventMissionGoal = eventPlayer.eventMission * (0 if eventPlayer.eventLoopCount > 21 or (eventPlayer.temp <= 21 and eventPlayer.temp > eventPlayer.eventLoopCount) else 1 if eventPlayer.temp == eventPlayer.eventLoopCount else 2)
    smallMessage(eventPlayer, STR_EVT_MECH_29_MSG_RESULT.format(eventPlayer.eventLoopCount, eventPlayer.temp, [STR_EVT_MECH_29_LOSE, STR_EVT_MECH_29_PUSH, STR_EVT_MECH_29_WIN][eventPlayer.eventMissionGoal / eventPlayer.eventMission], eventPlayer.eventMissionGoal))
    eventPlayer.hudText = STR_EVT_MECH_29_AGAIN.format(Button.RELOAD, Button.INTERACT) if eventPlayer.eventMissionGoal > 0 else STR_EVT_MECH_29_BUYIN.format(Button.RELOAD, percent(EVT_MECH_29_POOL_RATIO))
    eventPlayer.eventMission = 0

rule "[VishkarEvent]: 赌徒：21点 (入场提示)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.eventId == EventId.GAMBLER_BLACKJACK

    eventPlayer.altFormActive = true
    eventPlayer.hudText = STR_EVT_MECH_29_BUYIN.format(Button.RELOAD, percent(EVT_MECH_29_POOL_RATIO))
    waitUntil(not (eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.isHoldingButton(Button.INTERACT)) or eventPlayer.eventId != EventId.GAMBLER_BLACKJACK, Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：21点 (买入/发牌/要牌)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.eventId == EventId.GAMBLER_BLACKJACK and eventPlayer.eventEndTime > getTotalTimeElapsed() and not eventPlayer.altFormActive and eventPlayer.isHoldingButton(Button.RELOAD)

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.altFormActive == true:
        return
    eventPlayer.altFormActive = true
    if eventPlayer.eventMission > 0:
        eventPlayer.eventLoopCount += random.randint(1, 10)
        blackjackSettle()
    elif eventPlayer.eventEndTime - getTotalTimeElapsed() > EVT_MECH_29_MIN_DEAL_TIME and (eventPlayer.eventMissionGoal >= 1 or eventPlayer.heart_steel[HeartSteelData.STACKS] >= 1):
        if eventPlayer.eventMissionGoal < 1:
            eventPlayer.temp = max(1, floor(eventPlayer.heart_steel[HeartSteelData.STACKS] * EVT_MECH_29_POOL_RATIO))
            eventPlayer.heart_steel[HeartSteelData.STACKS] -= eventPlayer.temp
            eventPlayer.eventMissionGoal = eventPlayer.temp
            setPlayerHP()
        eventPlayer.eventMission = eventPlayer.eventMissionGoal
        eventPlayer.eventMissionGoal = 0
        eventPlayer.eventLoopCount = random.randint(12, 16)
        eventPlayer.hudText = STR_EVT_MECH_29_HUD_PLAY.format(eventPlayer.eventLoopCount, Button.RELOAD, Button.INTERACT)
        smallMessage(eventPlayer, STR_EVT_MECH_29_MSG_DEAL.format(eventPlayer.eventMission))
    waitUntil(not eventPlayer.isHoldingButton(Button.RELOAD) or eventPlayer.eventId != EventId.GAMBLER_BLACKJACK or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：21点 (停牌/兑回)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.eventId == EventId.GAMBLER_BLACKJACK and eventPlayer.eventEndTime > getTotalTimeElapsed() and eventPlayer.eventMission + eventPlayer.eventMissionGoal > 0 and not eventPlayer.altFormActive and eventPlayer.isHoldingButton(Button.INTERACT)

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.altFormActive == true:
        return
    eventPlayer.altFormActive = true
    if eventPlayer.eventMission > 0:
        blackjackSettle()
    elif eventPlayer.eventMissionGoal > 0:
        eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.eventMissionGoal
        smallMessage(eventPlayer, STR_EVT_MECH_29_MSG_CASHOUT.format(eventPlayer.eventMissionGoal))
        eventPlayer.eventMissionGoal = 0
        eventPlayer.hudText = STR_EVT_MECH_29_BUYIN.format(Button.RELOAD, percent(EVT_MECH_29_POOL_RATIO))
        setPlayerHP()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) or eventPlayer.eventId != EventId.GAMBLER_BLACKJACK or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：21点 (到期收尾)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.eventId == EventId.GAMBLER_BLACKJACK

    waitUntil(eventPlayer.eventId != EventId.GAMBLER_BLACKJACK or eventPlayer.eventEndTime - getTotalTimeElapsed() <= EVT_MECH_29_END_GUARD, Math.INFINITY)
    if eventPlayer.eventId != EventId.GAMBLER_BLACKJACK:
        return
    blackjackSettle()
    eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.eventMissionGoal
    eventPlayer.eventMissionGoal = 0
    setPlayerHP()
