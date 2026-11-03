#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

rule "Initialize editor HUD":
    wait(1)

    hudHeader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_TITLE,
        HudPosition.LEFT, 10, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_STATE.format(
            [STR_EDITOR_TOOL_BASTION, STR_EDITOR_TOOL_RESET, STR_EDITOR_TOOL_END, STR_EDITOR_TOOL_THIRD_PERSON, STR_EDITOR_TOOL_CREDITS][localPlayer.editorTool],
            len(bastionPosition),
            "#{0}".format(localPlayer.editorSelectedIndex + 1) if localPlayer.editorSelectedIndex != -1 else STR_EDITOR_HUD_NONE
        ),
        HudPosition.LEFT, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_KEYS_PLACE.format(inputBindingString(Button.PRIMARY_FIRE), inputBindingString(Button.SECONDARY_FIRE), inputBindingString(Button.MELEE)),
        HudPosition.LEFT, 12, rgb(160, 169, 186), HudReeval.VISIBILITY, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_KEYS_TOOL.format(inputBindingString(Button.ABILITY_1), inputBindingString(Button.ABILITY_2), inputBindingString(Button.ULTIMATE)),
        HudPosition.LEFT, 13, rgb(160, 169, 186), HudReeval.VISIBILITY, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_KEYS_MOVE.format(inputBindingString(Button.JUMP), inputBindingString(Button.CROUCH)),
        HudPosition.LEFT, 14, rgb(160, 169, 186), HudReeval.VISIBILITY, SpecVisibility.NEVER
    )
