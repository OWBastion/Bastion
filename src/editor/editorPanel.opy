#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

subroutine openEditorPanel
subroutine closeEditorPanel

# 面板只占用没有事件、英雄或地图规则读取的按键（主副武器、技能、终极、近战）。
# 装填、跳跃、蹲、互动留给事件与地图互动；禁用按键不影响规则读取按下状态。
def openEditorPanel():
    @Name "open trial panel"

    eventPlayer.editorPanelPage = 1
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)

def closeEditorPanel():
    @Name "close trial panel"

    eventPlayer.editorPanelPage = 0
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.allowButton(Button.SECONDARY_FIRE)
    eventPlayer.allowButton(Button.ABILITY_1)
    eventPlayer.allowButton(Button.ABILITY_2)
    eventPlayer.allowButton(Button.ULTIMATE)
    eventPlayer.allowButton(Button.MELEE)


rule "Toggle trial panel":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.MELEE)

    # 松开组合键后再切换，避免近战翻页规则被仍按着的近战键立即触发。
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT) and not eventPlayer.isHoldingButton(Button.MELEE), 99999)
    if eventPlayer.editorPanelPage != 0:
        closeEditorPanel()
    else:
        openEditorPanel()


rule "Switch trial panel page":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage != 0
    @Condition eventPlayer.isHoldingButton(Button.MELEE)
    @Condition not eventPlayer.isHoldingButton(Button.INTERACT)

    eventPlayer.editorPanelPage = 1 if eventPlayer.editorPanelPage == 2 else 2


# 先等松开终极键：过早解除禁用会放出英雄大招，过早切模式会触发编辑模式的“传送到选中点”。
rule "Return to edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 2
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    waitUntil(not eventPlayer.isHoldingButton(Button.ULTIMATE), 99999)
    closeEditorPanel()
    eventPlayer.editorMode = 0
