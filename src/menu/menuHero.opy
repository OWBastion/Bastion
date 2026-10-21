#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

rule "Display hero page":
    @Event eachPlayer
    @Condition (controlRespawnPosition == null or eventPlayer.isWinner or len(controlRespawnPosition) < 3) == true
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

rule "Cycle hero selection":
    @Event eachPlayer
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

rule "Apply hero selection":
    @Event eachPlayer
    @Condition (controlRespawnPosition == null or eventPlayer.isWinner or len(controlRespawnPosition) < 3) == true
    @Condition (eventPlayer.menu == 2 and eventPlayer.isDev == false) or (eventPlayer.menu == 5 and eventPlayer.isDev == true)
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition (eventPlayer.isInSpawnRoom() and eventPlayer.isMoving() != true) == true

    eventPlayer.eventCompatibleBasePool = null
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
    refreshCompatibleEventPool()
    waitUntil(eventPlayer.isHoldingButton(Button.RELOAD) == false, 99999)
