#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 萨摩亚":
    @Condition (__currentMap___ == Map.SAMOA or __currentMap___ == 13628) == true
    
    #0 = X轴 1 = Y轴 2 = Z轴
    controlRespawnAxis = 0
    #距离阈值
    controlRespawnAxisThreshold = 40
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    #海滩海滩重生点
    controlRespawnPosition = vect(-428, 10.5, -109)
    #海滩-城区 传送点
    controlJumpPosition = vect(-256.82, 14.85, -94.9)
    resetPosition = vect(-430.71, 10.3, -105.96)
    thirdPersonPosition = vect(-425.32, 10.23, -116.48)
    creditsPosition = vect(-436.16, 12.2, -111.37)
    #城区城区重生点
    controlRespawnPosition.append(vect(330.12, 14.64, -216.31))
    #城区-控制中心 传送点
    controlJumpPosition.append(vect(177.52, 12.3, -239.3))
    #火山火山重生点
    controlRespawnPosition.append(vect(107.83, 343, 415.6))
    endPosition = vect(-29.3, 340.56, 410.76)
    #堡垒点位  沙滩
    bastionPosition = vect(-408.95, 14.4, -84.76)
    bastionPosition.append(vect(-384.05, 12.05, -86.88))
    bastionPosition.append(vect(-330.08, 10.01, -98.04))
    bastionPosition.append(vect(-276.43, 11.02, -89.16))
    #堡垒点位 城区
    bastionPosition.append(vect(307.13, 18.61, -206.17))
    bastionPosition.append(vect(231.6, 16.28, -270.76))
    bastionPosition.append(vect(233.69, 9, -229.7))
    bastionPosition.append(vect(170.96, 12.56, -242.33))
    #堡垒点位 火山
    bastionPosition.append(vect(97.68, 340.63, 397.23))
    bastionPosition.append(vect(46.64, 345.49, 387.04))
    bastionPosition.append(vect(26.69, 341.63, 376.43))
    bastionPosition.append(vect(27.74, 360.5, 356.07))
    bastionPosition.append(vect(0.96, 346.65, 390.11))
    bastionPosition.append(vect(-4.4, 353.05, 407.42))

    mapTitlePlayersByKey = [
        DATA_SAMOA[0],
        DATA_SAMOA[1].split("-"),
        DATA_SAMOA[2].split("-")
    ]
