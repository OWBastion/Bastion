#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 伊利奥斯":
    @Condition __currentMap___ == Map.ILIOS
    
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    #made by 他又
    #深井
    if len(getPlayersInRadius(vect(-152.014, -1.104, -93.12), 30, Team.1)) != 0:
        bastionPosition[0] = vect(-173.701, -0.46, -71.552)
        bastionPosition[1] = vect(-207.983, 5.46, -31.971)
        bastionPosition[2] = vect(-222.539, 0.1, -30.825)
        bastionPosition[3] = vect(-223.926, 5.56, -16.079)
        bastionPosition[4] = vect(-245.721, 5.56, 5.19)
        bastionPosition[6] = vect(-257.45, 2.85, 35.113)
        endPosition = vect(-271.14, -3.585, 33.279) - vect(0, 2, 0)
        resetPosition = vect(-160.308, -1.355, -91.403)
        thirdPersonPosition = vect(-148.168, -1.504, -88.932)
        creditsPosition = vect(-150.88, 0.2, -97.02)
        #废墟
    elif len(getPlayersInRadius(vect(131.609, 64.254, -159.135), 30, Team.1)) != 0:
        bastionPosition[0] = vect(111.31, 68.78, -183.068)
        bastionPosition[1] = vect(83.25, 67.65, -179.529)
        bastionPosition[2] = vect(28.394, 61.39, -148.333)
        bastionPosition[3] = vect(5.918, 60.37, -170.376)
        bastionPosition[4] = vect(-26.8, 67.62, -178.826)
        bastionPosition[5] = vect(-52.04, 65.39, -179.058)
        #Tower goal position
        endPosition = vect(-47.306, 60.37, -184.722) - vect(0, 2, 0)
        #Base coordinates for world game settings HUD
        resetPosition = vect(128.072, 63.254, -165.528)
        thirdPersonPosition = vect(129.56, 62.45, -153.472)
        creditsPosition = vect(137.54, 63.92, -158.9)
        #灯塔
    elif len(getPlayersInRadius(vect(322.692, -21.52, 42.832), 30, Team.1)) != 0:
        bastionPosition[0] = vect(321.799, -17.29, 26.126)
        bastionPosition[1] = vect(314.215, -16.35, -18.283)
        bastionPosition[2] = vect(358.768, -6.597, -47.48)
        bastionPosition[3] = vect(353.915, -10.86, -53.746)
        bastionPosition[4] = vect(364.601, -25.62, -54.434)
        bastionPosition[5] = vect(304.692, -15.91, -42.049)
        bastionPosition[6] = vect(319.744, -24.11, -69.502)
        #Town goal position
        endPosition = vect(321.229, -23.291, -88.556) - vect(0, 3, 0)
        thirdPersonPosition = vect(318.997, -21.52, 37.66)
        resetPosition = vect(331.08, -21.52, 41.121)
        #Base coordinates for world game settings HUD
        creditsPosition = vect(321.8, -20, 46)

    mapTitlePlayersByKey = [
        DATA_ILIOS[0],
        DATA_ILIOS[1].split("-"),
        DATA_ILIOS[2].split("-")
    ]
