#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/先知"

# Event: MechEventId.PROPHET (Unique)
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventConfig 注册与聚合 include。
#
# 显示机制：每名有效玩家在“他人中存在先知”期间，于自己头顶生成一条仅先知可见的
# 世界文本（复用称号的 createInWorldText + WorldTextReeval 思路）。文本内容取自该玩家
# 已承诺的 eventNextIndex —— 事件系统权威预选，预览与实际分配恒等；
# 未承诺（新玩家首掷前 / 被窃贼作废）时显示“未知”，绝不为展示额外掷骰。
# 先知消失（事件结束/离开）后，各被观察者各自的规则负责销毁自己的文本。

# 除自己以外当前持有“先知”事件的玩家集合（Unique 约束下最多一人）
macro Player.prophets():
    getPlayers(Team.1).filter(lambda other: other != self and other.eventType == EventType.MECH and other.eventId == MechEventId.PROPHET)

rule "Reveal committed next event to prophet":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer) == true
    @Condition len(eventPlayer.prophets()) > 0

    if eventPlayer.prophetNextTextID == null:
        createInWorldText(
            eventPlayer.prophets(),
            STR_EVT_MECH_25_NEXT.format(eventName[eventPlayer.eventNextIndex] if eventPlayer.eventNextIndex != null else STR_EVT_MECH_25_UNKNOWN),
            eventPlayer + Vector.UP * 0.4,
            0.7,
            Clip.NONE,
            WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
            rgb(186, 120, 255)
        )
        eventPlayer.prophetNextTextID = getLastCreatedText()
    waitUntil(len(eventPlayer.prophets()) == 0, Math.INFINITY)
    destroyInWorldText(eventPlayer.prophetNextTextID)
    eventPlayer.prophetNextTextID = null
    if ruleCondition:
        loop()
