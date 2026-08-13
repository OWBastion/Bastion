#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SURAVASA_DEFAULT():
    platformMapRevisionId = "revision:map.suravasa:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "苏拉瓦萨"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("苏拉瓦萨")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(16.734, 10.5, 72.11),
        vect(-33.04, 4.174, 73.197),
        vect(-0.913, 5.25, 62.388),
        vect(24.538, 9.284, 4.699),
        vect(23.629, 7.986, 36.324),
        vect(-63.158, 8.431, 13.99),
        vect(-20.737, 4.005, 18.929),
        vect(-2.818, 3.976, -36.071),
        vect(-20.587, 4.008, -19.155)
    ]
    resetPosition = vect(-4.55, 4, 124.39)
    endPosition = vect(-2.43, 4.13, 0.75)
    thirdPersonPosition = vect(5.54, 4, 124.39)
    creditsPosition = vect(0.68, 11.77, 120.02)
    controlRespawnPosition = [
        vect(-0.36, 4, 136.68)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 50

    mapTitlePlayersByKey = [
        DATA_SURAVASA[0].split("-"),
        DATA_SURAVASA[1].split("-"),
        DATA_SURAVASA[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 苏拉瓦萨":
    @Condition __currentMap___ == Map.SURAVASA
    
    platformMapRevision_SURAVASA_DEFAULT()
    __currentMapPioneerText___ = "瓦拉纳西"
    __currentPioneerText___ = "守护者"
    startForcingSpawn(Team.1, 1)
