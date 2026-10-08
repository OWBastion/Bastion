#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/循环往复"

# Event: MechEventId.CYCLE_REPLAY (Cheat)
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 变量分工（均由 clearPlayerEvent 统一清零，本事件无需额外清理）：
#   eventMissionGoal — 目标的扁平目录索引（0=未解析哨兵，-1=无合法目标）
#   eventMission     — 执行闩锁（0=未执行，1=已执行；一次事件最多执行一次）
#   hudText          — 展示将循环的增益名，事件结束随 clearPlayerEvent 清空
#
# 循环交付路径：不手写 eventType/eventId，而是把目标的目录索引写入
# eventNextIndex（承诺槽），由下一次 setPlayerEvent 走真实分配路径消费——
# 目录字段落账、类别提交、eventLastId 追加、播报与下一次预取全部与正常抽取一致。
# 不可就地改派：assignPlayerEvent 的 waitUntil 超时在事件开始时绑定本事件时长，
# 直接调用 setPlayerEvent 会让循环增益被旧超时提前 clearPlayerEvent。
#
# 可循环白名单 EVT_MECH_28_REPLAYABLE_BUFFS 准入标准：规则在重新激活时按
# eventId 干净重建——纯临时数值修饰或周期效果，无持久状态污染。排除项及理由：
#   OLIVIA_GIFT         Pack0 特殊彩蛋，无增益语义
#   PHOTON_SHIELD       向全体队友 target 共享暂存字段写入；任一实例收尾清空共享字段，跨实例互坏
#   PHEIDIPPIDES_TRIAL  任务型事件，奖励为永久移速
#   MARTYR_TRIAL        任务型事件（eventMission 复用为击杀者数组），奖励永久减伤
#   TEMPER_HEART        playerOnceEventState 一次性闩锁 + 永久心之钢倍率
#   BATTLEFIELD_MEDIC   任务型事件（治疗量统计），奖励永久治疗强度
#   SHARED_BLESSING     绑定队友 + 任务状态 + 双向心之钢奖励

rule "Resolve replay target":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.CYCLE_REPLAY, eventPlayer.eventMissionGoal == 0]) == true

    # eventMissionGoal==0 兼作初始化标记，防止 clearPlayerEvent 前条件残留导致重复触发。
    # eventLastId 末尾为最近事件；过滤白名单后取尾即“最近一次可循环增益”。
    # 判空必须落在解析值上：filtered.last() 空集返回 null（=0），若改用 len>0 守卫，
    # eventName[null] 会落到索引 0（奥利维娅的礼物），且 missionGoal 残留 null 令本条件恒真反复触发。
    if eventPlayer.eventLastId != null and eventPlayer.eventLastId.filter(lambda i: i < BUFF_EVENT_ID_COUNT and i in EVT_MECH_28_REPLAYABLE_BUFFS).last() != null:
        eventPlayer.eventMissionGoal = eventPlayer.eventLastId.filter(lambda i: i < BUFF_EVENT_ID_COUNT and i in EVT_MECH_28_REPLAYABLE_BUFFS).last()
        eventPlayer.hudText = STR_EVT_MECH_28_TARGET.format(eventName[eventPlayer.eventMissionGoal])
    else:
        eventPlayer.eventMissionGoal = -1
        eventPlayer.hudText = STR_EVT_MECH_28_NO_TARGET

rule "Replay committed buff":
    @Event eachPlayer
    @Team 2
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventType == EventType.MECH, eventPlayer.eventId == MechEventId.CYCLE_REPLAY, eventPlayer.eventMission == 0, eventPlayer.isHoldingButton(Button.RELOAD)]) == true

    wait(EVT_INTERACT_HOLD_TIME, Wait.ABORT_WHEN_FALSE)
    if eventPlayer.eventMissionGoal > 0 and eventPlayer.heart_steel[HeartSteelData.STACKS] >= EVT_MECH_28_STEEL_COST:
        eventPlayer.eventMission = 1
        eventPlayer.heart_steel[HeartSteelData.STACKS] -= EVT_MECH_28_STEEL_COST
        setPlayerHP()
        playEffect(getAllPlayers(), DynamicEffect.BAD_PICKUP_EFFECT, Color.TEAM_2, eventPlayer, 100)
        # 承诺槽改写：已承诺的 eventNextIndex 被循环目标替换，先知预览随承诺同步更新
        eventPlayer.eventNextIndex = eventPlayer.eventMissionGoal
        smallMessage(eventPlayer, "  {0}  已扣除 {1} 层心之钢（{2}% 最大生命值）".format(abilityIconString(Hero.MAUGA, Button.ABILITY_2), EVT_MECH_28_STEEL_COST, EVT_MECH_28_STEEL_COST * eventPlayer.heart_steel[HeartSteelData.PERCENT_PER_STACK]))
        wait(0.2)
        smallMessage(eventPlayer, "  {0}  循环往复：下一个事件将为 {1}".format(iconString(Icon.DIAMOND), eventName[eventPlayer.eventMissionGoal]))
        eventPlayer.eventDuration = 0
        clearPlayerEvent()
    else:
        smallMessage(eventPlayer, "  {0}  没有可循环的增益或心之钢不足 {1} 层".format(iconString(Icon.WARNING), EVT_MECH_28_STEEL_COST))
