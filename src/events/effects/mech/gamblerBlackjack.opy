#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.GAMBLER_BLACKJACK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 无实体牌：玩家起手 12~16 点，最多追加一次 1~10 点；庄家起手 12~16 点对玩家可见，结算时才给出 1~10 点的暗牌。
# 状态全部放在事件 scratch 槽，clearPlayerEvent 统一清零：
# eventMissionGoal = 筹码（买入时立即从心之钢扣除，兑回或到期收尾时一次性加回）；
# 输掉的筹码进入全局心之钢奖池 gamblerHeartsteelJackpot；赢得 EVT_MECH_29_WIN_MULTIPLIER 倍筹码，平局返还本金；
# eventMission > 0 = 手牌进行中，值为本手全押的筹码；eventLoopCount = [玩家起手点数, 玩家追加点数(0=未要牌), 庄家起手点数, 庄家暗牌, 玩家总点, 庄家总点, 结果码, 结算筹码]（发牌时整体覆盖）；
# 事件 HUD 由文件末尾的全局 rule 按这些槽位渲染，不写 hudText 变量（按键图标是本地值，不能存进变量）；
# altFormActive 输入互斥锁，必须松开按键才能再次触发。死亡不会结束事件；玩家主动重置进度时未兑回的筹码随状态清零。

subroutine blackjackSettle

def blackjackSettle():
    @Name "[VishkarEvent]: 21点 settle"

    if eventPlayer.eventMission <= 0:
        return
    # 庄家暗牌存入槽 3；点数 = 起手 + 追加/暗牌。每步一条扁平语句，避免深嵌套表达式
    eventPlayer.eventLoopCount[3] = random.randint(1, 10)
    eventPlayer.eventLoopCount[4] = eventPlayer.eventLoopCount[0] + eventPlayer.eventLoopCount[1]
    eventPlayer.eventLoopCount[5] = eventPlayer.eventLoopCount[2] + eventPlayer.eventLoopCount[3]
    # 玩家爆牌或庄家未爆牌且点数更高 = 输；点数相同 = 平；其余 = 赢。结果码存槽 6：0 输 / 1 平 / 2 赢
    if eventPlayer.eventLoopCount[4] > 21:
        eventPlayer.eventLoopCount[6] = 0
    elif eventPlayer.eventLoopCount[5] <= 21 and eventPlayer.eventLoopCount[5] > eventPlayer.eventLoopCount[4]:
        eventPlayer.eventLoopCount[6] = 0
    elif eventPlayer.eventLoopCount[5] == eventPlayer.eventLoopCount[4]:
        eventPlayer.eventLoopCount[6] = 1
    else:
        eventPlayer.eventLoopCount[6] = 2
    # 结算筹码：输 0、平 1 倍、赢 EVT_MECH_29_WIN_MULTIPLIER 倍；输掉的筹码进入全局心之钢奖池
    if eventPlayer.eventLoopCount[6] == 2:
        eventPlayer.eventLoopCount[7] = eventPlayer.eventMission * EVT_MECH_29_WIN_MULTIPLIER
    elif eventPlayer.eventLoopCount[6] == 1:
        eventPlayer.eventLoopCount[7] = eventPlayer.eventMission
    else:
        eventPlayer.eventLoopCount[7] = 0
        gamblerHeartsteelJackpot += eventPlayer.eventMission
    eventPlayer.eventMissionGoal = eventPlayer.eventLoopCount[7]
    # 消息只读结果槽，不读 eventMission：下一行把它清零，消息若在其后才求值会把输/爆牌显示成平局
    smallMessage(eventPlayer, STR_EVT_MECH_29_MSG_RESULT.format(eventPlayer.eventLoopCount[0], eventPlayer.eventLoopCount[1] if eventPlayer.eventLoopCount[1] > 0 else "-", eventPlayer.eventLoopCount[2], eventPlayer.eventLoopCount[3], STR_EVT_MECH_29_WIN if eventPlayer.eventLoopCount[6] == 2 else STR_EVT_MECH_29_PUSH if eventPlayer.eventLoopCount[6] == 1 else STR_EVT_MECH_29_LOSE, eventPlayer.eventLoopCount[7]))
    eventPlayer.eventMission = 0

rule "[VishkarEvent]: 赌徒：21点 (入场提示)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() and eventPlayer.eventId == EventId.GAMBLER_BLACKJACK

    eventPlayer.altFormActive = true
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
        eventPlayer.eventLoopCount[1] = random.randint(1, 10)
        blackjackSettle()
    elif eventPlayer.eventEndTime - getTotalTimeElapsed() > EVT_MECH_29_MIN_DEAL_TIME and (eventPlayer.eventMissionGoal >= 1 or eventPlayer.heart_steel[HeartSteelData.STACKS] >= 1):
        if eventPlayer.eventMissionGoal < 1:
            eventPlayer.temp = max(1, floor(eventPlayer.heart_steel[HeartSteelData.STACKS] * EVT_MECH_29_POOL_RATIO))
            eventPlayer.heart_steel[HeartSteelData.STACKS] -= eventPlayer.temp
            eventPlayer.eventMissionGoal = eventPlayer.temp
            setPlayerHP()
        eventPlayer.eventMission = eventPlayer.eventMissionGoal
        eventPlayer.eventMissionGoal = 0
        eventPlayer.eventLoopCount = [random.randint(12, 16), 0, random.randint(12, 16), 0, 0, 0, 0, 0]
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
        # 兑回提示也读取结算结果槽，避免 eventMissionGoal 清零后显示 0。
        smallMessage(eventPlayer, STR_EVT_MECH_29_MSG_CASHOUT.format(eventPlayer.eventLoopCount[7]))
        eventPlayer.eventMissionGoal = 0
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

# 事件 HUD：全局创建一次，按本地玩家的事件状态渲染；按键图标（本地值）只能直接写在 HUD 字符串里
rule "[VishkarEvent]: 赌徒：21点 (HUD)":
    hudHeader(
        localPlayer if localPlayer.eventId == EventId.GAMBLER_BLACKJACK and localPlayer.settlementCardEnd == null else null,
        STR_EVT_MECH_29_HUD_PLAY.format(localPlayer.eventLoopCount[0], localPlayer.eventLoopCount[2], localPlayer.eventMission, inputBindingString(Button.RELOAD), inputBindingString(Button.INTERACT)) if localPlayer.eventMission > 0 else STR_EVT_MECH_29_HUD_AGAIN.format(localPlayer.eventMissionGoal, inputBindingString(Button.RELOAD), inputBindingString(Button.INTERACT)) if localPlayer.eventMissionGoal > 0 else STR_EVT_MECH_29_BUYIN.format(inputBindingString(Button.RELOAD), percent(EVT_MECH_29_POOL_RATIO)),
        HudPosition.TOP, 21, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
    )
