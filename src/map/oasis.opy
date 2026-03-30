#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 绿洲城":
    @Condition __currentMap___ == Map.OASIS
    
    #0 = X轴 1 = Y轴 2 = Z轴
    controlRespawnAxis = 2
    #距离阈值
    controlRespawnAxisThreshold = 40
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    #花园重生点
    controlRespawnPosition = vect(200.46, 6.42, -188.28)
    #花园-大学 传送点
    controlJumpPosition = vect(82.13, 5.49, -273.2)
    resetPosition = vect(193.61, 8.42, -197.03)
    thirdPersonPosition = vect(191.33, 8.42, -194.73)
    creditsPosition = vect(204.41, 8.42, -184.71)
    #大学重生点
    controlRespawnPosition.append(vect(-195.03, 20, 89.71))
    #大学-中心  传送点
    controlJumpPosition.append(vect(-175.4, 16, -61.35))
    #中心重生点
    controlRespawnPosition.append(vect(69.73, 1, 321.16))
    endPosition = vect(195.13, 0.85, 172.87)
    #堡垒点位  花园
    bastionPosition = vect(170.7, 13.57, -216.17)
    bastionPosition.append(vect(123.6, 12, -229.92))
    bastionPosition.append(vect(78.92, 10, -253.17))
    bastionPosition.append(vect(111.34, 13.57, -278.41))
    #堡垒点位 大学
    bastionPosition.append(vect(-196.79, 21.65, 56.69))
    bastionPosition.append(vect(-202.91, 9.12, -0.1))
    bastionPosition.append(vect(-177.5, 20.25, 0.19))
    bastionPosition.append(vect(-183.17, 20.06, -61.79))
    #堡垒点位  中心
    bastionPosition.append(vect(110.54, 2, 283.01))
    bastionPosition.append(vect(140.16, 10, 250.39))
    bastionPosition.append(vect(171.91, 4.12, 277))
    bastionPosition.append(vect(150.98, 3.85, 223.89))
    bastionPosition.append(vect(173.51, 2, 217.63))
    controlCenterPosition = [vect(129.5, 15.28, -235.74), vect(-192.08, 15, 0.26), vect(143.44, 2.15, 247.95)]

    mapTitlePlayersByKey = [
        DATA_OASIS[0].split("-"),
        DATA_OASIS[1].split("-"),
        DATA_OASIS[2].split("-")
    ]
