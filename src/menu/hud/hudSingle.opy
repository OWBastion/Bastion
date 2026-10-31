#!mainFile "../../main.opy"

#!optimizeStrict
#!rulePrefix "Menu"

rule "Create menu HUD":
    hudSubheader(localPlayer if localPlayer.menu != 0 else null, MENU_HUD_PAD_TOP, HudPosition.LEFT, MENU_HUD_SORT_PAD, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudText(localPlayer if localPlayer.menu != 0 else null, MENU_TITLE(localPlayer), MENU_BODY(localPlayer), null, HudPosition.LEFT, MENU_HUD_SORT_TITLE, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
