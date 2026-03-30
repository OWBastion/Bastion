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
    #寺庙重生点
    controlRespawnPosition = vect(-426.04, 11.11, 165.81)
    #寺庙-城区 传送点
    controlJumpPosition = vect(-248.55, 10.35, 152.77)
    resetPosition = vect(-409.71, 10.11, 165.61)
    thirdPersonPosition = vect(-410.4, 10.11, 162.37)
    creditsPosition = vect(-426.04, 13.11, 165.81)
    #城区城区重生点
    controlRespawnPosition.append(vect(-30.95, 17, -125.55))
    #城区-meka基地 传送点
    controlJumpPosition.append(vect(104.77, 17.74, -137.21))
    #meka基地重生点
    controlRespawnPosition.append(vect(291.62, 11.09, 208.25))
    endPosition = vect(158.67, 10.81, 260.91)
    #堡垒点位  寺院
    bastionPosition = vect(-327.44, 17.73, 166.8)
    bastionPosition.append(vect(-328.51, 15.08, 140.81))
    bastionPosition.append(vect(-277.4, 11.13, 144.4))
    bastionPosition.append(vect(-379.43, 11.13, 144.41))
    #堡垒点位 城区
    bastionPosition.append(vect(22.02, 13.86, -121.16))
    bastionPosition.append(vect(51.84, 13.48, -97.4))
    bastionPosition.append(vect(80.67, 20, -106.93))
    bastionPosition.append(vect(111.43, 18.54, -169.79))
    #堡垒点位  meka基地
    bastionPosition.append(vect(268.37, 15.09, 205.62))
    bastionPosition.append(vect(249.27, 14.29, 236.1))
    bastionPosition.append(vect(228.22, 10.09, 231.08))
    bastionPosition.append(vect(200.31, 19.43, 223.76))
    bastionPosition.append(vect(177.1, 9.69, 253.19))
    bastionPosition.append(vect(173.93, 12.87, 267.78))
    controlCenterPosition = [vect(-328.53, 8.17, 153.32), vect(51.89, 14.5, -114.7), vect(222.72, 9.24, 241.77)]

    mapTitlePlayersByKey = [
        DATA_BUSAN[0].split("-"),
        DATA_BUSAN[1].split("-"),
        DATA_BUSAN[2].split("-")
    ]
