#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 漓江塔":
    @Condition (__currentMap___ == Map.LIJIANG_TOWER or __currentMap___ == 3676) == true
    
    __currentMapText___ = "漓江塔"
    __currentMapPioneerText___ = __currentMapText___
    #0 = X轴 1 = Y轴 2 = Z轴
    controlRespawnAxis = 1
    #距离阈值
    controlRespawnAxisThreshold = 40
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    #夜市
    bastionPosition = vect(34.55, 33.85, -36.64)
    bastionPosition.append(vect(21.25, 10, -23.95))
    bastionPosition.append(vect(0.93, 0, -9.84))
    bastionPosition.append(vect(3.65, 8.01, -52.48))
    bastionPosition.append(vect(-30.81, 25.99, -14.77))
    #夜市重生点
    controlRespawnPosition = vect(84.41, 4.52, -31.57)
    #夜市-庭院 传送点
    controlJumpPosition = vect(-58.26, 6, -5.24)
    resetPosition = vect(81.11, 4.58, -35.44)
    thirdPersonPosition = vect(74.43, 4.46, -26.34)
    creditsPosition = vect(84.29, 6.2, -29.44)
    #庭院
    bastionPosition.append(vect(41.48, 95.87, 140.62))
    bastionPosition.append(vect(-0.08, 94, 184.97))
    bastionPosition.append(vect(-16.66, 96.5, 120.91))
    bastionPosition.append(vect(-66.07, 94, 150.2))
    #庭院重生点
    controlRespawnPosition.append(vect(86.21, 96.62, 147.7))
    #庭院-控制中心 传送点
    controlJumpPosition.append(vect(-51.89, 95, 133.97))
    #控制中心
    bastionPosition.append(vect(46.34, 267, 300.86))
    bastionPosition.append(vect(-10.14, 270.12, 321.4))
    bastionPosition.append(vect(-0.2, 278.01, 290.98))
    bastionPosition.append(vect(2.79, 274.19, 301.82))
    bastionPosition.append(vect(-46.63, 267.11, 300.97))
    #控制中心重生点
    controlRespawnPosition.append(vect(62.93, 267.64, 349.53))
    endPosition = vect(-44.02, 271.64, 349.77)

    mapTitlePlayersByKey = [
        DATA_LIJIANG_TOWER[0],
        DATA_LIJIANG_TOWER[1].split("-"),
        DATA_LIJIANG_TOWER[2].split("-")
    ]
