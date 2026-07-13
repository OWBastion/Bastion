#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - junkertown":
    @Condition __currentMap___ == Map.JUNKERTOWN
    
    bastionPosition = vect(-101.37, 12.72, -135.27)
    bastionPosition.append(vect(-72.634, 6.669, -145.321))
    bastionPosition.append(vect(-57.67, 13.98, -92.45))
    bastionPosition.append(vect(-27.85, 14.52, -97.33))
    bastionPosition.append(vect(-25.34, 8.29, -36.47))
    bastionPosition.append(vect(-5.66, 14.63, -74.46))
    bastionPosition.append(vect(32.15, 15.16, -89.13))
    endPosition = vect(30.248, 5.515, -81.733)
    thirdPersonPosition = vect(-88.03, 11.22, -88)
    resetPosition = vect(-103.91, 11.69, -86.6)
    creditsPosition = vect(-92.71, 14.04, -73.79)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_JUNKERTOWN[0].split("-"),
        DATA_JUNKERTOWN[1].split("-"),
        DATA_JUNKERTOWN[2].split("-")
    ]
