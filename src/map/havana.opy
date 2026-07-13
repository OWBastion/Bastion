#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "map - havana":
    @Condition __currentMap___ == Map.HAVANA
    
    bastionPosition = vect(117.332, 14.433, -58.091)
    bastionPosition.append(vect(97, 9.01, -25.51))
    bastionPosition.append(vect(62.21, 12.06, -83.3))
    bastionPosition.append(vect(11.58, 7.96, -52.71))
    bastionPosition.append(vect(10.13, 6, -100.38))
    bastionPosition.append(vect(-37.54, 8.23, -72.23))
    bastionPosition.append(vect(-77.17, 10.13, -66.78))
    endPosition = vect(-77.24, 7.22, -49.83)
    thirdPersonPosition = vect(158.256, 11, -47.739)
    resetPosition = vect(158.3, 11, -44.35)
    creditsPosition = vect(193.45, 13.25, -46.49)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_HAVANA[0].split("-"),
        DATA_HAVANA[1].split("-"),
        DATA_HAVANA[2].split("-")
    ]
