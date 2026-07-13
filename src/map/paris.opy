#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - paris":
    @Condition __currentMap___ == Map.PARIS
    
    #made by 芋泥玛奇朵
    bastionPosition = vect(-95.984, 13.454, -83.535)
    bastionPosition.append(vect(-72.132, 11.976, -44.042))
    bastionPosition.append(vect(-42.867, 18.51, -12.093))
    bastionPosition.append(vect(-30.23, 10.02, 3.28))
    bastionPosition.append(vect(-14.721, 14.25, -35.219))
    bastionPosition.append(vect(-2.715, 10.08, -52.081))
    endPosition = vect(9.563, 8.329, -59.98)
    thirdPersonPosition = vect(-109.263, 15.3, -111.151)
    resetPosition = vect(-115.03, 15.97, -122.82)
    creditsPosition = vect(-119.74, 19, -132.45)
    startForcingSpawn(Team.1, 1)

    mapTitlePlayersByKey = [
        DATA_PARIS[0].split("-"),
        DATA_PARIS[1].split("-"),
        DATA_PARIS[2].split("-")
    ]
