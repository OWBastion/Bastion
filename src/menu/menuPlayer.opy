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


rule "Show settlement card":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isWinner == true
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false

    eventPlayer.settlementCardEnd = evalOnce(getTotalTimeElapsed()) + 20
    waitUntil(eventPlayer.isHoldingButton(Button.INTERACT) == false, 99999)
