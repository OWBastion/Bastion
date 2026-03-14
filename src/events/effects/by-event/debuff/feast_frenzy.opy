# Event: DebuffEventId.FEAST_FRENZY
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。

rule "[VishkarEvent]: 狂欢盛宴":
    @Event playerDied
    @Team 1
    @Condition all([dlcVishkarEvent, eventPlayer.hasSpawned(), eventPlayer.eventType == 1, eventPlayer.eventId == DebuffEventId.FEAST_FRENZY, attacker.getHero() == Hero.BASTION]) == true
    
    bigMessage(getAllPlayers(), "盛宴！")
    smallMessage(getPlayers(Team.1), "  {0} {1} 阵亡触发了狂欢盛宴".format(iconString(Icon.WARNING), eventPlayer))
    getPlayers(Team.2).hasNano = true
    berserkerTime += EVT_DEBUFF_11_BERSERK_ADD
    wait(EVT_DEBUFF_11_COOLDOWN)

rule "[VishkarEvent]: 狂欢盛宴计时器":
    @Condition berserkerTime != 0
    
    wait(2)
    berserkerTime -= 2
    if ruleCondition:
        loop()
    getPlayers(Team.2).hasNano = false
    eventId = -1
