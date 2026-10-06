#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Toggle third person":
    @Event eachPlayer
    #@Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.menu == 1

    wait(getAverageServerLoad() / 100 * 0.032)
    setThirdPerson()
