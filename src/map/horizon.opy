#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT():
    __currentMapText___ = "月球基地"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("月球基地")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-15.287, 6, -127.244),
        vect(16.25, 11.86, -106.756),
        vect(62.52, 14, -77.97),
        vect(33.14, 13.03, -43.68),
        vect(19.496, 9, -1.439),
        vect(66.687, 8.52, -37.241)
    ]
    resetPosition = vect(-45.62, 5, -156.87)
    endPosition = vect(34.476, 12, -23.518)
    thirdPersonPosition = vect(-41.39, 5, -159.03)
    creditsPosition = vect(-55.87, 7.68, -171.97)

    mapTitlePlayersByKey = [
        DATA_HORIZON_LUNAR_COLONY[0].split("-"),
        DATA_HORIZON_LUNAR_COLONY[1].split("-"),
        DATA_HORIZON_LUNAR_COLONY[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - horizon lunar colony":
    @Condition __currentMap___ == Map.HORIZON_LUNAR_COLONY
    
    platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT()
    __currentMapText___ = "月球基地"
    __currentMapPioneerText___ = __currentMapText___
    startForcingSpawn(Team.1, 0)
