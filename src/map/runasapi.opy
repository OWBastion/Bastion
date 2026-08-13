#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RUNASAPI_DEFAULT():
    platformMapRevisionId = "revision:map.runasapi:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "鲁纳塞彼"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("鲁纳塞彼")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(70.39, 7.86, 24.73),
        vect(40.8, 4.01, 5.96),
        vect(61.26, 5.99, -16.04),
        vect(0.08, 8.34, 83.49),
        vect(-25.99, 1.21, 15.51),
        vect(-43.32, 4, 36.5),
        vect(-71.28, 14.62, 38.58),
        vect(-93.05, 7.06, 18.11)
    ]
    resetPosition = vect(111.34, 7.09, -5.6)
    endPosition = vect(-106.93, 7.99, 22.24)
    thirdPersonPosition = vect(113.31, 7.09, -3.5)
    creditsPosition = vect(124.6, 8.77, -15.99)

    mapTitlePlayersByKey = [
        DATA_RUNASAPI[0].split("-"),
        DATA_RUNASAPI[1].split("-"),
        DATA_RUNASAPI[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 鲁纳塞彼":
    @Condition (__currentMap___ == Map.RUNASAPI or __currentMap___ == 8048) == true

    platformMapRevision_RUNASAPI_DEFAULT()
    startForcingSpawn(Team.1, 2)
