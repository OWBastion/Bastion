#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_MIDTOWN_DEFAULT():
    __currentMapText___ = "中城"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("中城")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(59.17, 9.847, -6.159),
        vect(118.361, 5.867, -78.645),
        vect(133.892, 5.637, -53.775),
        vect(92.256, 8.438, -22.921),
        vect(77.01, 13.219, -20.601),
        vect(43.662, 8.805, 12.811),
        vect(59.729, 9.199, 38.82),
        vect(7.768, 9.061, 44.804),
        vect(11.395, 9.676, 91.561),
        vect(-13.854, 9.931, 73.748)
    ]
    resetPosition = vect(119.51, 1.84, -104.94)
    endPosition = vect(12.91, 3.75, 127.69)
    thirdPersonPosition = vect(133.91, 1.84, -104.94)
    creditsPosition = vect(126.5, 3, -125.37)

    mapTitlePlayersByKey = [
        DATA_MIDTOWN[0].split("-"),
        DATA_MIDTOWN[1].split("-"),
        DATA_MIDTOWN[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 中城":
    @Condition __currentMap___ == Map.MIDTOWN
    
    platformMapRevision_MIDTOWN_DEFAULT()
    startForcingSpawn(Team.1, 2)
