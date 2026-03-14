# Event: MechEventId.CHEAT_SKIP_HERO
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 作弊：跳过 (更换英雄)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.CHEAT_SKIP_HERO, eventPlayer.isHoldingButton(Button.RELOAD)]) == true
    
    wait(0.5, Wait.ABORT_WHEN_FALSE)
    # todo：传送回重生室
    progressHero()
    if eventPlayer.eventId not in  eventPlayer.dlcTimeChallenge[5] and 43 not in eventPlayer.earnedAchievements:
        eventPlayer.dlcTimeChallenge[5].append(eventPlayer.eventId)
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
