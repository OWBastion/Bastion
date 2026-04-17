# Event: MechEventId.CHEAT_CARD_COUNTING
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 作弊：我要验牌 (触发)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_CARD_COUNTING, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    eventPlayer.heart_steel -= EVT_MECH_7_HEART_STEEL_COST
    setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.TEAM_1, eventPlayer, 100)
    eventPlayer.eventForceRoll = EVT_MECH_7_FORCE_ROLL
    smallMessage(eventPlayer, "  {0}  已扣除 {1} 层心之钢（{2}% 最大生命值）".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_MECH_7_HEART_STEEL_COST, EVT_MECH_7_HEART_STEEL_COST * EVT_8_HP_PERCENT_PER_STACK))
    wait(0.2)
    smallMessage(eventPlayer, "  {0}  下一个事件必然是增益，祝你好运".format(iconString(Icon.CLUB)))
    eventPlayer.eventDuration = 0
    if eventPlayer.eventId not in eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)
