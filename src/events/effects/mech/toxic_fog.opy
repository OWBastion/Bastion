#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/有点松弛"

# Event: MechEventId.TOXIC_FOG
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 周年返场重做版：原版"移动时沿途生成迷雾"会随位移持续累积效果实体，已退役。
# 现版全程仅一个迷雾实体，位置经 POSITION_AND_RADIUS 重评估跟随持有者，
# 不再产生移动轨迹。雾内其他友方每 TICK_INTERVAL 按各自最大生命值比例受伤；
# 持有者由 exclude 剔除，离开雾区即停止判定。
#
# 清理归属：事件正常结束时 eventEffect 由 clearPlayerEvent 统一回收，本规则
# 只在事件仍生效的中途退出（持有者死亡等）主动销毁；重生后条件重新命中即重建。

rule "Toxic fog aura":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.isAlive(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.TOXIC_FOG]) == true

    if eventPlayer.eventEffect == null:
        createEffect(getPlayers(Team.2), Effect.CLOUD, random.choice([Color.YELLOW, Color.GREEN, Color.ORANGE, Color.LIME_GREEN, Color.VIOLET]), eventPlayer, EVT_MECH_30_FOG_RADIUS, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.eventEffect = getLastCreatedEntity()
    eventPlayer.target = getPlayersInRadius(eventPlayer, EVT_MECH_30_FOG_RADIUS, Team.2, LosCheck.SURFACES).exclude(eventPlayer)
    for eventPlayer.temp in range(len(eventPlayer.target)):
        damage(eventPlayer.target[eventPlayer.temp], eventPlayer, eventPlayer.target[eventPlayer.temp].maxHealthPercent(EVT_MECH_30_DAMAGE_PERCENT_PER_TICK * 100))
    eventPlayer.target = null
    wait(EVT_MECH_30_TICK_INTERVAL)
    if ruleCondition:
        loop()
    if eventPlayer.eventId == MechEventId.TOXIC_FOG:
        clearEventEffect()
