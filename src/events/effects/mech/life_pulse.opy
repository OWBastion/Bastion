#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/生命脉冲"

# Event: MechEventId.LIFE_PULSE
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 长按 RELOAD 定身蓄力：每秒消耗自身最大生命值；松开为
# EVT_MECH_29_HEAL_RADIUS 米内其他友方恢复生命，量 = 蓄力秒数 × HEAL_PER_SEC ×
# 施法者最大生命值。蓄力无上限，唯一天然边界是消耗致死（约 10s）；
# 释放后 RELEASE_COOLDOWN 秒内不可再次蓄力。
#
# 变量分工（均由 clearPlayerEvent 统一清零，本事件仅需处理定身/恢复阻断）：
#   eventMission     — 蓄力闩锁（0=可蓄力，1=蓄力中；兼作蓄力球可见性门控）
#   eventMissionGoal — 下次可蓄力时间戳（getTotalTimeElapsed；与 divine_reinforcement 同构）
#   eventTargetHP    — 已蓄力秒数（复用浮点暂存，非 HP 语义）
#   hudText          — 蓄力进度展示
#   target           — 释放瞬间的受疗友方快照
#   eventEffect[0]   — 蓄力球（半径=蓄力秒数×0.5m；clearEventEffect 统一销毁）
#
# 定身选型：Status.ROOTED 语义即“无法移动、可行动”，精确对应“只锁移动”；
# 不占用 mod_speed_event（与 updatePlayerStats 集中管速无冲突），也不像 STUNNED
# 连带封技能。每 tick 续期 2×TICK——正常出口显式 clearStatusEffect 立即解除，
# 任何漏过收尾的中断路径也会在 ≤0.5s 内自然过期兜底。
#
# 消耗语义：按 tick 等比扣血（HP_COST_PER_SEC × TICK），damage() 无下限保护，
# 与 sacrifice / stealth_crouch / adlersbrunn_wraith 的致死语义一致——蓄力过度可致死。
# 治疗量纲：施法者最大生命值（与 divine_reinforcement 的施法者量纲一致），
# 对所有受疗友方等量；自身被 target 快照排除，不受治疗。
#
# 出口审计（详见收尾段与 Teardown rule）：
#   松开按键        → while 退出 → 结算治疗 + 清理（提前松开=部分治疗，不吞蓄力）
#   事件结束        → eventId 检查退出 → 仅清理（Teardown rule 兜底）
#   施法者死亡      → isAlive 检查退出 → 仅清理（蓄力作废，不掉治疗）
#   被眩晕/打断     → 按键读为松开 → 按提前释放结算并清理

#!define LIFE_PULSE_TICK 0.25

rule "Charge marker":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.LIFE_PULSE, eventPlayer.eventEffect == null]) == true

    createEffect(getAllPlayers() if eventPlayer.eventMission == 1 else null, Effect.ORB, Color.YELLOW, eventPlayer, eventPlayer.eventTargetHP * 0.5, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.eventEffect[0] = getLastCreatedEntity()
    waitUntil(eventPlayer.eventId != MechEventId.LIFE_PULSE or eventPlayer.eventType != EventType.MECH, eventPlayer.eventDuration)


rule "Charge and release":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.LIFE_PULSE, eventPlayer.eventMission == 0, eventPlayer.isAlive(), getTotalTimeElapsed() >= eventPlayer.eventMissionGoal, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    eventPlayer.eventMission = 1
    eventPlayer.eventTargetHP = 0
    eventPlayer.passiveRegenBlocked = true
    while all([eventPlayer.isHoldingButton(Button.RELOAD), eventPlayer.isAlive(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.LIFE_PULSE]):
        eventPlayer.setStatusEffect(null, Status.ROOTED, LIFE_PULSE_TICK * 2)
        damage(eventPlayer, null, eventPlayer.maxHealthPercent(EVT_MECH_29_HP_COST_PER_SEC * 100 * LIFE_PULSE_TICK))
        eventPlayer.eventTargetHP += LIFE_PULSE_TICK
        eventPlayer.hudText = STR_EVT_MECH_29_CHARGING.format(round(eventPlayer.eventTargetHP * 10) / 10, round(eventPlayer.eventTargetHP * EVT_MECH_29_HEAL_PER_SEC * 100))
        wait(LIFE_PULSE_TICK)
    # 收尾：所有出口都先解除定身与恢复阻断；仅“存活且事件仍有效”的释放才结算治疗
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.passiveRegenBlocked = false
    if eventPlayer.isAlive() and eventPlayer.eventType == EventType.MECH and eventPlayer.eventId == MechEventId.LIFE_PULSE:
        startCombatRegen()
        if eventPlayer.eventTargetHP > 0:
            eventPlayer.target = [player for player in getLivingPlayers(Team.1) if player != eventPlayer and distance(eventPlayer, player) <= EVT_MECH_29_HEAL_RADIUS]
            if len(eventPlayer.target) > 0:
                heal(eventPlayer.target, eventPlayer, eventPlayer.maxHealthPercent(eventPlayer.eventTargetHP * EVT_MECH_29_HEAL_PER_SEC * 100))
                playEffect(getAllPlayers(), DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, eventPlayer, 200)
                playEffect(getAllPlayers(), DynamicEffect.MOIRA_FADE_REAPPEAR, Color.YELLOW, eventPlayer.target, 200)
            eventPlayer.target = null
    eventPlayer.eventMissionGoal = getTotalTimeElapsed() + EVT_MECH_29_RELEASE_COOLDOWN
    eventPlayer.eventTargetHP = 0
    eventPlayer.hudText = ""
    eventPlayer.eventMission = 0


rule "Teardown":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.LIFE_PULSE]) == true

    wait(eventPlayer.eventDuration)
    eventPlayer.clearStatusEffect(Status.ROOTED)
    eventPlayer.passiveRegenBlocked = false
    eventPlayer.eventMission = 0
    eventPlayer.eventTargetHP = 0
    eventPlayer.hudText = ""
    eventPlayer.target = null
