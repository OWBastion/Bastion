#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Select host target":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.menu == MENU_PAGE_MAIN
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    if targetPlayerIndex == null or targetPlayerIndex >= len(sorted(getPlayers(Team.1))):
        targetPlayerIndex = 0
        waitLoadBrief()
    waitLoadBrief()
    targetPlayer = sorted(getPlayers(Team.1), lambda player: player.joinTime)[targetPlayerIndex]
    targetPlayerIndex++
    waitLoadBrief()
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev).concat(hostPlayer), STR_MSG_ADMIN_NO_TARGET.format(iconString(Icon.BOLT)) if not targetPlayer else STR_MSG_ADMIN_MARKED.format(iconString(Icon.BOLT), targetPlayer, targetPlayer.getHero()))


rule "Kick host target":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.menu == MENU_PAGE_MAIN
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    if not targetPlayer or targetPlayer.isDev:
        return
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev).concat(hostPlayer), STR_MSG_ADMIN_HOLD_TO_KICK.format(iconString(Icon.BOLT), inputBindingString(Button.RELOAD), targetPlayer))
    wait(2, Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev).concat(hostPlayer), STR_MSG_ADMIN_KICK_WARNING.format(iconString(Icon.BOLT), targetPlayer))
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev).concat(hostPlayer), STR_MSG_ADMIN_KICK_SUCCESS.format(iconString(Icon.BOLT), targetPlayer))
    if "{0}".format(targetPlayer) in blackList:
        goto lbl_0
    blackList.append("{0}".format(targetPlayer))
    lbl_0:
    targetPlayer.removeFromGame()
    smallMessage(getAllPlayers(), STR_MSG_ADMIN_BLACKLIST_SUCCESS.format(iconString(Icon.BOLT), targetPlayer))
    targetPlayerIndex = 0
    targetPlayer = null
