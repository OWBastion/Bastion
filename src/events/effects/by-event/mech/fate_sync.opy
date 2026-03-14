# Event: MechEventId.FATE_SYNC
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 命运共同体 (概率同步)":
    @Event eachPlayer
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 2, eventPlayer.eventId == MechEventId.FATE_SYNC]) == true
    
    eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player != eventPlayer and player.eventId == -1]
    if len(eventPlayer.target) > 0:
        eventPlayer.eventForceRoll = random.randint(0, 80)
        eventPlayer.target.eventForceRoll = eventPlayer.eventForceRoll
        smallMessage(getAllPlayers(), "  {0}  {1} 与 {2} 命运相连！下一次事件类别相同".format(abilityIconString(Hero.MAUGA, Button.ULTIMATE), eventPlayer, eventPlayer.target, eventPlayer.eventName))
    wait(0.032) 
    eventPlayer.eventDuration = 0
    clearPlayerEvent()
