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
# 显示机制（栏位驱动）：为 Team.1 的 8 个玩家栏位各创建一条世界文本，单局恒定
# 8 次 createInWorldText，与具体玩家解耦——任何数量玩家进出都只影响 reeval 结果，
# 不产生新的创建/销毁。每条文本的玩家数据全部经 WorldTextReeval 实时重估：
#   - 位置：当前栏位玩家实体（换人自动跟随）
#   - 可见性：先知集合减去栏位玩家本人（先知看不到自己的下一个事件）
#   - 内容：栏位玩家已有称号时以 \n 起行使箭头行渲染在称号正下方，无称号时
#     直接占用称号槽位；事件名经 eventName[eventNextIndex] 按 ID 查询
#   - 颜色：沿用栏位玩家称号色，无称号时使用默认紫
# 称号状态（playerTitleAndColor / playerTitles）与称号文本句柄（titleTextID）
# 一律不读写，不影响称号、赌徒等任何其他系统的判定。

# 除栏位玩家本人以外当前持有“先知”事件的玩家集合（Unique 约束下最多一人）
# eventId 仅存枚举值，mech/debuff 编号可撞号，必须带 eventType 过滤
macro Player.prophets():
    getPlayers(Team.1).filter(lambda other: other != self and other.eventType == EventType.MECH and other.eventId == MechEventId.PROPHET)

# 栏位玩家查询：getPlayers 只含在线玩家，需按 getSlot 过滤定位栏位
#!define PROPHET_SLOT_PLAYER(i) (getPlayers(Team.1).filter(lambda p: p.getSlot() == i)[0] if len(getPlayers(Team.1).filter(lambda p: p.getSlot() == i)) > 0 else null)
#!define PROPHET_SLOT_WATCHERS(i) (PROPHET_SLOT_PLAYER(i).prophets() if PROPHET_SLOT_PLAYER(i) != null else [])
#!define PROPHET_SLOT_STRING(i) "{0}{1}".format("\n" if PROPHET_SLOT_PLAYER(i) != null and PROPHET_SLOT_PLAYER(i).playerTitleAndColor != null else "", STR_EVT_MECH_25_NEXT.format(eventName[PROPHET_SLOT_PLAYER(i).eventNextIndex] if PROPHET_SLOT_PLAYER(i) != null and PROPHET_SLOT_PLAYER(i).eventNextIndex != null else STR_EVT_MECH_25_UNKNOWN))
#!define PROPHET_SLOT_COLOR(i) (rgb(PROPHET_SLOT_PLAYER(i).rgb_vect.x, PROPHET_SLOT_PLAYER(i).rgb_vect.y, PROPHET_SLOT_PLAYER(i).rgb_vect.z) if PROPHET_SLOT_PLAYER(i) != null and PROPHET_SLOT_PLAYER(i).playerTitleAndColor != null else rgb(186, 120, 255))
#!define PROPHET_SLOT_TEXT(i) createInWorldText(PROPHET_SLOT_WATCHERS(i), PROPHET_SLOT_STRING(i), PROPHET_SLOT_PLAYER(i), 0.7, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, PROPHET_SLOT_COLOR(i))

rule "Collapse undecided next event under observation":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer) == true
    @Condition len(eventPlayer.prophets()) > 0
    @Condition eventPlayer.eventNextIndex == null

    rerollNextEvent()

rule "Create per-slot prophet next-event texts":
    @Event global
    @Condition prophetSlotTextsCreated == false
    @Condition len(getPlayers(Team.1)) > 0

    PROPHET_SLOT_TEXT(0)
    PROPHET_SLOT_TEXT(1)
    PROPHET_SLOT_TEXT(2)
    PROPHET_SLOT_TEXT(3)
    PROPHET_SLOT_TEXT(4)
    PROPHET_SLOT_TEXT(5)
    PROPHET_SLOT_TEXT(6)
    PROPHET_SLOT_TEXT(7)
    prophetSlotTextsCreated = true
