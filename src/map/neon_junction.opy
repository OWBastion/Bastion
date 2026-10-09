#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEON_JUNCTION_DEFAULT():
    __currentMapText___ = "霓虹枢纽"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("霓虹枢纽")

    bastionPosition = [
        vect(0.708, 4.061, 388.523),
        vect(-12.132, 8.845, 372.132),
        vect(19.299, 2.75, 355.878),
        vect(1.929, 8.359, 320.916),
        vect(35.587, 7.414, 295.986),
        vect(35.936, 7.413, 287.017),
        vect(5.606, 12.76, 268.637),
        vect(15.272, 5.226, 241.462),
        vect(-22.805, 6.146, 239.808)
    ]
    resetPosition = vect(2.31, 0.75, 431.46)
    endPosition = vect(-12.85, 8.09, 220.7)
    thirdPersonPosition = vect(-17.28, 0.75, 431.46)
    creditsPosition = vect(-7.51, 4.05, 438.32)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 霓虹枢纽":
    @Condition (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true

    __currentMapText___ = "霓虹枢纽"
    bastionPosition = [
        vect(0.837, 6.226, 330.332),
        vect(10.077, 12.750, 263.095),
        vect(-6.268, 10.367, 275.865),
        vect(42.236, 6.250, 278.574),
        vect(2.688, 8.378, 320.437),
        vect(-26.845, 4.480, 231.626),
        vect(19.715, 2.249, 322.765),
        vect(3.933, 8.209, 362.802),
        vect(0.578, 4.061, 386.823),
        vect(1.261, 8.835, 372.479),
        vect(-6.256, 10.683, 352.281)
    ]
    thirdPersonPosition = vect(-50.36, 3.25, 234.29)
    resetPosition = vect(-49.65, 3.25, 240.25)
    endPosition = vect(-20.02, 6.75, 358.53)
    minefieldPosition = [
        vect(24.7, 2.79, 338.64),
        vect(42.43, 0.25, 290.29),
        vect(-13.26, 2.23, 232.84)
    ]
    startForcingSpawn(Team.2, 0)
