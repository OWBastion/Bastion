#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[DevTool] ..." 前缀不变
#!rulePrefix "DevTool"

# 选择索引按已解锁英雄数取模；控制点重生阶段且未通关时页面留空
#!define MENU_HERO_INDEX(viewer) viewer.menuHeroIndex % (((len(heroList) - 1) if viewer.heroNumber > (len(heroList) - 1) else viewer.heroNumber) + 1)
#!define MENU_HERO_AVAILABLE(viewer) (not controlRespawnPosition or viewer.isWinner or len(controlRespawnPosition) < 3)
#!define MENU_HERO_TITLE(viewer) (STR_MENU_OPT_HERO_PAGE_TITLE if MENU_HERO_AVAILABLE(viewer) else null)
#!define MENU_HERO_BODY(viewer) (STR_MENU_OPT_HERO_NEXT.format(inputBindingString(Button.PRIMARY_FIRE), heroList[MENU_HERO_INDEX(viewer)], STR_MENU_OPT_HERO_APPLY.format(inputBindingString(Button.RELOAD), "")) if MENU_HERO_AVAILABLE(viewer) else null)

rule "Cycle hero selection":
    @Event eachPlayer
    @Condition eventPlayer.menu == MENU_PAGE_HERO
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.menuHeroIndex += 1
    eventPlayer.menuHeroIndex = eventPlayer.menuHeroIndex % (
        (
            (len(heroList) - 1) if (eventPlayer.heroNumber) > (len(heroList) - 1)
            else (eventPlayer.heroNumber)
        ) + 1
    )
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 99999)

rule "Apply hero selection":
    @Event eachPlayer
    @Condition not controlRespawnPosition or eventPlayer.isWinner or len(controlRespawnPosition) < 3
    @Condition eventPlayer.menu == MENU_PAGE_HERO
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)
    @Condition eventPlayer.isInSpawnRoom() and not eventPlayer.isMoving()

    eventPlayer.eventCompatibleBasePool = null
    eventPlayer.menuHeroIndex = eventPlayer.menuHeroIndex % (
        (
            (len(heroList) - 1) if (eventPlayer.heroNumber) > (len(heroList) - 1)
            else (eventPlayer.heroNumber)
        ) + 1
    )
    eventPlayer.startForcingHero(heroList[eventPlayer.menuHeroIndex])
    waitHeroMatch()
    eventPlayer.stopForcingCurrentHero()
    wait(getServerLoad() * 0.005)
    eventPlayer.setAllowedHeroes(heroList.slice(0, eventPlayer.heroNumber + 1))
    refreshCompatibleEventPool()
    waitUntil(not eventPlayer.isHoldingButton(Button.RELOAD), 99999)
