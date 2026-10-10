#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine applyTitleColor

def applyTitleColor():
    @Name "apply title color"

    # 记录换色起点：称号色在文本重估表达式中按 (已运行时间 - titleCycleT0) 查表
    eventPlayer.titleCycleT0 = getTotalTimeElapsed()
    eventPlayer.titleCycleStops = titleColor[eventPlayer.playerTitleAndColor]
    if eventPlayer.titleCycleStops == null:
        # 无自带色称号：dev 用彩虹循环板，非 dev 用静态红（与原 rgbList[0] 一致）
        eventPlayer.titleCycleStops = rgbList if eventPlayer.isDev else [rgbList[0]]
