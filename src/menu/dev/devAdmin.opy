#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

#!define MENU_DEV_ADMIN_TITLE(viewer) (STR_MENU_TITLE_DEV)
#!define MENU_DEV_ADMIN_BODY(viewer) (STR_MENU_OPT_UNLOCK_ALL.format(inputBindingString(Button.SECONDARY_FIRE), STR_MENU_STATE_ON if viewer.isWinner else STR_MENU_STATE_OFF, STR_MENU_OPT_RESTART_NOW.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.JUMP), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_PLAYER.format(inputBindingString(Button.ULTIMATE), STR_MENU_OPT_TP_TO_TARGET.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_DMG_REDUCE.format(inputBindingString(Button.MELEE), STR_MENU_STATE_ON if viewer.dmgReduc else STR_MENU_STATE_OFF, STR_MENU_OPT_INVINCIBLE.format(inputBindingString(Button.ABILITY_1), STR_MENU_STATE_ON if viewer.invincible else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH))))))))))

rule "Select dev target":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_ADMIN
    @Condition eventPlayer.isHoldingButton(Button.JUMP)

    if targetPlayerIndex == null or targetPlayerIndex >= len(sorted(getPlayers(Team.1))):
        targetPlayerIndex = 0
        waitLoadBrief()
    waitLoadBrief()
    targetPlayer = sorted(getPlayers(Team.1), lambda player: player.joinTime)[targetPlayerIndex]
    targetPlayerIndex++
    waitLoadBrief()
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  没有可标记的玩家".format(iconString(Icon.BOLT)) if not targetPlayer else "  {0}  开发者模式： 已标记 {1}（{2}）".format(iconString(Icon.BOLT), targetPlayer, targetPlayer.getHero()))


rule "Kick dev target":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_ADMIN
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    if not targetPlayer or targetPlayer.isDev:
        return
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 长按 {1} 移除 {2}".format(iconString(Icon.BOLT), inputBindingString(Button.ULTIMATE), targetPlayer))
    wait(2, Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 即将移除玩家 {1}".format(iconString(Icon.BOLT), targetPlayer))
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(getPlayers(Team.1).filter(lambda player: player.isDev), "  {0}  开发者模式： 已移除玩家 {1}".format(iconString(Icon.BOLT), targetPlayer))
    if "{0}".format(targetPlayer) in blackList:
        goto lbl_0
    blackList.append("{0}".format(targetPlayer))
    lbl_0:
    targetPlayer.removeFromGame()
    targetPlayerIndex = 0
    targetPlayer = null


rule "Toggle damage reduction":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_ADMIN
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    eventPlayer.dmgReduc = not eventPlayer.dmgReduc
    waitLoadBrief()
    if eventPlayer.dmgReduc:
        eventPlayer.setDamageReceived(1)
        createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.nanoEffect = getLastCreatedEntity()
        smallMessage(eventPlayer, "  {0}  开发者模式： 已将伤害减免设置为 -{1}%".format(iconString(Icon.BOLT), 99))
    else:
        eventPlayer.setDamageReceived(100)
        destroyEffect(eventPlayer.nanoEffect)
        smallMessage(eventPlayer, "  {0}  开发者模式： 已取消伤害减免".format(iconString(Icon.BOLT)))


rule "Toggle invincible":
    @Event eachPlayer
    @Condition eventPlayer.isDev
    @Condition eventPlayer.menu == MENU_PAGE_DEV_ADMIN
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    eventPlayer.invincible = not eventPlayer.invincible
    waitLoadBrief()
    if eventPlayer.invincible:
        eventPlayer.setStatusEffect(null, Status.INVINCIBLE, Math.INFINITY)
        createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.invincibleEffect[InvincibleEffectSlot.DEV_TOOL] = getLastCreatedEntity()
        smallMessage(eventPlayer, "  {0}  开发者模式： 已设置为无敌状态".format(iconString(Icon.BOLT)))
    else:
        eventPlayer.clearStatusEffect(Status.INVINCIBLE)
        destroyEffect(eventPlayer.invincibleEffect[InvincibleEffectSlot.DEV_TOOL])
        eventPlayer.invincibleEffect[InvincibleEffectSlot.DEV_TOOL] = null
        smallMessage(eventPlayer, "  {0}  开发者模式： 已取消无敌状态".format(iconString(Icon.BOLT)))
