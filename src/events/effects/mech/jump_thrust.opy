#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.JUMP_THRUST
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 屁动力":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.JUMP_THRUST
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isHoldingButton(Button.JUMP)
    
    if eventPlayer.mod_dmg_taken != 0:
        goto lb_1
    eventPlayer.mod_dmg_taken = EVT_MECH_5_DMG_TAKEN
    updatePlayerStats()

    lb_1:
    eventPlayer.applyImpulse(eventPlayer.getFacingDirection(), EVT_MECH_5_IMPULSE, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait()
    if ruleCondition:
        loop()
    eventPlayer.mod_dmg_taken = 0
    updatePlayerStats()

rule "[VishkarEvent]: 屁动力 eff":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.GAMBLER_SHORT_INVESTMENT
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.nanoEffect == null
    
    createEffect(getAllPlayers() if eventPlayer.isHoldingButton(Button.JUMP) else null, Effect.ANA_NANO_BOOSTED, Color.TEAM_2, eventPlayer, 200, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.nanoEffect = getLastCreatedEntity()
    
    wait(eventPlayer.eventDuration)
    
    destroyEffect(eventPlayer.nanoEffect)
    eventPlayer.nanoEffect = null
