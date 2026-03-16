#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    
    __currentMapText___ = "直布罗陀"
    __currentMapPioneerText___ = __currentMapText___
    bastionPosition[0] = vect(70.099, 9, 26.803)
    bastionPosition[1] = vect(86.26, 7.46, 2.95)
    bastionPosition[2] = vect(61.64, 3.67, -20.79)
    bastionPosition[3] = vect(57.02, 4.65, -55.29)
    bastionPosition[4] = vect(31.113, 7.3, -89.871)
    bastionPosition[5] = vect(56.88, 9.23, -118.92)
    bastionPosition[6] = vect(19.43, 6, -131.05)
    endPosition = vect(15.7, -2, -134.65)
    thirdPersonPosition = vect(93.88, 1.06, 63.17)
    resetPosition = vect(97.55, 1.06, 60.38)
    creditsPosition = vect(112.23, 0, 73.59)
    startForcingSpawn(Team.1, 2)

    mapTitlePlayersByKey = [
        DATA_WATCHPOINT_GIBRALTAR[0],
        DATA_WATCHPOINT_GIBRALTAR[1].split("-"),
        DATA_WATCHPOINT_GIBRALTAR[2].split("-")
    ]
