#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/先知"

# Event: MechEventId.PROPHET (Unique)
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 观测者效应：被先知观测的玩家若尚无已承诺的下一个事件（eventNextIndex == null），
# 立即按当前旗标实掷一次使其坍缩——预览即实发，两者恒等；已承诺的绝不重掷。
#
# 显示机制：每名玩家常驻一条仅先知可见的世界文本（创建一次、永不销毁），
# 可见性由 WorldTextReeval 每帧重估 prophets() 列表驱动——先知消失时列表为空、
# 文本自动隐形，先知再次出现时自动复现，重复触发不产生任何创建/销毁开销。
# 锚点与称号一致（eventPlayer 实体锚点）：已有称号的玩家的文本以 \n 起行，
# 箭头行渲染在称号正下方；没有称号的玩家直接占用称号槽位展示。
# 内容经 eventName[eventNextIndex] 按 ID 查询得出；颜色沿用称号色，无称号时使用默认紫。
# 称号状态（playerTitleAndColor / playerTitles）与称号文本句柄（titleTextID）
# 一律不读写，不影响称号、赌徒等任何其他系统的判定。

# 除自己以外当前持有“先知”事件的玩家集合（Unique 约束下最多一人）
# eventId 仅存枚举值，mech/debuff 编号可撞号，必须带 eventType 过滤
macro Player.prophets():
    getPlayers(Team.1).filter(lambda other: other != self and other.eventType == EventType.MECH and other.eventId == MechEventId.PROPHET)

rule "Collapse undecided next event under observation":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer) == true
    @Condition len(eventPlayer.prophets()) > 0
    @Condition eventPlayer.eventNextIndex == null

    rerollNextEvent()

rule "Reveal committed next event to prophet":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer) == true
    @Condition eventPlayer.prophetNextTextID == null

    createInWorldText(
        eventPlayer.prophets(),
        "{0}{1}".format(
            "\n" if eventPlayer.playerTitleAndColor != null else "",
            STR_EVT_MECH_25_NEXT.format(eventName[eventPlayer.eventNextIndex] if eventPlayer.eventNextIndex != null else STR_EVT_MECH_25_UNKNOWN)
        ),
        eventPlayer,
        0.7,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(eventPlayer.rgb_vect.x, eventPlayer.rgb_vect.y, eventPlayer.rgb_vect.z) if eventPlayer.playerTitleAndColor != null else rgb(186, 120, 255)
    )
    eventPlayer.prophetNextTextID = getLastCreatedText()
