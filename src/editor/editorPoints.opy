#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

subroutine rebuildEditorMarkers
subroutine refreshEditorOutlines

# 标记只在点位变更时整体重建；创建参数在创建时求值，不逐帧更新。
def rebuildEditorMarkers():
    @Name "rebuild point markers"

    for editorLoopIndex in range(len(editorMarkerTexts)):
        destroyInWorldText(editorMarkerTexts[editorLoopIndex])
        destroyIcon(editorMarkerIcons[editorLoopIndex])
    editorMarkerTexts = []
    editorMarkerIcons = []
    for editorLoopIndex in range(len(bastionPosition)):
        createInWorldText(getAllPlayers(), "{0}".format(editorLoopIndex + 1), bastionPosition[editorLoopIndex] + Vector.UP * 3.2, 1.5, Clip.NONE, WorldTextReeval.VISIBILITY, Color.RED)
        editorMarkerTexts.append(getLastCreatedText())
        createIcon(getAllPlayers(), bastionPosition[editorLoopIndex] + Vector.UP * 2.6, Icon.SKULL, IconReeval.VISIBILITY, Color.RED)
        editorMarkerIcons.append(getLastCreatedEntity())
    if resetPosition != null:
        createInWorldText(getAllPlayers(), STR_EDITOR_TOOL_RESET, resetPosition + Vector.UP * 1.6, 1.2, Clip.NONE, WorldTextReeval.VISIBILITY, Color.GREEN)
        editorMarkerTexts.append(getLastCreatedText())
        createIcon(getAllPlayers(), resetPosition + Vector.UP * 1, Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.GREEN)
        editorMarkerIcons.append(getLastCreatedEntity())
    if endPosition != null:
        createInWorldText(getAllPlayers(), STR_EDITOR_TOOL_END, endPosition + Vector.UP * 5.6, 1.2, Clip.NONE, WorldTextReeval.VISIBILITY, Color.BLUE)
        editorMarkerTexts.append(getLastCreatedText())
        createIcon(getAllPlayers(), endPosition + Vector.UP * 5, Icon.FLAG, IconReeval.VISIBILITY, Color.BLUE)
        editorMarkerIcons.append(getLastCreatedEntity())
    if thirdPersonPosition != null:
        createInWorldText(getAllPlayers(), STR_EDITOR_TOOL_THIRD_PERSON, thirdPersonPosition + Vector.UP * 1.6, 1.2, Clip.NONE, WorldTextReeval.VISIBILITY, Color.PURPLE)
        editorMarkerTexts.append(getLastCreatedText())
        createIcon(getAllPlayers(), thirdPersonPosition + Vector.UP * 1, Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.PURPLE)
        editorMarkerIcons.append(getLastCreatedEntity())
    if creditsPosition != null:
        createInWorldText(getAllPlayers(), STR_EDITOR_TOOL_CREDITS, creditsPosition + Vector.UP * 1.6, 1.2, Clip.NONE, WorldTextReeval.VISIBILITY, Color.YELLOW)
        editorMarkerTexts.append(getLastCreatedText())
        createIcon(getAllPlayers(), creditsPosition + Vector.UP * 1, Icon.ARROW_DOWN, IconReeval.VISIBILITY, Color.YELLOW)
        editorMarkerIcons.append(getLastCreatedEntity())

# 选中的堡垒只对选中者描边。
def refreshEditorOutlines():
    @Name "refresh selected bastion outline"

    getPlayers(Team.2).stopForcingOutlineFor(eventPlayer)
    if eventPlayer.editorSelectedIndex != -1:
        getPlayers(Team.2).filter(lambda bastion: bastion.getSlot() == eventPlayer.editorSelectedIndex).startForcingOutlineFor(eventPlayer, true, Color.YELLOW, OutlineVisibility.ALWAYS)


# 分段地图规则在首个队伍 1 玩家出生后覆盖点位；等其写完再重建标记。
rule "Build point markers after map setup":
    @Condition getPlayers(Team.1).any(lambda player: player.hasSpawned())

    wait(1)
    rebuildEditorMarkers()
