#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_VOLSKAYA_DEFAULT():
    platformMapRevisionId = "revision:map.volskaya:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "沃斯卡娅工业区"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("沃斯卡娅工业区")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-72.477, 16.869, 47.82),
        vect(-68.159, 2.02, 82.854),
        vect(-29.458, 2.097, 77.543),
        vect(-39.212, -2.064, 80.626),
        vect(-82.963, -0.157, 22.991),
        vect(-13.924, -2.98, 117.617),
        vect(-28.688, 2.803, 35.54),
        vect(-38.633, -1.459, 38.463)
    ]
    resetPosition = vect(-115.18, -1.98, 35.24)
    endPosition = vect(-40.94, 2.95, 38.35)
    thirdPersonPosition = vect(-113.051, -1.98, 31.996)
    creditsPosition = vect(-128.25, 0.5, 24.75)

    mapTitlePlayersByKey = [
        DATA_VOLSKAYA[0].split("-"),
        DATA_VOLSKAYA[1].split("-"),
        DATA_VOLSKAYA[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - volskaya industries":
    @Condition __currentMap___ == Map.VOLSKAYA
    
    platformMapRevision_VOLSKAYA_DEFAULT()
    __currentMapText___ = "沃斯卡娅"
    __currentMapPioneerText___ = __currentMapText___
    startForcingSpawn(Team.1, 0)
