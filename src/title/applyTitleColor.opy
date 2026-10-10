#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine applyTitleColor

def applyTitleColor():
    @Name "apply title color"

    # 记录换色起点：称号色在文本重估表达式中按 (已运行时间 - titleCycleT0) 往返插值
    eventPlayer.titleCycleT0 = getTotalTimeElapsed()
    eventPlayer.titleCycleAB = titleColor[eventPlayer.playerTitleAndColor]
    if eventPlayer.titleCycleAB == null:
        # 无自带色称号：dev 用彩虹两端点往返，非 dev 用静态红（与原 rgbList[0] 一致）
        eventPlayer.titleCycleAB = [rgbList[0], rgbList[6]] if eventPlayer.isDev else [rgbList[0], rgbList[0]]
    # 统一转为 [起点 A, 位移 B−A]：[v] 单色得零位移；[A, B] 端点板得呼吸位移
    eventPlayer.titleCycleAB = [
        eventPlayer.titleCycleAB[0],
        eventPlayer.titleCycleAB[len(eventPlayer.titleCycleAB) - 1] - eventPlayer.titleCycleAB[0]]
