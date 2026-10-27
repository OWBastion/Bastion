#!mainFile "../main.opy"

#!optimizeStrict

rule "Initialize CN title effects":
    # 成就禁用
    hudSubheader(null if hashTag or localPlayer.settlementCardEnd != null else localPlayer, STR_HUD_ACHIEVEMENT_DISABLED.format(iconString(Icon.WARNING)), HudPosition.LEFT, 7, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
