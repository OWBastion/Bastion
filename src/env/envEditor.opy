#!mainFile "../editorMain.opy"

# 编辑器需要 Inspector 与较短的事件初始化等待，因此恒为 debug。
macro DEBUG = true

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!optimizeForSize

#!define VERSION "26.editor"

#!define HUD_PAD_BOTTOM "\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r"
