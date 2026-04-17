# Event: MechEventId.CHEAT_SKIP_HERO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 作弊：跳过 (更换英雄)":
    @Event eachPlayer
    @Team 1
    @Condition  eventPlayer.getHero() != Hero.BASTION
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_SKIP_HERO, eventPlayer.isHoldingButton(Button.RELOAD), eventPlayer.getHero() == heroList[eventPlayer.heroNumber]]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
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
    if eventPlayer.eventId not in  eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
