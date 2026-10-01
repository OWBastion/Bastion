#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT():
    __currentMapText___ = "直布罗陀"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("直布罗陀")

    bastionPosition = [
        vect(70.099, 9, 26.803),
        vect(86.26, 7.46, 2.95),
        vect(61.64, 3.67, -20.79),
        vect(46.95, 7.65, -66.08),
        vect(32.69, 4.69, -52.38),
        vect(21, 4.2, -64.39),
        vect(31.85, 7.62, -107.88),
        vect(56.88, 9.23, -118.92),
        vect(18.08, 8.78, -133.02)
    ]
    resetPosition = vect(97.55, 1.06, 60.38)
    endPosition = vect(43.42, 5.15, -129.34)
    thirdPersonPosition = vect(93.88, 1.06, 63.17)
    creditsPosition = vect(112.23, 0, 73.59)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("直布罗陀")
    __currentMapText___ = "直布罗陀"
    startForcingSpawn(Team.1, 2)
    bastionPosition = [
        vect(34.044, 10.343, -152.744),
        vect(57.063, 9.010, -119.331),
        vect(25.767, 4.003, -89.073),
        vect(7.322, -4.121, -83.812),
        vect(45.495, 5.789, -48.875),
        vect(58.797, -0.354, -9.899),
        vect(45.853, 3, -34.604),
        vect(76.188, 10, 7.197),
        vect(57.751, 9, 3.019),
        vect(60.198, 1, 44.104)
    ]
    endPosition = vect(82.17, -0.48, 39.83)
    anniversarySpawnPosition = vect(-7.49, -0.07, -158.11)
    thirdPersonPosition = vect(5.21, -0.1, -156)
    resetPosition = vect(9.47, -1.07, -152.43)
    minefieldPosition = [
        vect(37.84, -5.02, -76.88),
        vect(91.84, -3.06, -8.85),
        vect(76.23, 1, 23.24)
    ]
