#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine setPlayerSize

def setPlayerSize():
    @Name "子程序：设置玩家大小"
    
    eventPlayer.startScalingSize(1 + eventPlayer.eventSize, false)