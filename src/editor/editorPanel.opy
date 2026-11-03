#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

subroutine openEditorPanel
subroutine closeEditorPanel

# 面板打开时所有英雄按键只用于面板，按下状态仍由规则读取。
def openEditorPanel():
    @Name "open trial panel"

    eventPlayer.editorPanelPage = 1
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.disallowButton(Button.RELOAD)
    eventPlayer.disallowButton(Button.JUMP)
    eventPlayer.disallowButton(Button.CROUCH)

def closeEditorPanel():
    @Name "close trial panel"

    eventPlayer.editorPanelPage = 0
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)
    eventPlayer.allowButton(Button.RELOAD)
    eventPlayer.allowButton(Button.JUMP)
    eventPlayer.allowButton(Button.CROUCH)


rule "Toggle trial panel":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    if eventPlayer.editorPanelPage != 0:
        closeEditorPanel()
    else:
        openEditorPanel()


rule "Switch trial panel page":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage != 0
    @Condition eventPlayer.isHoldingButton(Button.CROUCH)

    eventPlayer.editorPanelPage = 1 if eventPlayer.editorPanelPage == 2 else 2


rule "Return to edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 2
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    closeEditorPanel()
    eventPlayer.editorMode = 0
