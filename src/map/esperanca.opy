#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ESPERANCA_DEFAULT():
    platformMapRevisionId = "revision:map.esperanca:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "埃斯佩兰萨"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("埃斯佩兰萨")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(86.815, -0.268, -54.406),
        vect(63.789, 1, -57.796),
        vect(14.121, 3.261, -42.146),
        vect(1.238, 7.966, 13.923),
        vect(0.025, -0.002, -33.787),
        vect(-15.8, 3.08, -39.1),
        vect(-45.384, -1.583, -60.618),
        vect(60.25, -6, -93.538),
        vect(-26.245, 0, -80.277),
        vect(-108.094, -1.002, -60.285),
        vect(-71.269, 1.05, -49.368),
        vect(0.047, -2, -69.042)
    ]
    resetPosition = vect(126.7, -1.64, -81.42)
    endPosition = vect(-117.37, -3, -45.65)
    thirdPersonPosition = vect(126.7, -1.64, -90.03)
    creditsPosition = vect(116.67, -0.29, -82.29)
    springBoardPosition = vect(-73.72, -3, -34.19)

    mapTitlePlayersByKey = [
        DATA_ESPERANCA[0].split("-"),
        DATA_ESPERANCA[1].split("-"),
        DATA_ESPERANCA[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 埃斯佩兰萨":
    @Condition (__currentMap___ == Map.ESPERANCA or __currentMap___ == 276) == true
    
    platformMapRevision_ESPERANCA_DEFAULT()
    startForcingSpawn(Team.1, 2)
