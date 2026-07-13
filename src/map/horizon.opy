#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - horizon lunar colony":
    @Condition __currentMap___ == Map.HORIZON_LUNAR_COLONY
    
    bastionPosition[0] = vect(-15.287, 6, -127.244)
    bastionPosition[1] = vect(16.25, 11.86, -106.756)
    bastionPosition[2] = vect(62.52, 14, -77.97)
    #Fixed by 他又
    bastionPosition[3] = vect(33.14, 13.03, -43.68)
    bastionPosition[4] = vect(19.496, 9, -1.439)
    bastionPosition[5] = vect(66.687, 8.52, -37.241)
    endPosition = vect(34.476, 12, -23.518)
    thirdPersonPosition = vect(-41.39, 5, -159.03)
    resetPosition = vect(-45.62, 5, -156.87)
    creditsPosition = vect(-55.87, 7.68, -171.97)
    startForcingSpawn(Team.1, 0)
    __currentMapText___ = "月球基地"
    __currentMapPioneerText___ = __currentMapText___

    mapTitlePlayersByKey = [
        DATA_HORIZON_LUNAR_COLONY[0].split("-"),
        DATA_HORIZON_LUNAR_COLONY[1].split("-"),
        DATA_HORIZON_LUNAR_COLONY[2].split("-")
    ]
