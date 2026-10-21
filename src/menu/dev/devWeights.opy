#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

#!define getCurrentEventIdArray() eventCatalogId.filter(lambda id: eventCatalogType[id] == devEventCategory)

rule "Display event weights":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.key == "他又"
    @Condition eventPlayer.menu == 4

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])

    # 标题
    hudHeader(eventPlayer, STR_MENU_TITLE_WEIGHT_MANAGE, HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()

    # 内容显示
    # 格式：
    # [Q] 切换分类：当前分类
    # [E] 切换事件：事件名 (索引)
    # [Shift/R] 调整权重：当前权重
    # [Ctrl] 下一页
    hudSubheader(eventPlayer,
        "{0} 切换分类：{1}\n{2} 切换事件：{3}\n{4} 调整权重：{5}\n{6}".format(
            inputBindingString(Button.ULTIMATE),
            STR_CAT_BUFF if devEventCategory == 0 else (STR_CAT_DEBUFF if devEventCategory == 1 else STR_CAT_MECH),

            inputBindingString(Button.ABILITY_2),
            "{0} (Idx: {1})".format(
                eventName[getCurrentEventIdArray()[devEventIndex]],
                getCurrentEventIdArray()[devEventIndex]
            ) if len(getCurrentEventIdArray()) > 0 else "无事件",

            "{0}/{1}".format(inputBindingString(Button.ABILITY_1), inputBindingString(Button.RELOAD)),
            # 获取权重：如果数组长度>=4则取第4个元素，否则默认为 1.0
            eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] if eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] != null else 1.0
            if len(getCurrentEventIdArray()) > 0 else "N/A",

            STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH))
        ),
        HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    eventPlayer.menuTextID[1] = getLastCreatedText()

rule "Cycle event category":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true

    devEventCategory = (devEventCategory + 1) % 3
    devEventIndex = 0 # 切换分类重置索引
    wait(0.2)

rule "Cycle event selection":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true

    # 循环切换索引
    if len(getCurrentEventIdArray()) > 0:
        devEventIndex = (devEventIndex + 1) % len(getCurrentEventIdArray())
    wait(0.1)

rule "Increase event weight":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true

    if len(getCurrentEventIdArray()) > 0:
        if eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] == null:
            eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] = 1.0
        eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] += 0.1
        # 置空触发对局码重算，使码内嵌权重与 hashTag 总账反映修改后数值
        masteryRunCode = ""

    wait(0.1)

rule "Decrease event weight":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    if len(getCurrentEventIdArray()) > 0:
        if eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] == null:
            eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] = 1.0
        if eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] >= 0.1:
            eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] -= 0.1
        else:
            eventCatalogWeight[getCurrentEventIdArray()[devEventIndex]] = 0
        # 置空触发对局码重算，使码内嵌权重与 hashTag 总账反映修改后数值
        masteryRunCode = ""

    wait(0.1)
