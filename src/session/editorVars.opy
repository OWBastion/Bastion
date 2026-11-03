#!mainFile "../editorMain.opy"

# 堡垒开火模式：0 开火，1 仅瞄准，2 关闭
globalvar editorFireMode
globalvar editorMarkerIcons
globalvar editorMarkerTexts
globalvar editorLoopIndex

# 0 编辑模式，1 试跑模式
playervar editorMode
# 0 堡垒，1 重置点，2 终点，3 第三人称点，4 结算点
playervar editorTool
# 选中的堡垒下标，-1 表示未选中
playervar editorSelectedIndex
playervar editorCandidates
playervar editorCandidateIndex
playervar editorHero
# 试跑开始时刻
playervar editorTrialStart
# 试跑面板页：0 关闭
playervar editorPanelPage
# 自动事件开关
playervar editorAutoEvent
# 面板选中的事件：分类（EventType）、分类内下标、事件 ID（-1 无）
playervar editorEventCategory
playervar editorEventIndex
playervar editorEventId
playervar editorBeam
