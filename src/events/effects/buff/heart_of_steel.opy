#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: BuffEventId.HEART_OF_STEEL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 心之钢 Effect":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.HEART_OF_STEEL]) == true
    
    wait()
    if eventPlayer.eventEffect != null:
        goto lbl_0
    createEffect(getAllPlayers(), Effect.WINSTON_PRIMAL_RAGE, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.eventEffect = getLastCreatedEntity()
    lbl_0:
    # Exception: one-shot effect owner, ends strictly on event lifecycle.
    waitUntil(eventPlayer.eventId == -1, eventPlayer.eventDuration)

rule "[VishkarEvent]: 心之钢":
    @Event playerDied
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.BUFF, eventPlayer.eventId == BuffEventId.HEART_OF_STEEL]) == true
    @Condition (attacker.getHero() == Hero.BASTION or eventPlayer.isWinner) == true
    
    eventPlayer.heart_steel[HeartSteelData.STACKS] += EVT_8_HP_LAYER_PER_DEATH * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER]
    smallMessage(eventPlayer, "  {0}  已获得 {1} 层（{2}%）心之钢".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_8_HP_LAYER_PER_DEATH * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER], EVT_8_HP_LAYER_PER_DEATH * eventPlayer.heart_steel[HeartSteelData.GAIN_MULTIPLIER] * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
    wait(0.032)
    waitUntil(eventPlayer.isAlive(), 0.5)
    setPlayerHP()
    wait(0.032)
