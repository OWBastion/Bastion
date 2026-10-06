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

    applyTitleColor()

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

    applyTitleColor()

    # 提示文本: 从 titleText 按ID取标题字符串
    smallMessage(
        eventPlayer,
        "  {0}  已将称号更改为 {1}".format(
            iconString(Icon.BOLT),
            titleText[eventPlayer.playerTitleAndColor]
        )
    )

    wait(getAverageServerLoad() / 100 * 0.032)
