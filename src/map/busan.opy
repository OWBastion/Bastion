#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 釜山":
    @Condition __currentMap___ == Map.BUSAN
    
    #0 = X轴 1 = Y轴 2 = Z轴
    controlRespawnAxis = 0
    #距离阈值
    controlRespawnAxisThreshold = 40
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    masteryRunCode = ""
