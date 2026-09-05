#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.CHEAT_BACKROOM_DEAL
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 作弊：暗箱操作 (触发)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.CHEAT_BACKROOM_DEAL
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_MECH_22_HEART_STEEL_COST
    setPlayerHP()
    playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.TEAM_1, eventPlayer, 100)
    eventPlayer.eventForceRoll = EVT_MECH_22_FORCE_ROLL
    smallMessage(eventPlayer, "  {0}  已扣除 {1} 层心之钢（{2}% 最大生命值）".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_MECH_22_HEART_STEEL_COST, EVT_MECH_22_HEART_STEEL_COST * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
    wait(0.2)
    smallMessage(eventPlayer, "  {0}  下一个事件必然是机制，祝你好运".format(iconString(Icon.DIAMOND)))
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
