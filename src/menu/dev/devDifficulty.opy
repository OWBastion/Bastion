#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Increase difficulty":
    @Event eachPlayer
    @Team 1
    @Condition difficulty < 5
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    @Disabled

    difficulty++
    setDifficulty()
    wait(getAverageServerLoad() / 100 * 0.032)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 已将难度设置为 {1}({2})".format(iconString(Icon.BOLT), difficultyText[0], difficulty))


rule "Decrease difficulty":
    @Event eachPlayer
    @Condition difficulty > 0
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Disabled

    difficulty--
    setDifficulty()
    wait(getAverageServerLoad() / 100 * 0.032)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 已将难度设置为 {1}({2})".format(iconString(Icon.BOLT), difficultyText[0], difficulty))
