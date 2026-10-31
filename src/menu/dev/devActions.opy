#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Teleport to target":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_ADMIN
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition targetPlayer

    eventPlayer.teleport(nearestWalkablePosition(targetPlayer.getPosition() - vect(0, 0, -1)))
    eventPlayer.setFacing(targetPlayer.getFacingDirection(), Relativity.TO_WORLD)


rule "Unlock all heroes":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_ADMIN
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition not eventPlayer.isWinner

    if eventPlayer.heroNumber < len(heroList) - 1:
        eventPlayer.heroNumber = len(heroList) - 1
        waitLoadShort()
        eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
        waitLoadShort()
        smallMessage(eventPlayer, "  {0} 开发者模式：已解锁全英雄".format(iconString(Icon.BOLT)))
        #savePlayerData()
    elif not eventPlayer.isWinner:
        eventPlayer.isWinner = true
        waitLoadShort()
        smallMessage(eventPlayer, "  {0} 开发者模式：已通关".format(iconString(Icon.BOLT)))
