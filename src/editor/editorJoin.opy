#!mainFile "../editorMain.opy"

#!optimizeStrict
#!rulePrefix "Editor"

rule "Initialize editor player":
    @Event playerJoined
    @Team 1

    eventPlayer.editorMode = 0
    eventPlayer.editorTool = 0
    eventPlayer.editorSelectedIndex = -1
