#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setDifficulty

def setDifficulty():
    @Name "initialize difficulty effects text"
    
    wait(getAverageServerLoad() / 100)
    difficultyText[0] = ["简单", "一般", "困难", "专家", "传奇", "地狱"][difficulty]
    difficultyText[1] = [
        Color.GREEN,
        Color.LIME_GREEN,
        Color.YELLOW,
        Color.ORANGE,
        Color.RED,
        rgb(118, 93, 189)
    ][difficulty]
