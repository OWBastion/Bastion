#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Restart match":
    @Event eachPlayer
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true

    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 长按 {1} 进行重启".format(iconString(Icon.BOLT), inputBindingString(Button.RELOAD)))
    wait(2, Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 正在重启...".format(iconString(Icon.BOLT)))
    wait(2, Wait.ABORT_WHEN_FALSE)
    restartMatch()
