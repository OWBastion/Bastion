#!mainFile "../main.opy"

#!optimizeStrict
#!rulePrefix "Title"

rule "Next title":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition len(eventPlayer.playerTitles) > 0

    if eventPlayer.playerTitleIndex == null:
        eventPlayer.playerTitleIndex = 0
    waitLoadBrief()

    eventPlayer.playerTitleIndex = (eventPlayer.playerTitleIndex + 1) % len(eventPlayer.playerTitles)
    waitLoadBrief()

    eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]
    wait()

    applyTitleColor()

    smallMessage(
        eventPlayer,
        "  {0}  已将称号更改为 {1}".format(iconString(Icon.BOLT), titleText[eventPlayer.playerTitleAndColor])
    )
    waitLoadBrief()


rule "Previous title":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)
    @Condition len(eventPlayer.playerTitles) > 0

    if eventPlayer.playerTitleIndex == null or eventPlayer.playerTitleIndex <= 0:
        eventPlayer.playerTitleIndex = len(eventPlayer.playerTitles)

    waitLoadBrief()
    eventPlayer.playerTitleIndex--
    waitLoadBrief()

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

    waitLoadBrief()
