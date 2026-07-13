#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - king's row":
    @Condition (__currentMap___ == Map.KINGS_ROW or __currentMap___ == 742) == true
    
    bastionPosition = vect(-143.9, 7.13, 10.15)
    bastionPosition.append(vect(-116.44, 6.13, 5.72))
    bastionPosition.append(vect(-103.12, 6.93, -4.02))
    bastionPosition.append(vect(-91.99, 7.5, -28.63))
    bastionPosition.append(vect(-66.62, 4.5, -35.93))
    bastionPosition.append(vect(-29.17, 2.55, -31.43))
    bastionPosition.append(vect(-10.67, 16.97, 5.65))
    endPosition = vect(-1.9, 5, -0.29)
    thirdPersonPosition = vect(-176.048, -0.07, 36.54)
    resetPosition = vect(-175.23, -0.07, 43.03)
    creditsPosition = vect(-185.56, 3.53, 38.32)
    __currentMapText___ = "国王大道"
    __currentMapPioneerText___ = __currentMapText___
    startForcingSpawn(Team.1, 1)

    mapTitlePlayersByKey = [
        DATA_KINGS_ROW[0].split("-"),
        DATA_KINGS_ROW[1].split("-"),
        DATA_KINGS_ROW[2].split("-")
    ]
