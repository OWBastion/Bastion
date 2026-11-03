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
        HudPosition.LEFT, 12, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_KEYS_TOOL.format(inputBindingString(Button.ABILITY_1), inputBindingString(Button.ABILITY_2), inputBindingString(Button.ULTIMATE)),
        HudPosition.LEFT, 13, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 0 else null,
        STR_EDITOR_HUD_EDIT_KEYS_MOVE.format(inputBindingString(Button.JUMP), inputBindingString(Button.CROUCH), inputBindingString(Button.RELOAD)),
        HudPosition.LEFT, 14, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudHeader(
        localPlayer if localPlayer.editorMode == 1 else null,
        STR_EDITOR_HUD_TRIAL_TITLE,
        HudPosition.LEFT, 10, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 1 else null,
        STR_EDITOR_HUD_TRIAL_TIME.format(hhmmss(getTotalTimeElapsed() - localPlayer.editorTrialStart)),
        HudPosition.LEFT, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorMode == 1 and localPlayer.editorPanelPage == 0 else null,
        STR_EDITOR_HUD_TRIAL_HINT.format(inputBindingString(Button.INTERACT), inputBindingString(Button.MELEE), inputBindingString(Button.RELOAD)),
        HudPosition.LEFT, 12, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudHeader(
        localPlayer if localPlayer.editorPanelPage != 0 else null,
        STR_EDITOR_PANEL_TITLE.format(inputBindingString(Button.INTERACT), inputBindingString(Button.MELEE)),
        HudPosition.LEFT, 20, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage == 1 else null,
        STR_EDITOR_PANEL_AUTO.format(inputBindingString(Button.PRIMARY_FIRE), STR_MENU_STATE_ON if localPlayer.editorAutoEvent else STR_MENU_STATE_OFF),
        HudPosition.LEFT, 21, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage == 1 else null,
        STR_EDITOR_PANEL_CATEGORY.format(inputBindingString(Button.ABILITY_1), [STR_CAT_BUFF, STR_CAT_DEBUFF, STR_CAT_MECH][localPlayer.editorEventCategory]),
        HudPosition.LEFT, 22, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage == 1 else null,
        STR_EDITOR_PANEL_EVENT.format(inputBindingString(Button.ABILITY_2), eventName[localPlayer.editorEventId] if localPlayer.editorEventId != -1 else STR_EDITOR_HUD_NONE),
        HudPosition.LEFT, 23, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage == 1 else null,
        STR_EDITOR_PANEL_TRIGGER.format(inputBindingString(Button.ULTIMATE), inputBindingString(Button.SECONDARY_FIRE)),
        HudPosition.LEFT, 24, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage == 1 else null,
        STR_EDITOR_PANEL_EXTEND.format(inputBindingString(Button.RELOAD), inputBindingString(Button.JUMP)),
        HudPosition.LEFT, 25, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage == 2 else null,
        STR_EDITOR_PANEL_FIRE.format(inputBindingString(Button.PRIMARY_FIRE), [STR_EDITOR_FIRE_MODE_FIRE, STR_EDITOR_FIRE_MODE_AIM, STR_EDITOR_FIRE_MODE_OFF][editorFireMode]),
        HudPosition.LEFT, 21, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    hudSubheader(
        localPlayer if localPlayer.editorPanelPage != 0 else null,
        STR_MENU_OPT_NEXT_PAGE.format(inputBindingString(Button.CROUCH)),
        HudPosition.LEFT, 26, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
