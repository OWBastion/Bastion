#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - paraiso":
    @Condition __currentMap___ == Map.PARAISO
    
    bastionPosition = vect(-47.03, 6.86, -141.73)
    bastionPosition.append(vect(5.22, 12, -122))
    bastionPosition.append(vect(-5.81, 10, -88.75))
    bastionPosition.append(vect(10.08, 3.9, -56.92))
    bastionPosition.append(vect(-13.62, 8.22, -44.11))
    bastionPosition.append(vect(11.42, 5.1, -24.26))
    bastionPosition.append(vect(-6.88, 0.5, 26.09))
    bastionPosition.append(vect(-40.63, 3, 40.01))
    endPosition = vect(-39.54, -2, 62.86)
    thirdPersonPosition = vect(-78.25, 6.33, -167.96)
    resetPosition = vect(-78.3, 5.03, -170.8)
    creditsPosition = vect(-70.2, 7.75, -183.14)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_PARAISO[0].split("-"),
        DATA_PARAISO[1].split("-"),
        DATA_PARAISO[2].split("-")
    ]
