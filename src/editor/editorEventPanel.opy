#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

#!define EDITOR_EVENT_EXTEND_SECONDS 30
#!define EDITOR_EVENT_INFINITE_SECONDS 99999

# 面板只列出当前英雄事件池里的事件，先选分类再选事件。
macro Player.editorEventChoices():
    self.eventCompatibleBasePool.filter(lambda candidateIndex: eventCatalogType[candidateIndex] == self.editorEventCategory)


rule "Reset event choice when pool changes":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventCompatibleBasePool != null
    @Condition eventPlayer.editorEventId not in eventPlayer.eventCompatibleBasePool

    eventPlayer.editorEventCategory = EventType.BUFF
    eventPlayer.editorEventIndex = 0
    eventPlayer.editorEventId = eventPlayer.editorEventChoices()[0]


rule "Toggle automatic event":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 2
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    eventPlayer.editorAutoEvent = not eventPlayer.editorAutoEvent


rule "Cycle event category":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    eventPlayer.editorEventCategory = (eventPlayer.editorEventCategory + 1) % 3
    eventPlayer.editorEventIndex = 0
    eventPlayer.editorEventId = eventPlayer.editorEventChoices()[0] if len(eventPlayer.editorEventChoices()) > 0 else -1


rule "Cycle event selection":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 1
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_2)
    @Condition len(eventPlayer.editorEventChoices()) > 0

    eventPlayer.editorEventIndex = (eventPlayer.editorEventIndex + 1) % len(eventPlayer.editorEventChoices())
    eventPlayer.editorEventId = eventPlayer.editorEventChoices()[eventPlayer.editorEventIndex]


# 立即触发：写入 eventNextIndex 后调用 setPlayerEvent()；事件结束由 "Clear ended event" 清理。
rule "Trigger selected event":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 1
    @Condition eventPlayer.editorEventId != -1
    @Condition eventPlayer.eventAssigning != true
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    if eventPlayer.eventId != -1:
        clearPlayerEvent()
    eventPlayer.eventNextIndex = eventPlayer.editorEventId
    setPlayerEvent()


rule "End event now":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 1
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)

    requestPlayerEventEnd()


# 瞬时事件（时长 0）没有可延长的时间。
rule "Extend event":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 1
    @Condition eventPlayer.eventId != -1
    @Condition eventDuration[eventPlayer.eventId] > 0
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE)

    eventPlayer.eventEndTime += EDITOR_EVENT_EXTEND_SECONDS


rule "Extend event without limit":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.editorMode == 1
    @Condition eventPlayer.editorPanelPage == 2
    @Condition eventPlayer.eventId != -1
    @Condition eventDuration[eventPlayer.eventId] > 0
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    eventPlayer.eventEndTime = getTotalTimeElapsed() + EDITOR_EVENT_INFINITE_SECONDS
