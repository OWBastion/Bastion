#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 鲁纳塞彼":
    @Condition (__currentMap___ == Map.RUNASAPI or __currentMap___ == 8048) == true
    
    #made by 他又
    bastionPosition = vect(70.39, 7.86, 24.73)
    bastionPosition.append(vect(40.8, 4.01, 5.96))
    bastionPosition.append(vect(61.26, 5.99, -16.04))
    bastionPosition.append(vect(0.08, 8.34, 83.49))
    bastionPosition.append(vect(-25.99, 1.21, 15.51))
    bastionPosition.append(vect(-43.32, 4, 36.5))
    bastionPosition.append(vect(-71.28, 14.62, 38.58))
    bastionPosition.append(vect(-93.05, 7.06, 18.11))
    endPosition = vect(-106.93, 7.99, 22.24)
    thirdPersonPosition = vect(113.31, 7.09, -3.5)
    resetPosition = vect(111.34, 7.09, -5.6)
    creditsPosition = vect(124.6, 8.77, -15.99)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_RUNASAPI[0].split("-"),
        DATA_RUNASAPI[1].split("-"),
        DATA_RUNASAPI[2].split("-")
    ]
