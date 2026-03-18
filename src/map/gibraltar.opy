#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    
    __currentMapText___ = "直布罗陀"
    __currentMapPioneerText___ = __currentMapText___
    bastionPosition = vect(70.099, 9, 26.803)
    bastionPosition.append(vect(86.26, 7.46, 2.95))
    bastionPosition.append(vect(61.64, 3.67, -20.79))
    bastionPosition.append(vect(46.95, 7.65, -66.08))
    bastionPosition.append(vect(32.69, 4.69, -52.38))
    bastionPosition.append(vect(21.00, 4.2, -64.39))
    bastionPosition.append(vect(31.85, 7.62, -107.88))
    bastionPosition.append(vect(56.88, 9.23, -118.92))
    bastionPosition.append(vect(18.08, 8.78, -133.02))
    endPosition = vect(43.42, 5.15, -129.34)
    thirdPersonPosition = vect(93.88, 1.06, 63.17)
    resetPosition = vect(97.55, 1.06, 60.38)
    creditsPosition = vect(112.23, 0, 73.59)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_WATCHPOINT_GIBRALTAR[0],
        DATA_WATCHPOINT_GIBRALTAR[1].split("-"),
        DATA_WATCHPOINT_GIBRALTAR[2].split("-")
    ]
