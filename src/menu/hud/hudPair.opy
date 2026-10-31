#!mainFile "../../main.opy"

#!optimizeStrict
#!rulePrefix "Menu"

rule "Create menu HUD":
    hudSubheader(localPlayer if localPlayer.menu != 0 else null, MENU_HUD_PAD_TOP, HudPosition.LEFT, MENU_HUD_SORT_PAD, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudHeader(localPlayer if localPlayer.menu != 0 else null, MENU_TITLE(localPlayer), HudPosition.LEFT, MENU_HUD_SORT_TITLE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubheader(localPlayer if localPlayer.menu != 0 else null, MENU_BODY(localPlayer), HudPosition.LEFT, MENU_HUD_SORT_BODY, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
