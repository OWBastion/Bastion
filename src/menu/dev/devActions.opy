#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Teleport to target":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition targetPlayer != null

    eventPlayer.teleport(nearestWalkablePosition(targetPlayer.getPosition() - vect(0, 0, -1)))
    eventPlayer.setFacing(targetPlayer.getFacingDirection(), Relativity.TO_WORLD)


rule "Unlock all heroes":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition eventPlayer.isWinner == false

    if eventPlayer.heroNumber < len(heroList) - 1:
        eventPlayer.heroNumber = len(heroList) - 1
        wait(getAverageServerLoad() / 100 * 0.5)
        eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
        wait(getAverageServerLoad() / 100 * 0.5)
        smallMessage(eventPlayer, "  {0} 开发者模式：已解锁全英雄".format(iconString(Icon.BOLT)))
        #savePlayerData()
    elif eventPlayer.isWinner == false:
        eventPlayer.isWinner = true
        wait(getAverageServerLoad() / 100 * 0.5)
        smallMessage(eventPlayer, "  {0} 开发者模式：已通关".format(iconString(Icon.BOLT)))
