#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - dorado":
    @Condition __currentMap___ == Map.DORADO
    
    bastionPosition = vect(167.25, 10.85, 42.4)
    bastionPosition.append(vect(113.04, 13.8, 24.63))
    bastionPosition.append(vect(112.06, 17.25, -2.91))
    bastionPosition.append(vect(102.79, 11.01, -23.56))
    bastionPosition.append(vect(78.973, 17.48, -6.843))
    bastionPosition.append(vect(34.78, 10.05, -6.8))
    bastionPosition.append(vect(32.21, 10.59, 20.55))
    bastionPosition.append(vect(8.83, 2.38, 25.76))
    endPosition = vect(15.47, 9.54, -1)
    thirdPersonPosition = vect(182.47, 7.04, 42.27)
    resetPosition = vect(183.3, 7.04, 37.96)
    creditsPosition = vect(197.72, 10.01, 44.63)
    startForcingSpawn(Team.1, 1)

    mapTitlePlayersByKey = [
        DATA_DORADO[0].split("-"),
        DATA_DORADO[1].split("-"),
        DATA_DORADO[2].split("-")
    ]
