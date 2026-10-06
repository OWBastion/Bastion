#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Toggle menu":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true

    if (eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.CROUCH)) == true:
        return
    if eventPlayer.menu != 0:
        goto lbl_0
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.menu = 1
    return
    lbl_0:
    eventPlayer.menu = 0
    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.CROUCH)


rule "Cleanup closed menu":
    @Event eachPlayer
    @Condition eventPlayer.menu == 0

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.CROUCH)


rule "Advance page":
    @Event eachPlayer
    @Condition eventPlayer.menu != 0
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true

    if eventPlayer.isDev == true:
        if eventPlayer.menu >= 5:
            eventPlayer.menu = 1
        else:
            eventPlayer.menu += 1
    else:
        if eventPlayer.menu >= 2:
            eventPlayer.menu = 1
        else:
            eventPlayer.menu += 1

    # 防止按住连跳（不新增变量）
    waitUntil(eventPlayer.isHoldingButton(Button.CROUCH) == false, 99999)

rule "Display mode page":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    hudHeader(eventPlayer, STR_MENU_TITLE_INGAME.format(inputBindingString(Button.INTERACT), inputBindingString(Button.MELEE)), HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    if eventPlayer.isDev:
        hudSubheader(eventPlayer, STR_MENU_OPT_RESTART_EXTEND.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_OPT_RESTART_REDUCE.format(inputBindingString(Button.SECONDARY_FIRE), PROFILE_DEV_MENU_OPTIONS(STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.ABILITY_1), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer != null else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_BLOCK.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if eventPlayer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    elif eventPlayer == hostPlayer:
        hudSubheader(eventPlayer, STR_MENU_OPT_RESTART_EXTEND.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_OPT_RESTART_REDUCE.format(inputBindingString(Button.SECONDARY_FIRE), PROFILE_HOST_MENU_OPTIONS(STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.ABILITY_1), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer != null else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_BLOCK.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if eventPlayer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    else:
        hudSubheader(eventPlayer, PROFILE_PLAYER_MENU_OPTIONS(STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if eventPlayer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[1] = getLastCreatedText()
