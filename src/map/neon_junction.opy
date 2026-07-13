#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 霓虹枢纽":
    @Condition (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true

    __currentMapPioneerText___ = "桥元御守"
    __currentPioneerText___ = ""

    bastionPosition = [vect(0.708, 4.061, 388.523), vect(-12.132, 8.845, 372.132), vect(19.299, 2.750, 355.878), vect(1.929, 8.359, 320.916),vect(35.587, 7.414,295.986), vect(35.936, 7.413, 287.017), vect(5.606, 12.760, 268.637), vect(15.272, 5.226, 241.462), vect(-22.805, 6.146, 239.808)]
    endPosition = vect(-12.85,8.09,220.7)

    thirdPersonPosition = vect(-17.28, 0.75, 431.46)
    resetPosition = vect(2.31, 0.75, 431.46)
    creditsPosition = vect(-7.51, 4.05, 438.32)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_NEON_JUNCTION[0].split("-"),
        DATA_NEON_JUNCTION[1].split("-"),
        DATA_NEON_JUNCTION[2].split("-")
    ]

    waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
    titleColor[TITLE.PIONEER] = vect(250, 120, 115)
