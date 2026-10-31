#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Event/先知"

# Event: EventId.PROPHET (Unique)
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。
#
# 观测者效应：被先知观测的玩家若尚无已承诺的下一个事件（eventNextIndex == -1），
# 立即按当前旗标实掷一次使其坍缩——预览即实发，两者恒等；已承诺的绝不重掷。
#
# 显示机制：每名玩家一条头顶世界文本，在 eachPlayer 上下文中创建——
# 揭示内容的拥有者是观测对象本人，per-player 绑定比槽位矩阵简单且
# 进出由生成/销毁边沿自然处理；位置/文本/颜色的每帧重估只读
# eventPlayer 变量（眼位 / eventNextIndex / titleCycleAB），不含任何玩家扫描。
#   - 位置：眼位上方 0.3m，落在称号行（引擎置顶）与头顶之间
#   - 可见性：prophetViewers 排除本人——先知看不到自己的下一个事件。
#     prophetViewers 是唯一的玩家集合参数，由本文件 1Hz 全局循环刷新；
#     重估表达式内禁止内联 getPlayers().filter()（会转化为每帧常驻扫描）
#   - 内容：事件名经 eventName[eventNextIndex] 按 ID 查询
#   - 颜色：沿用称号当前色（title/initTitle.opy 中 titleColorNow 的同式内联——
#     该宏定义在本文件 include 之后，无法直接引用）；无称号循环色时给默认紫
# 称号状态（playerTitleAndColor / playerTitles）与称号文本一律不读写，
# 不影响称号本身及赌徒、资格判定等任何其他系统。

rule "Collapse undecided next event under observation":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned()
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer)
    @Condition len(prophetViewers.exclude(eventPlayer)) > 0
    @Condition eventPlayer.eventNextIndex == -1

    rerollNextEvent()

rule "Attach prophet next-event text":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.prophetTextId == null

    wait(eventPlayer.getSlot() * 0.08)
    createInWorldText(
        prophetViewers.exclude(eventPlayer),
        STR_EVT_MECH_25_NEXT.format(
            eventName[eventPlayer.eventNextIndex] if eventPlayer.eventNextIndex != -1 else STR_EVT_MECH_25_UNKNOWN
        ),
        eventPlayer.getEyePosition() + Vector.UP * 0.3,
        0.7,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(
            eventPlayer.titleCycleAB[0].x + eventPlayer.titleCycleAB[1].x * (1 - abs(((getTotalTimeElapsed() - eventPlayer.titleCycleT0) / 2.5) % 2 - 1)),
            eventPlayer.titleCycleAB[0].y + eventPlayer.titleCycleAB[1].y * (1 - abs(((getTotalTimeElapsed() - eventPlayer.titleCycleT0) / 2.5) % 2 - 1)),
            eventPlayer.titleCycleAB[0].z + eventPlayer.titleCycleAB[1].z * (1 - abs(((getTotalTimeElapsed() - eventPlayer.titleCycleT0) / 2.5) % 2 - 1)))
            if eventPlayer.titleCycleAB != null else rgb(186, 120, 255)
    )
    eventPlayer.prophetTextId = getLastCreatedText()

rule "Destroy prophet next-event text when player leaves":
    @Event playerLeft
    @Team 1
    @Condition eventPlayer.prophetTextId != null

    destroyInWorldText(eventPlayer.prophetTextId)
    eventPlayer.prophetTextId = null

# 先知集合低频缓存：文本可见性与坍缩条件每帧求值，只读该变量。
rule "Refresh prophet viewer cache":
    @Event global

    while true:
        prophetViewers = getPlayers(Team.1).filter(lambda p: p.eventId == EventId.PROPHET)
        wait(1)
