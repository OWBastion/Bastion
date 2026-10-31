#!mainFile "../../main.opy"

#!optimizeStrict
#!rulePrefix "Menu"

rule "Show menu HUD":
    @Event eachPlayer
    @Condition eventPlayer.menu != 0

    hudSubheader(eventPlayer, MENU_HUD_PAD_TOP, HudPosition.LEFT, MENU_HUD_SORT_PAD, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[2] = getLastCreatedText()
    hudHeader(eventPlayer, MENU_TITLE(eventPlayer), HudPosition.LEFT, MENU_HUD_SORT_TITLE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[0] = getLastCreatedText()
    hudSubheader(eventPlayer, MENU_BODY(eventPlayer), HudPosition.LEFT, MENU_HUD_SORT_BODY, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    eventPlayer.menuTextID[1] = getLastCreatedText()


rule "Hide menu HUD":
    @Event eachPlayer
    @Condition eventPlayer.menu == 0

    destroyHudText(eventPlayer.menuTextID[0])
    destroyHudText(eventPlayer.menuTextID[1])
    destroyHudText(eventPlayer.menuTextID[2])
