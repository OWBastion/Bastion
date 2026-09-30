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
# 显示机制：复用称号系统的栏位文本能力（见 src/title/init.opy）。
# 称号是独立的公开显示层，对所有人可见；先知的揭示信息按 issue 边界
# 仅对先知本人可见，而单个文本对象只有一个 visibleTo，因此先知持有
# 与称号平行的一套栏位文本——同样按 Team.1 的 8 个栏位各建一条，
# 单局恒定 8 次 createInWorldText，玩家进出只改变 reeval 结果。
#   - 位置：占用者眼位上方 0.3m，落在称号行（引擎置顶）与头顶之间，
#     有/无称号时版式一致；栏位换人自动跟随
#   - 可见性：栏位占用者的先知集合（不含其本人——先知看不到自己的下一个事件）
#   - 内容：事件名经 eventName[eventNextIndex] 按 ID 查询
#   - 颜色：沿用占用者的称号色 rgb_vect；无称号（rgb_vect 未初始化）时给默认紫
# 称号状态（playerTitleAndColor / playerTitles）与称号文本一律不读写，
# 不影响称号本身及赌徒、资格判定等任何其他系统。

# 除栏位占用者本人以外当前持有“先知”事件的玩家集合（Unique 约束下最多一人）
# eventId 仅存枚举值，mech/debuff 编号可撞号，必须带 eventType 过滤
macro Player.prophets():
    getPlayers(Team.1).filter(lambda other: other != self and other.eventType == EventType.MECH and other.eventId == MechEventId.PROPHET)

#!define PROPHET_SLOT_WATCHERS(i) (TEAM1_SLOT_PLAYER(i).prophets() if TEAM1_SLOT_PLAYER(i) != null else [])
#!define PROPHET_SLOT_STRING(i) STR_EVT_MECH_25_NEXT.format(eventName[TEAM1_SLOT_PLAYER(i).eventNextIndex] if TEAM1_SLOT_PLAYER(i) != null and TEAM1_SLOT_PLAYER(i).eventNextIndex != null else STR_EVT_MECH_25_UNKNOWN)
#!define PROPHET_SLOT_POSITION(i) (TEAM1_SLOT_PLAYER(i).getEyePosition() + Vector.UP * 0.3 if TEAM1_SLOT_PLAYER(i) != null else vect(0, -1000, 0))
#!define PROPHET_SLOT_COLOR(i) (rgb(TEAM1_SLOT_PLAYER(i).rgb_vect.x, TEAM1_SLOT_PLAYER(i).rgb_vect.y, TEAM1_SLOT_PLAYER(i).rgb_vect.z) if TEAM1_SLOT_PLAYER(i) != null and TEAM1_SLOT_PLAYER(i).playerTitleAndColor != null else rgb(186, 120, 255))
#!define PROPHET_SLOT_TEXT(i) createInWorldText(PROPHET_SLOT_WATCHERS(i), PROPHET_SLOT_STRING(i), PROPHET_SLOT_POSITION(i), 0.7, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, PROPHET_SLOT_COLOR(i))

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
