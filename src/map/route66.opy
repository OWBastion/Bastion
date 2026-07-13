#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - route 66":
    @Condition __currentMap___ == Map.ROUTE66
    
    bastionPosition[0] = vect(-95.624, 12.66, -5.541)
    bastionPosition[1] = vect(-61.87, 10.87, 5.36)
    bastionPosition[2] = vect(-38.68, 12.75, -22.136)
    bastionPosition[3] = vect(-20.44, 12.17, -15.13)
    bastionPosition[4] = vect(26.871, 7.01, 2.468)
    bastionPosition[5] = vect(53.82, 12.86, 10.55)
    bastionPosition[6] = vect(33.75, 5.54, 48.5)
    endPosition = vect(47.956, 5.2, 47.318)
    thirdPersonPosition = vect(-115.228, 5.799, -49.59)
    resetPosition = vect(-115.01, 4.5, -46.01)
    creditsPosition = vect(-113.27, 7.5, -63.14)
    startForcingSpawn(Team.1, 1)

    mapTitlePlayersByKey = [
        DATA_ROUTE66[0].split("-"),
        DATA_ROUTE66[1].split("-"),
        DATA_ROUTE66[2].split("-")
    ]
