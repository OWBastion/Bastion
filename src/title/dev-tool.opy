#!mainFile "../main.opy"

#!optimizeStrict
#!rulePrefix "Title"

rule "Next title":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition len(eventPlayer.playerTitles) > 0

    if eventPlayer.playerTitleIndex == null:
        eventPlayer.playerTitleIndex = 0
    wait(getAverageServerLoad() / 100 * 0.032)

    eventPlayer.playerTitleIndex = (eventPlayer.playerTitleIndex + 1) % len(eventPlayer.playerTitles)
    wait(getAverageServerLoad() / 100 * 0.032)

    eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]
    wait()

     if titleColor[eventPlayer.playerTitleAndColor] == null:
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = rgbList[eventPlayer.info_pvar]
        eventPlayer.rgb_activated = true
    elif len(titleColor[eventPlayer.playerTitleAndColor]) >= 1:
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor][0]
        eventPlayer.rgb_activated = true
    else:
        eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor]
        eventPlayer.rgb_activated = false

    smallMessage(
        eventPlayer,
        "  {0}  已将称号更改为 {1}".format(iconString(Icon.BOLT), titleText[eventPlayer.playerTitleAndColor])
    )
    wait(getAverageServerLoad() / 100 * 0.032)


rule "Previous title":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition len(eventPlayer.playerTitles) > 0

    if eventPlayer.playerTitleIndex == null or eventPlayer.playerTitleIndex <= 0:
        eventPlayer.playerTitleIndex = len(eventPlayer.playerTitles)

    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.playerTitleIndex--
    wait(getAverageServerLoad() / 100 * 0.032)

    # 当前称号ID(使用原变量名,内容改为ID)
    eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]
    wait()

    # 取出全局表里该称号的颜色数据
    # titleColor[eventPlayer.playerTitleAndColor] 可能是: null / [vect, vect, ...] / vect
    if titleColor[eventPlayer.playerTitleAndColor] == null:
        # 无自带颜色 → 用 rgbList 做彩虹
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = rgbList[eventPlayer.info_pvar]
        eventPlayer.rgb_activated = true

    elif len(titleColor[eventPlayer.playerTitleAndColor]) >= 1:
        # 多段 RGB 数组
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor][0]
        eventPlayer.rgb_activated = true

    else:
        # 单色向量(或其它非数组形式)
        eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor]
        eventPlayer.rgb_activated = false

    # 提示文本: 从 titleText 按ID取标题字符串
    smallMessage(
        eventPlayer,
        "  {0}  已将称号更改为 {1}".format(
            iconString(Icon.BOLT),
            titleText[eventPlayer.playerTitleAndColor]
        )
    )

    wait(getAverageServerLoad() / 100 * 0.032)
