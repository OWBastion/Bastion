#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.GAMBLER_BLACKJACK
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 筹码 = 事件内临时状态，存放在 eventMissionGoal。买入时立即从真实心之钢扣除（当前层数 × POOL_RATIO），
# 兑回（INTERACT）或事件到期前（"到期收尾" 规则）一次性加回；每手全押：开局即把筹码移入 eventMission（押注），
# 结算时赢得 2 倍、平局原数、输掉清零写回筹码。死亡不会结束事件，筹码与手牌保留到事件结束；只有玩家主动重置进度（clearPlayerEvent 兜底清零）才会丢失筹码，不退款也不重复支付。
# eventMission > 0 = 玩家回合进行中（值为本手押注）；庄家由系统在 blackjackSettle 内即时抽牌，无等待，结算是原子的；
# eventTempIndex 按 BlackjackHand 槽位记录双方点数与展示文本（eventLoopCount / eventTempIndex 带有抽选残留，故发牌时才初始化）；
# altFormActive 输入互斥锁，必须松开按键才能再次触发。抽牌源为独立随机牌（无限牌靴），不记录牌靴状态，也不修改奖池。
# 玩家每手最多要牌一次，要牌后自动停牌结算。

enum BlackjackHand:
    PLAYER_HARD = 0
    PLAYER_ACES
    PLAYER_TEXT
    DEALER_HARD
    DEALER_ACES
    DEALER_TEXT
    DEALER_UP_TEXT
    CARD
    RESULT
    RESULT_TEXT
    PLAYER_TOTAL
    DEALER_TOTAL

enum BlackjackResult:
    LOSS = 0
    BUST
    WIN
    PUSH

macro blackjackTotal(hard, aces): (hard + 10) if aces > 0 and hard + 10 <= 21 else hard
macro blackjackLabel(rank): ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"][rank - 1]
macro Player.blackjackPlayerTotal(): self.eventTempIndex[BlackjackHand.PLAYER_TOTAL]
macro Player.blackjackDealerTotal(): self.eventTempIndex[BlackjackHand.DEALER_TOTAL]
macro Player.blackjackBuyIn(): min(self.heart_steel[HeartSteelData.STACKS], max(1, floor(self.heart_steel[HeartSteelData.STACKS] * EVT_MECH_29_POOL_RATIO)))

subroutine blackjackDrawPlayer
subroutine blackjackDrawDealer
subroutine blackjackUpdateHud
subroutine blackjackDeal
subroutine blackjackBank
subroutine blackjackSettle

def blackjackDrawPlayer():
    @Name "[VishkarEvent]: 21点 player draw"

    eventPlayer.eventTempIndex[BlackjackHand.CARD] = random.randint(1, 13)
    eventPlayer.eventTempIndex[BlackjackHand.PLAYER_HARD] += min(eventPlayer.eventTempIndex[BlackjackHand.CARD], 10)
    if eventPlayer.eventTempIndex[BlackjackHand.CARD] == 1:
        eventPlayer.eventTempIndex[BlackjackHand.PLAYER_ACES] += 1
    eventPlayer.eventTempIndex[BlackjackHand.PLAYER_TEXT] = "{0} {1}".format(eventPlayer.eventTempIndex[BlackjackHand.PLAYER_TEXT], blackjackLabel(eventPlayer.eventTempIndex[BlackjackHand.CARD]))
    eventPlayer.eventTempIndex[BlackjackHand.PLAYER_TOTAL] = blackjackTotal(eventPlayer.eventTempIndex[BlackjackHand.PLAYER_HARD], eventPlayer.eventTempIndex[BlackjackHand.PLAYER_ACES])

def blackjackDrawDealer():
    @Name "[VishkarEvent]: 21点 dealer draw"

    eventPlayer.eventTempIndex[BlackjackHand.CARD] = random.randint(1, 13)
    eventPlayer.eventTempIndex[BlackjackHand.DEALER_HARD] += min(eventPlayer.eventTempIndex[BlackjackHand.CARD], 10)
    if eventPlayer.eventTempIndex[BlackjackHand.CARD] == 1:
        eventPlayer.eventTempIndex[BlackjackHand.DEALER_ACES] += 1
    eventPlayer.eventTempIndex[BlackjackHand.DEALER_TEXT] = "{0} {1}".format(eventPlayer.eventTempIndex[BlackjackHand.DEALER_TEXT], blackjackLabel(eventPlayer.eventTempIndex[BlackjackHand.CARD]))
    eventPlayer.eventTempIndex[BlackjackHand.DEALER_TOTAL] = blackjackTotal(eventPlayer.eventTempIndex[BlackjackHand.DEALER_HARD], eventPlayer.eventTempIndex[BlackjackHand.DEALER_ACES])

def blackjackUpdateHud():
    @Name "[VishkarEvent]: 21点 update hud"

    if eventPlayer.eventMission > 0:
        eventPlayer.hudText = STR_EVT_MECH_29_HUD_PLAY.format(eventPlayer.eventMission, eventPlayer.eventTempIndex[BlackjackHand.PLAYER_TEXT], eventPlayer.blackjackPlayerTotal(), eventPlayer.eventTempIndex[BlackjackHand.DEALER_UP_TEXT], inputBindingString(Button.RELOAD), inputBindingString(Button.INTERACT))
    else:
        eventPlayer.hudText = STR_EVT_MECH_29_HUD_IDLE.format(inputBindingString(Button.RELOAD), eventPlayer.blackjackBuyIn())

def blackjackDeal():
    @Name "[VishkarEvent]: 21点 deal"

    if eventPlayer.eventMissionGoal < 1:
        eventPlayer.temp = eventPlayer.blackjackBuyIn()
        if eventPlayer.temp < 1:
            smallMessage(eventPlayer, "  {0}  {1}".format(iconString(Icon.DIAMOND), STR_EVT_MECH_29_BROKE))
            return
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= eventPlayer.temp
        eventPlayer.eventMissionGoal = eventPlayer.temp
        setPlayerHP()
    eventPlayer.eventMission = eventPlayer.eventMissionGoal
    eventPlayer.eventMissionGoal = 0
    eventPlayer.eventTempIndex = [0, 0, "", 0, 0, "", "", 0, 0, "", 0, 0]
    blackjackDrawPlayer()
    blackjackDrawPlayer()
    blackjackDrawDealer()
    eventPlayer.eventTempIndex[BlackjackHand.DEALER_UP_TEXT] = eventPlayer.eventTempIndex[BlackjackHand.DEALER_TEXT]
    blackjackDrawDealer()
    blackjackUpdateHud()

def blackjackBank():
    @Name "[VishkarEvent]: 21点 bank"

    smallMessage(eventPlayer, "  {0}  {1}".format(iconString(Icon.CLUB), STR_EVT_MECH_29_BANK.format(eventPlayer.eventMissionGoal)))
    eventPlayer.heart_steel[HeartSteelData.STACKS] += eventPlayer.eventMissionGoal
    eventPlayer.eventMissionGoal = 0
    blackjackUpdateHud()
    setPlayerHP()

def blackjackSettle():
    @Name "[VishkarEvent]: 21点 settle"

    if eventPlayer.eventMission <= 0:
        return
    # 庄家由系统即时抽牌：16 点及以下继续抽，17 点及以上停牌（含软 17）；10 次远大于任何可能的抽牌数
    if eventPlayer.blackjackPlayerTotal() <= 21:
        for eventPlayer.temp in range(10):
            if eventPlayer.blackjackDealerTotal() < 17:
                blackjackDrawDealer()
    if eventPlayer.blackjackPlayerTotal() > 21:
        eventPlayer.eventTempIndex[BlackjackHand.RESULT] = BlackjackResult.BUST
    elif eventPlayer.blackjackDealerTotal() > 21 or eventPlayer.blackjackPlayerTotal() > eventPlayer.blackjackDealerTotal():
        eventPlayer.eventTempIndex[BlackjackHand.RESULT] = BlackjackResult.WIN
    elif eventPlayer.blackjackPlayerTotal() == eventPlayer.blackjackDealerTotal():
        eventPlayer.eventTempIndex[BlackjackHand.RESULT] = BlackjackResult.PUSH
    else:
        eventPlayer.eventTempIndex[BlackjackHand.RESULT] = BlackjackResult.LOSS

    if eventPlayer.eventTempIndex[BlackjackHand.RESULT] == BlackjackResult.WIN:
        eventPlayer.eventMissionGoal = eventPlayer.eventMission * 2
        eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT] = STR_EVT_MECH_29_WIN.format(eventPlayer.eventMission)
    elif eventPlayer.eventTempIndex[BlackjackHand.RESULT] == BlackjackResult.PUSH:
        eventPlayer.eventMissionGoal = eventPlayer.eventMission
        eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT] = STR_EVT_MECH_29_PUSH
    elif eventPlayer.eventTempIndex[BlackjackHand.RESULT] == BlackjackResult.BUST:
        eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT] = STR_EVT_MECH_29_BUST.format(eventPlayer.eventMission)
    else:
        eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT] = STR_EVT_MECH_29_LOSE.format(eventPlayer.eventMission)
    eventPlayer.eventMission = 0
    if eventPlayer.eventMissionGoal > 0:
        eventPlayer.hudText = STR_EVT_MECH_29_HUD_REST.format(eventPlayer.eventTempIndex[BlackjackHand.PLAYER_TEXT], eventPlayer.blackjackPlayerTotal(), eventPlayer.eventTempIndex[BlackjackHand.DEALER_TEXT], eventPlayer.blackjackDealerTotal(), eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT], eventPlayer.eventMissionGoal, inputBindingString(Button.RELOAD), inputBindingString(Button.INTERACT))
    else:
        eventPlayer.hudText = STR_EVT_MECH_29_HUD_BROKE.format(eventPlayer.eventTempIndex[BlackjackHand.PLAYER_TEXT], eventPlayer.blackjackPlayerTotal(), eventPlayer.eventTempIndex[BlackjackHand.DEALER_TEXT], eventPlayer.blackjackDealerTotal(), eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT], inputBindingString(Button.RELOAD), eventPlayer.blackjackBuyIn())
    smallMessage(eventPlayer, "  {0}  {1}".format(iconString(Icon.CLUB if eventPlayer.eventMissionGoal > 0 else Icon.DIAMOND), eventPlayer.eventTempIndex[BlackjackHand.RESULT_TEXT]))
    playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND if eventPlayer.eventMissionGoal > 0 else DynamicEffect.DEBUFF_IMPACT_SOUND, Team.2, eventPlayer, 200)

rule "[VishkarEvent]: 赌徒：21点 (入场提示)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GAMBLER_BLACKJACK]) == true

    eventPlayer.altFormActive = true
    blackjackUpdateHud()
    waitUntil(any([all([eventPlayer.isHoldingButton(Button.RELOAD) == false, eventPlayer.isHoldingButton(Button.INTERACT) == false]), eventPlayer.eventId != EventId.GAMBLER_BLACKJACK]), Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：21点 (买入/发牌/要牌)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GAMBLER_BLACKJACK, eventPlayer.eventEndTime > getTotalTimeElapsed(), eventPlayer.altFormActive != true, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.altFormActive == true:
        return
    eventPlayer.altFormActive = true
    if eventPlayer.eventMission > 0:
        blackjackDrawPlayer()
        blackjackSettle()
    elif eventPlayer.eventEndTime - getTotalTimeElapsed() > EVT_MECH_29_MIN_DEAL_TIME:
        blackjackDeal()
    waitUntil(any([eventPlayer.isHoldingButton(Button.RELOAD) == false, eventPlayer.eventId != EventId.GAMBLER_BLACKJACK, eventPlayer.eventEndTime <= getTotalTimeElapsed()]), Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：21点 (停牌/兑回)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GAMBLER_BLACKJACK, eventPlayer.eventEndTime > getTotalTimeElapsed(), any([eventPlayer.eventMission > 0, eventPlayer.eventMissionGoal > 0]), eventPlayer.altFormActive != true, eventPlayer.isHoldingButton(Button.INTERACT)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.altFormActive == true:
        return
    eventPlayer.altFormActive = true
    if eventPlayer.eventMission > 0:
        blackjackSettle()
    elif eventPlayer.eventMissionGoal > 0:
        blackjackBank()
    waitUntil(any([eventPlayer.isHoldingButton(Button.INTERACT) == false, eventPlayer.eventId != EventId.GAMBLER_BLACKJACK, eventPlayer.eventEndTime <= getTotalTimeElapsed()]), Math.INFINITY)
    eventPlayer.altFormActive = false

rule "[VishkarEvent]: 赌徒：21点 (到期收尾)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.GAMBLER_BLACKJACK]) == true

    waitUntil(eventPlayer.eventId != EventId.GAMBLER_BLACKJACK or eventPlayer.eventEndTime - getTotalTimeElapsed() <= EVT_MECH_29_END_GUARD, Math.INFINITY)
    if eventPlayer.eventId != EventId.GAMBLER_BLACKJACK:
        return
    blackjackSettle()
    if eventPlayer.eventMissionGoal > 0:
        blackjackBank()
