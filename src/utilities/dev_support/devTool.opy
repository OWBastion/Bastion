#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "dev menu in game":
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


rule "dev menu disable":
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


rule "page down in menu":
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

rule "menu mode settings display":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    
    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    hudHeader(eventPlayer, "{0}".format(STR_MENU_TITLE_INGAME), HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    if eventPlayer.isDev:
        hudSubheader(eventPlayer, STR_MENU_OPT_RESTART_EXTEND.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_OPT_RESTART_REDUCE.format(inputBindingString(Button.SECONDARY_FIRE), STR_MENU_OPT_TITLE_PREV.format(inputBindingString(Button.ULTIMATE), STR_MENU_OPT_TITLE_NEXT.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.ABILITY_1), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer != null else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_BLOCK.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if eventPlayer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH))))))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    elif eventPlayer == hostPlayer:
        hudSubheader(eventPlayer, STR_MENU_OPT_RESTART_EXTEND.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_OPT_RESTART_REDUCE.format(inputBindingString(Button.SECONDARY_FIRE),  STR_MENU_OPT_TITLE_NEXT.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.ABILITY_1), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer != null else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_BLOCK.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if eventPlayer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    else:
        hudSubheader(eventPlayer, STR_MENU_OPT_TITLE_NEXT.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_THIRD_PERSON.format(inputBindingString(Button.JUMP), STR_MENU_STATE_ON if eventPlayer.third == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[1] = getLastCreatedText()

rule "menu hero display (player/host)":
    @Event eachPlayer
    @Condition eventPlayer.isWinner == true
    @Condition (eventPlayer.menu == 2 and eventPlayer.isDev == false) or (eventPlayer.menu == 5 and eventPlayer.isDev == true)

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])

    hudHeader(eventPlayer, STR_MENU_OPT_HERO_PAGE_TITLE, HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()

    eventPlayer.menuHeroIndex = eventPlayer.menuHeroIndex % (
        (
            (len(heroList) - 1) if (eventPlayer.heroNumber) > (len(heroList) - 1)
            else (eventPlayer.heroNumber)
        ) + 1
    )

    hudSubheader(
        eventPlayer,
        STR_MENU_OPT_HERO_NEXT.format(
            inputBindingString(Button.PRIMARY_FIRE),
            heroList[eventPlayer.menuHeroIndex],
            STR_MENU_OPT_HERO_APPLY.format(
                    inputBindingString(Button.RELOAD),
                    ""
                )
        ),
        HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    eventPlayer.menuTextID[1] = getLastCreatedText()

rule "menu hero next":
    @Event eachPlayer
    @Condition eventPlayer.isWinner == true
    @Condition (eventPlayer.menu == 2 and eventPlayer.isDev == false) or (eventPlayer.menu == 5 and eventPlayer.isDev == true)
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    eventPlayer.menuHeroIndex += 1
    eventPlayer.menuHeroIndex = eventPlayer.menuHeroIndex % (
        (
            (len(heroList) - 1) if (eventPlayer.heroNumber) > (len(heroList) - 1)
            else (eventPlayer.heroNumber)
        ) + 1
    )
    waitUntil(eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == false, 99999)

rule "menu hero apply (spawn only)":
    @Event eachPlayer
    @Condition eventPlayer.isWinner == true
    @Condition (eventPlayer.menu == 2 and eventPlayer.isDev == false) or (eventPlayer.menu == 5 and eventPlayer.isDev == true)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition (eventPlayer.isInSpawnRoom() and eventPlayer.isMoving() != true) == true

    eventPlayer.menuHeroIndex = eventPlayer.menuHeroIndex % (
        (
            (len(heroList) - 1) if (eventPlayer.heroNumber) > (len(heroList) - 1)
            else (eventPlayer.heroNumber)
        ) + 1
    )
    eventPlayer.startForcingHero(heroList[eventPlayer.menuHeroIndex])
    waitUntil(eventPlayer.getHero() == heroList[eventPlayer.heroNumber], 0.5)
    eventPlayer.stopForcingCurrentHero()
    wait(getServerLoad() / 100 * 0.5)
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    waitUntil(eventPlayer.isHoldingButton(Button.RELOAD) == false, 99999)

rule "menu dev control display":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    
    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    hudHeader(eventPlayer, STR_MENU_TITLE_DEV, HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    hudSubheader(eventPlayer, STR_MENU_OPT_DEBUG_INFO.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_STATE_ON if debugInfo else STR_MENU_STATE_OFF, STR_MENU_OPT_UNLOCK_ALL.format(inputBindingString(Button.SECONDARY_FIRE), STR_MENU_STATE_ON if eventPlayer.isWinner == true else STR_MENU_STATE_OFF, STR_MENU_OPT_RESTART_NOW.format(inputBindingString(Button.RELOAD), STR_MENU_OPT_MARK_PLAYER.format(inputBindingString(Button.JUMP), "{0}（{1}）".format(targetPlayer, targetPlayer.getHero()) if targetPlayer != null else STR_MENU_STATE_NULL, STR_MENU_OPT_UNMARK_PLAYER.format(inputBindingString(Button.ULTIMATE), STR_MENU_OPT_TP_TO_TARGET.format(inputBindingString(Button.ABILITY_2), STR_MENU_OPT_DMG_REDUCE.format(inputBindingString(Button.MELEE), STR_MENU_STATE_ON if eventPlayer.dmgReduc == true else STR_MENU_STATE_OFF, STR_MENU_OPT_INVINCIBLE.format(inputBindingString(Button.ABILITY_1), STR_MENU_STATE_ON if eventPlayer.invincible == true else STR_MENU_STATE_OFF, STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)))))))))), HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[1] = getLastCreatedText()


rule "menu dev devlop display":
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


rule "3rd camera toggle":
    @Event eachPlayer
    #@Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.menu == 1
    
    wait(getAverageServerLoad() / 100 * 0.032)
    setThirdPerson()


rule "dev debug mode toggle":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.menu == 2
    
    debugInfo = not debugInfo
    wait(getAverageServerLoad() / 100 * 0.032)
    devPlayer.debugInfo = debugInfo


rule "dev set difficulty":
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
    smallMessage(devPlayer, "  {0}  开发者模式： 已将难度设置为 {1}({2})".format(iconString(Icon.BOLT), difficultyText[0], difficulty))


rule "dev set difficulty":
    @Event eachPlayer
    @Condition difficulty > 0
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Disabled
    
    difficulty--
    setDifficulty()
    wait(getAverageServerLoad() / 100 * 0.032)
    smallMessage(devPlayer, "  {0}  开发者模式： 已将难度设置为 {1}({2})".format(iconString(Icon.BOLT), difficultyText[0], difficulty))


rule "dev add auto reboot time":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition (eventPlayer.isDev or hostPlayer == eventPlayer) == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true

    
    if rebootTime + 300 <= 15900 and __currentMap___ != Map.AYUTTHAYA:
        rebootTime += 300
        if eventPlayer.isDev:
            smallMessage(devPlayer, "  {0}  开发者模式： 已将自动重开时间延长 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
        else:
            smallMessage(getAllPlayers(), "  {0}  模式调整： 房主已将自动重开时间延长 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
    else:
        smallMessage(eventPlayer, "  {0}  已达到最大上限".format(iconString(Icon.WARNING)))


rule "dev remove auto reboot time":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition (eventPlayer.isDev or hostPlayer == eventPlayer) == true
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    #wait(0.16, Wait.ABORT_WHEN_FALSE)
    if rebootTime - 300 >= 300 and __currentMap___ != Map.AYUTTHAYA:
        rebootTime -= 300
        if eventPlayer.isDev:
            smallMessage(devPlayer, "  {0}  开发者模式： 已将自动重开时间缩短 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))
        else:
            smallMessage(getAllPlayers(), "  {0}  模式调整： 房主已将自动重开时间缩短 {1} 分钟".format(iconString(Icon.BOLT), 300 / 60))

            
rule "player title menu - next":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition len(eventPlayer.playerTitles) > 0
    
    if eventPlayer.playerTitleIndex == null:
        eventPlayer.playerTitleIndex = 0
    wait(getAverageServerLoad() / 100 * 0.032)

    eventPlayer.playerTitleIndex = (eventPlayer.playerTitleIndex + 1) % len(eventPlayer.playerTitles)
    wait(getAverageServerLoad() / 100 * 0.032)

    eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]
    wait()

     if allTitle[eventPlayer.playerTitleAndColor][1] == null:
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = rgbList[eventPlayer.info_pvar]
        eventPlayer.rgb_activated = true
    elif len(allTitle[eventPlayer.playerTitleAndColor][1]) >= 1:
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = allTitle[eventPlayer.playerTitleAndColor][1][0]
        eventPlayer.rgb_activated = true
    else:
        eventPlayer.rgb_vect = allTitle[eventPlayer.playerTitleAndColor][1]
        eventPlayer.rgb_activated = false

    smallMessage(
        eventPlayer,
        "  {0}  已将称号更改为 {1}".format(iconString(Icon.BOLT), allTitle[eventPlayer.playerTitleAndColor][0])
    )
    wait(getAverageServerLoad() / 100 * 0.032)


rule "player title menu - previous":
    @Event eachPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition len(eventPlayer.playerTitles) > 0
    
    if eventPlayer.playerTitleIndex == null or eventPlayer.playerTitleIndex <= 0:
        eventPlayer.playerTitleIndex = len(eventPlayer.playerTitles)

    wait(getAverageServerLoad() / 100 * 0.032)
    eventPlayer.playerTitleIndex--
    wait(getAverageServerLoad() / 100 * 0.032)

    # 当前称号ID(使用原变量名,内容改为ID)
    eventPlayer.playerTitleAndColor = eventPlayer.playerTitles[eventPlayer.playerTitleIndex]
    wait()

    # 取出全局表里该称号的颜色数据
    # allTitle[eventPlayer.playerTitleAndColor][1] 可能是: null / [vect, vect, ...] / vect
    if allTitle[eventPlayer.playerTitleAndColor][1] == null:
        # 无自带颜色 → 用 rgbList 做彩虹
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = rgbList[eventPlayer.info_pvar]
        eventPlayer.rgb_activated = true

    elif len(allTitle[eventPlayer.playerTitleAndColor][1]) >= 1:
        # 多段 RGB 数组
        stopChasingVariable(eventPlayer.rgb_vect)
        eventPlayer.info_pvar = 0
        eventPlayer.rgb_vect = allTitle[eventPlayer.playerTitleAndColor][1][0]
        eventPlayer.rgb_activated = true

    else:
        # 单色向量(或其它非数组形式)
        eventPlayer.rgb_vect = allTitle[eventPlayer.playerTitleAndColor][1]
        eventPlayer.rgb_activated = false

    # 提示文本: 从 allTitle 按ID取标题字符串
    smallMessage(
        eventPlayer,
        "  {0}  已将称号更改为 {1}".format(
            iconString(Icon.BOLT),
            allTitle[eventPlayer.playerTitleAndColor][0]
        )
    )

    wait(getAverageServerLoad() / 100 * 0.032)


rule "dev reboot":
    @Event eachPlayer
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    smallMessage(devPlayer, "  {0}  开发者模式： 长按 {1} 进行重启".format(iconString(Icon.BOLT), inputBindingString(Button.RELOAD)))
    wait(2, Wait.ABORT_WHEN_FALSE)
    smallMessage(devPlayer, "  {0}  开发者模式： 正在重启...".format(iconString(Icon.BOLT)))
    wait(2, Wait.ABORT_WHEN_FALSE)
    restartMatch()


rule "host set target player":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    if targetPlayerIndex == null or targetPlayerIndex >= len(sorted(getPlayers(Team.1))):
        targetPlayerIndex = 0
        wait(getAverageServerLoad() / 100 * 0.032)
    wait(getAverageServerLoad() / 100 * 0.032)
    targetPlayer = sorted(getPlayers(Team.1), lambda player: player.joinTime)[targetPlayerIndex]
    targetPlayerIndex++
    wait(getAverageServerLoad() / 100 * 0.032)
    smallMessage(devPlayer.concat(hostPlayer), STR_MSG_ADMIN_NO_TARGET.format(iconString(Icon.BOLT)) if targetPlayer == null else STR_MSG_ADMIN_MARKED.format(iconString(Icon.BOLT), targetPlayer, targetPlayer.getHero()))


rule "host remove target player":
    @Event eachPlayer
    @Condition eventPlayer == hostPlayer
    @Condition eventPlayer.menu == 1
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    if targetPlayer == null or targetPlayer in devPlayer:
        return
    smallMessage(devPlayer.concat(hostPlayer), STR_MSG_ADMIN_HOLD_TO_KICK.format(iconString(Icon.BOLT), inputBindingString(Button.RELOAD), targetPlayer))
    wait(2, Wait.ABORT_WHEN_FALSE)
    smallMessage(devPlayer.concat(hostPlayer), STR_MSG_ADMIN_KICK_WARNING.format(iconString(Icon.BOLT), targetPlayer))
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(devPlayer.concat(hostPlayer), STR_MSG_ADMIN_KICK_SUCCESS.format(iconString(Icon.BOLT), targetPlayer))
    if "{0}".format(targetPlayer) in blackList:
        goto lbl_0
    blackList.append("{0}".format(targetPlayer))
    lbl_0:
    targetPlayer.removeFromGame()
    smallMessage(getAllPlayers(), STR_MSG_ADMIN_BLACKLIST_SUCCESS.format(iconString(Icon.BOLT), targetPlayer))
    targetPlayerIndex = 0
    targetPlayer = null


rule "dev set target player":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    if targetPlayerIndex == null or targetPlayerIndex >= len(sorted(getPlayers(Team.1))):
        targetPlayerIndex = 0
        wait(getAverageServerLoad() / 100 * 0.032)
    wait(getAverageServerLoad() / 100 * 0.032)
    targetPlayer = sorted(getPlayers(Team.1), lambda player: player.joinTime)[targetPlayerIndex]
    targetPlayerIndex++
    wait(getAverageServerLoad() / 100 * 0.032)
    smallMessage(devPlayer, "  {0}  没有可标记的玩家".format(iconString(Icon.BOLT)) if targetPlayer == null else "  {0}  开发者模式： 已标记 {1}（{2}）".format(iconString(Icon.BOLT), targetPlayer, targetPlayer.getHero()))


rule "dev remove target player":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    if targetPlayer == null or targetPlayer in devPlayer:
        return
    smallMessage(devPlayer, "  {0}  开发者模式： 长按 {1} 移除 {2}".format(iconString(Icon.BOLT), inputBindingString(Button.ULTIMATE), targetPlayer))
    wait(2, Wait.ABORT_WHEN_FALSE)
    smallMessage(devPlayer, "  {0}  开发者模式： 即将移除玩家 {1}".format(iconString(Icon.BOLT), targetPlayer))
    wait(1, Wait.ABORT_WHEN_FALSE)
    smallMessage(devPlayer, "  {0}  开发者模式： 已移除玩家 {1}".format(iconString(Icon.BOLT), targetPlayer))
    if "{0}".format(targetPlayer) in blackList:
        goto lbl_0
    blackList.append("{0}".format(targetPlayer))
    lbl_0:
    targetPlayer.removeFromGame()
    targetPlayerIndex = 0
    targetPlayer = null


rule "dev set dmg reduction":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.dmgReduc = not eventPlayer.dmgReduc
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.dmgReduc:
        eventPlayer.setDamageReceived(1)
        createEffect(getAllPlayers(), Effect.ANA_NANO_BOOSTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.nanoEffect = getLastCreatedEntity()
        smallMessage(eventPlayer, "  {0}  开发者模式： 已将伤害减免设置为 -{1}%".format(iconString(Icon.BOLT), 99))
    else:
        eventPlayer.setDamageReceived(100)
        destroyEffect(eventPlayer.nanoEffect)
        smallMessage(eventPlayer, "  {0}  开发者模式： 已取消伤害减免".format(iconString(Icon.BOLT)))


rule "dev set invincible":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    eventPlayer.invincible = not eventPlayer.invincible
    wait(getAverageServerLoad() / 100 * 0.032)
    if eventPlayer.invincible:
        eventPlayer.setStatusEffect(null, Status.INVINCIBLE, MAX_TIME)
        createEffect(getAllPlayers(), Effect.BAPTISTE_IMMORTALITY_FIELD_PROTECTED, Color.TEAM_1, eventPlayer, 200, EffectReeval.POSITION_AND_RADIUS)
        eventPlayer.invincibleEffect = getLastCreatedEntity()
        smallMessage(eventPlayer, "  {0}  开发者模式： 已设置为无敌状态".format(iconString(Icon.BOLT)))
    else:
        eventPlayer.clearStatusEffect(Status.INVINCIBLE)
        destroyEffect(eventPlayer.invincibleEffect)
        smallMessage(eventPlayer, "  {0}  开发者模式： 已取消无敌状态".format(iconString(Icon.BOLT)))


rule "dev air walk toggle":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition eventPlayer.menu == 3
    
    if eventPlayer.isAirWalkEnabled == true:
        goto lbl_0
    eventPlayer.setGravity(0)
    eventPlayer.isAirWalkEnabled = true
    smallMessage(eventPlayer, "  {0}  开发者模式： 已开启浮空".format(iconString(Icon.BOLT)))
    return
    lbl_0:
    eventPlayer.setGravity(100)
    eventPlayer.isAirWalkEnabled = false
    smallMessage(eventPlayer, "  {0}  开发者模式： 已关闭浮空".format(iconString(Icon.BOLT)))


rule "dev air lock":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.isAirWalkEnabled == true
    @Condition eventPlayer.getThrottle() == vect(0, 0, 0)
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == false
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == false
    
    eventPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(negToPos(eventPlayer.getVelocity()), 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)


rule "dev portal toggle":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    if eventPlayer.isPortalEnabled == true:
        goto lbl_0
    eventPlayer.isPortalEnabled = true
    smallMessage(eventPlayer, "  {0}  开发者模式： 已开启穿墙".format(iconString(Icon.BOLT)))
    return
    lbl_0:
    eventPlayer.isPortalEnabled = false
    smallMessage(eventPlayer, "  {0}  开发者模式： 已关闭穿墙".format(iconString(Icon.BOLT)))


rule "dev R portal":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 0
    @Condition eventPlayer.isPortalEnabled == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isCommunicatingEmote() == false
    @Condition (getCurrentMap() == Map.HORIZON_LUNAR_COLONY and distance(eventPlayer, vect(-9.38, 8.74, 2.05)) < 1) == false
    
    eventPlayer.setGravity(abs(0))
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true:
        goto lbl_0
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 4)
    goto lbl_1
    lbl_0:
    eventPlayer.teleport(eventPlayer.getPosition() + eventPlayer.getFacingDirection() * 20)
    lbl_1:
    wait(0.16)
    if ruleCondition:
        loop()
    if eventPlayer.isAirWalkEnabled == true:
        return
    eventPlayer.setGravity(abs(100))


rule "dev pick control center Position":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    if controlCenterPosition == null:
        smallMessage(eventPlayer, "  {0}  开发者模式： 目标点坐标为空".format(iconString(Icon.BOLT)))
        return
    else:
        if eventPlayer.controlCenterIndex >= 2:
            goto lbl_0
        eventPlayer.controlCenterIndex++
        smallMessage(eventPlayer, "  {0}  开发者模式： 已选择目标点坐标：{1}".format(iconString(Icon.BOLT), controlCenterPosition[eventPlayer.controlCenterIndex]))
        return
        lbl_0:
        eventPlayer.controlCenterIndex = 0
        smallMessage(eventPlayer, "  {0}  开发者模式： 已选择目标点坐标：{1}".format(iconString(Icon.BOLT), controlCenterPosition[eventPlayer.controlCenterIndex]))


rule "dev to control center Position":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 3
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition controlCenterPosition != null
    
    eventPlayer.teleport(nearestWalkablePosition(controlCenterPosition[eventPlayer.controlCenterIndex]))


rule "dev to Target Player Position":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 2
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    @Condition targetPlayer != null
    
    eventPlayer.teleport(nearestWalkablePosition(targetPlayer.getPosition() - vect(0, 0, -1)))
    eventPlayer.setFacing(targetPlayer.getFacingDirection(), Relativity.TO_WORLD)


rule "Dev to release heros":
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

#!define getCurrentEventArray() (buffEvent if devEventCategory == 0 else (debuffEvent if devEventCategory == 1 else mechEvent))
#!define getCurrentEventIdArray() (buffEventId if devEventCategory == 0 else (debuffEventId if devEventCategory == 1 else mechEventId))

rule "menu dev event weight display":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    
    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
    
    # 标题
    hudHeader(eventPlayer, STR_MENU_TITLE_WEIGHT_MANAGE, HudPosition.TOP, 2, Color.WHITE, HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    
    # 内容显示
    # 格式：
    # [Q] 切换分类：当前分类
    # [E] 切换事件：事件名 (索引)
    # [Shift/R] 调整权重：当前权重
    # [Ctrl] 下一页
    hudSubheader(eventPlayer, 
        "{0} 切换分类：{1}\n{2} 切换事件：{3}\n{4} 调整权重：{5}\n{6}".format(
            inputBindingString(Button.ULTIMATE),
            STR_CAT_BUFF if devEventCategory == 0 else (STR_CAT_DEBUFF if devEventCategory == 1 else STR_CAT_MECH),
            
            inputBindingString(Button.ABILITY_2),
            "{0} (Idx: {1})".format(
                getCurrentEventArray()[devEventIndex][0], 
                devEventIndex
            ) if len(getCurrentEventArray()) > 0 else "无事件",
            
            "{0}/{1}".format(inputBindingString(Button.ABILITY_1), inputBindingString(Button.RELOAD)),
            # 获取权重：如果数组长度>=4则取第4个元素，否则默认为 1.0
            (getCurrentEventArray()[devEventIndex][3] if len(getCurrentEventArray()[devEventIndex]) >= 4 else 1.0) 
            if len(getCurrentEventArray()) > 0 else "N/A",
            
            STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH))
        ), 
        HudPosition.TOP, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    eventPlayer.menuTextID[1] = getLastCreatedText()

rule "dev event category switch (Q)":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    
    devEventCategory = (devEventCategory + 1) % 3
    devEventIndex = 0 # 切换分类重置索引
    wait(0.2)

rule "dev event select next (E)":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2) == true
    
    # 循环切换索引
    if len(getCurrentEventArray()) > 0:
        devEventIndex = (devEventIndex + 1) % len(getCurrentEventArray())
    wait(0.1)

rule "dev event weight increase (Shift)":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1) == true
    
    # 必须显式区分变量来修改
    if devEventCategory == 0:
        if len(buffEvent) > 0:
            # 检查并初始化权重
            if len(buffEvent[devEventIndex]) < 4:
                buffEvent[devEventIndex][3] = 1.0
            # 增加权重
            buffEvent[devEventIndex][3] += 0.1
            
    elif devEventCategory == 1:
        if len(debuffEvent) > 0:
            if len(debuffEvent[devEventIndex]) < 4:
                debuffEvent[devEventIndex][3] = 1.0
            debuffEvent[devEventIndex][3] += 0.1
            
    elif devEventCategory == 2:
        if len(mechEvent) > 0:
            if len(mechEvent[devEventIndex]) < 4:
                mechEvent[devEventIndex][3] = 1.0
            mechEvent[devEventIndex][3] += 0.1
            
    wait(0.1)

rule "dev event weight decrease (R)":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.menu == 4
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    
    if devEventCategory == 0:
        if len(buffEvent) > 0:
            if len(buffEvent[devEventIndex]) < 4:
                buffEvent[devEventIndex][3] = 1.0
            # 减少权重
            if buffEvent[devEventIndex][3] >= 0.1:
                buffEvent[devEventIndex][3] -= 0.1
            else:
                buffEvent[devEventIndex][3] = 0
                
    elif devEventCategory == 1:
        if len(debuffEvent) > 0:
            if len(debuffEvent[devEventIndex]) < 4:
                debuffEvent[devEventIndex][3] = 1.0
            if debuffEvent[devEventIndex][3] >= 0.1:
                debuffEvent[devEventIndex][3] -= 0.1
            else:
                debuffEvent[devEventIndex][3] = 0

    elif devEventCategory == 2:
        if len(mechEvent) > 0:
            if len(mechEvent[devEventIndex]) < 4:
                mechEvent[devEventIndex][3] = 1.0
            if mechEvent[devEventIndex][3] >= 0.1:
                mechEvent[devEventIndex][3] -= 0.1
            else:
                mechEvent[devEventIndex][3] = 0
                
    wait(0.1)


rule "[debug.opy]: player debug (Top Right)":
    @Event eachPlayer
    @Condition evalOnce(eventPlayer.debugInfo) == true
    @Condition eventPlayer.isDev == true
    
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "难度 = {0}".format(difficultyText[0]), HudPosition.RIGHT, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "当前位置 = {0}".format(eventPlayer.getEyePosition()), HudPosition.RIGHT, 26, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "当前速度 = {0}".format(eventPlayer.getSpeed()), HudPosition.RIGHT, 27, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "当前速率 = {0}".format(eventPlayer.getVelocity()), HudPosition.RIGHT, 28, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "当前地图 = {0}/{1}".format(__currentMap___, getCurrentMap()), HudPosition.RIGHT, 29, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "重生室位置 = {0}".format(getSpawnPoints(Team.1).getPosition()), HudPosition.RIGHT, 30, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    #hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "重生室距离 X = {0}/{1}/{2}".format(eventPlayer.getPosition().x, controlRespawnPosition[0].x, distance(vect(eventPlayer.getPosition().x, 0, 0), vect(controlRespawnPosition[0].y, 0, 0))), HudPosition.RIGHT, 31, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    #hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "重生室距离 Y = {0}/{1}/{2}".format(eventPlayer.getPosition().y, controlRespawnPosition[0].y, distance(vect(0, eventPlayer.getPosition().y, 0), vect(0, controlRespawnPosition[0].y, 0))), HudPosition.RIGHT, 32, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    #hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "重生室距离 Z = {0}/{1}/{2}".format(eventPlayer.getPosition().z, controlRespawnPosition[0].z, distance(vect(0, 0, eventPlayer.getPosition().z), vect(0, 0, controlRespawnPosition[0].z))), HudPosition.RIGHT, 33, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "当前事件 = {0}/{1}".format(localPlayer.eventName, localPlayer.eventId), HudPosition.RIGHT, 34, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "最近事件Key(type*{0}+id) = {1}".format(EVT_DEDUP_TYPE_MULTIPLIER, localPlayer.eventLastId), HudPosition.RIGHT, 34, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(eventPlayer if eventPlayer.debugInfo == true else null, "重生室索引 = {0}".format(localPlayer.controlJumpIndex), HudPosition.RIGHT, 34, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

