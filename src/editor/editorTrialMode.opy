#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

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
