#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

#!define MENU_PAGE_MAIN 1
#!define MENU_PAGE_HERO 2
#!define MENU_PAGE_DEV_ADMIN 3
#!define MENU_PAGE_DEV_MOVEMENT 4
#!define MENU_PAGE_DEV_WEIGHTS 5

# 第 1 页按角色分层：玩家 = 通用项；房主 = 重启计时 + 标记/移除 + 通用项；开发者 = 同房主（称号选项由 profile 决定）
#!define MENU_MAIN_TITLE(viewer) (STR_MENU_TITLE_INGAME.format(inputBindingString(Button.INTERACT), inputBindingString(Button.MELEE)))
#!define MENU_MAIN_COMMON(viewer) STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if viewer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_SETTLEMENT_CARD.format(inputBindingString(Button.INTERACT), STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH))) if viewer.isWinner else STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))
#!define MENU_MAIN_MODERATION(viewer) STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.ABILITY_1), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_BLOCK.format(inputBindingString(Button.RELOAD), MENU_MAIN_COMMON(viewer)))
#!define MENU_MAIN_REBOOT(next) STR_MENU_OPT_RESTART_EXTEND.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_OPT_RESTART_REDUCE.format(inputBindingString(Button.SECONDARY_FIRE), next))
#!define MENU_MAIN_BODY(viewer) (MENU_MAIN_REBOOT(PROFILE_DEV_MENU_OPTIONS(MENU_MAIN_MODERATION(viewer))) if viewer.isDev else (MENU_MAIN_REBOOT(PROFILE_HOST_MENU_OPTIONS(MENU_MAIN_MODERATION(viewer))) if viewer == hostPlayer else PROFILE_PLAYER_MENU_OPTIONS(MENU_MAIN_COMMON(viewer))))

rule "Toggle menu":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    if eventPlayer.isHoldingButton(Button.INTERACT) and eventPlayer.isHoldingButton(Button.CROUCH):
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
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    if eventPlayer.menu >= (MENU_PAGE_DEV_WEIGHTS if eventPlayer.isDev else MENU_PAGE_HERO):
        eventPlayer.menu = MENU_PAGE_MAIN
    else:
        eventPlayer.menu += 1

    # 防止按住连跳（不新增变量）
    waitUntil(not eventPlayer.isHoldingButton(Button.CROUCH), 99999)
