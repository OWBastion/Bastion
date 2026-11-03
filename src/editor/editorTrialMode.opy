#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

#!define EDITOR_RETURN_HOLD_SECONDS 1

rule "Start trial mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 0
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    eventPlayer.editorMode = 1
    eventPlayer.editorSelectedIndex = -1
    refreshEditorOutlines()
    leaveEditorEditMode()
    updatePlayerStats()
    eventPlayer.teleport(resetPosition)
    eventPlayer.editorTrialStart = getTotalTimeElapsed()


# 试跑时装填键仍用于换弹，所以要长按才返回；松开后才切换，避免 "Start trial mode" 被仍按着的装填键立即再次触发。
rule "Return to edit mode":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 0
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    wait(EDITOR_RETURN_HOLD_SECONDS, Wait.ABORT_WHEN_FALSE)
    waitUntil(not eventPlayer.isHoldingButton(Button.RELOAD), 99999)
    eventPlayer.editorMode = 0


# 编辑器结算：显示用时并回到重置点；不涉及进度、存档与 isWinner。
rule "Finish trial":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.getPosition().y >= endPosition.y
    @Condition distance(eventPlayer.getPosition() * vect(1, 0, 1), endPosition * vect(1, 0, 1)) <= 4

    bigMessage(eventPlayer, STR_EDITOR_MSG_FINISH.format(hhmmss(getTotalTimeElapsed() - eventPlayer.editorTrialStart)))
    eventPlayer.teleport(resetPosition)
    eventPlayer.editorTrialStart = getTotalTimeElapsed()
