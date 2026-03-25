#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 皇家赛道":
    @Condition __currentMap___ == Map.CIRCUIT_ROYAL

    __currentMapText___ = STR_MAP_CIRCUIT_ROYAL
    if circuitRoyalClassic:
        __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format(STR_MAP_CIRCUIT_ROYAL)

    #Made by 他又 芋泥玛奇朵
    if circuitRoyalClassic:
        bastionPosition = [
            vect(105.65, 15.95, 14.28),
            vect(56.16, 18.97, 21.78),
            vect(12.30, 13.18, -27.04),
            vect(-28.93, 11, -3.85),
            vect(-14.51, 8, -34.71),
            vect(-62.89, 13.3, -45.44),
            vect(-46.18, 4.22, -69.18)
        ]
        endPosition = vect(-76.75, 4.03, -74.17)
    else:
        bastionPosition = [vect(97.763, 15.967, 29.045), vect(64.607, 19.071, 23.437), vect(61.918, 17.956, 15.709), vect(88.977, 14.931, -25.352), vect(59.133, 29.301, -30.146), vect(13.16, 16.52, -44.31), vect(10.33, 6, 5.54), vect(-23.15, 7.58, 19.14), vect(-15.61, 13, -45.26), vect(-40.6, 4.25, -35.79), vect(-67.822, 6.067, -43.245)]
        endPosition = vect(-45.08, 10, -13.37)
    thirdPersonPosition = vect(135.08, 10, -3.31)
    resetPosition = vect(129.68, 10, 0.04)
    creditsPosition = vect(147.52, 11.5, -10.9)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_CIRCUIT_ROYAL[0].split("-"),
        DATA_CIRCUIT_ROYAL[1].split("-"),
        DATA_CIRCUIT_ROYAL[2].split("-")
    ]
