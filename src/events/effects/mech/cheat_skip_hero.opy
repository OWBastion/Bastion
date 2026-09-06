#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: MechEventId.CHEAT_SKIP_HERO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 作弊：跳过 (更换英雄)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventType == EventType.MECH
    @Condition eventPlayer.eventId == MechEventId.CHEAT_SKIP_HERO
    @Condition  eventPlayer.getHero() != Hero.BASTION
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.getHero() == heroList[eventPlayer.heroNumber]
    
    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    # 兼容三合一：先缓存当前控制点索引，避免 progressHero() 重置到 0 后丢失进度
    eventPlayer.controlCenterIndex = eventPlayer.controlJumpIndex
    eventPlayer.respawn()
    progressHero()
    wait(0.032)
    if controlRespawnPosition != null:
        if eventPlayer.controlCenterIndex >= len(controlRespawnPosition) or controlRespawnPosition[eventPlayer.controlCenterIndex] == null:
            eventPlayer.controlJumpIndex = 0
        else:
            eventPlayer.controlJumpIndex = eventPlayer.controlCenterIndex
        eventPlayer.teleport(controlRespawnPosition[eventPlayer.controlJumpIndex])
        if controlJumpPosition != null and controlJumpPosition[eventPlayer.controlJumpIndex] != null:
            eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[eventPlayer.controlJumpIndex].getPosition()), Relativity.TO_WORLD)
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
