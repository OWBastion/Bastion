#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

#!define EDITOR_AUTO_EVENT_DELAY 10

# 编辑器自己的分配规则：只在试跑模式且自动事件开启时分配，不依赖进度与堡垒数量。
rule "Allocate automatic event":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorAutoEvent == true
    @Condition all([vishkarEventActivated, eventPlayer.hasSpawned(), eventPlayer.eventId == -1]) == true
    @Condition eventPlayer.eventCompatibleBasePool != null
    @Condition PROFILE_EVENT_PLAYER_ELIGIBLE(eventPlayer)

    wait(EDITOR_AUTO_EVENT_DELAY, Wait.ABORT_WHEN_FALSE)
    wait(getAverageServerLoad() * 0.00032)
    setPlayerEvent()
    waitUntil(eventPlayer.eventId == -1 or eventPlayer.eventEndTime <= getTotalTimeElapsed(), Math.INFINITY)
    wait(getAverageServerLoad() * 0.00032)
    if eventPlayer.eventId != -1 and eventPlayer.eventEndTime <= getTotalTimeElapsed():
        clearPlayerEvent()
    wait(getAverageServerLoad() * 0.00032)
    if ruleCondition:
        loop()
