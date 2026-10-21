#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Display admin page":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    hudHeader(eventPlayer, STR_MENU_TITLE_DEV, HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    hudSubheader(eventPlayer, STR_MENU_OPT_UNLOCK_ALL.format(inputBindingString(Button.SECONDARY_FIRE), STR_MENU_STATE_ON if eventPlayer.isWinner == true else STR_MENU_STATE_OFF, STR_MENU_OPT_RESTART_NOW.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.JUMP), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer != null else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_PLAYER.format(inputBindingString(Button.ULTIMATE), STR_MENU_OPT_TP_TO_TARGET.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_DMG_REDUCE.format(inputBindingString(Button.MELEE), STR_MENU_STATE_ON if eventPlayer.dmgReduc == true else STR_MENU_STATE_OFF, STR_MENU_OPT_INVINCIBLE.format(inputBindingString(Button.ABILITY_1), STR_MENU_STATE_ON if eventPlayer.invincible == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH))))))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[1] = getLastCreatedText()


rule "Display movement page":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    hudHeader(eventPlayer, STR_MENU_TITLE_DEV_PANEL, HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    hudSubheader(eventPlayer, STR_MENU_OPT_AIR_WALK.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_STATE_ON if eventPlayer.isAirWalkEnabled else STR_MENU_STATE_OFF, STR_MENU_OPT_NOCLIP.format(inputBindingString(Button.SECONDARY_FIRE), STR_MENU_STATE_ON if eventPlayer.isPortalEnabled == true else STR_MENU_STATE_OFF, STR_MENU_OPT_SELECT_INDEX.format(inputBindingString(Button.ABILITY_1), eventPlayer.controlCenterIndex, STR_MENU_OPT_TP_TO_INDEX.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[1] = getLastCreatedText()
