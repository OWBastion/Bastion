#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_AATLIS_DEFAULT():
    platformMapRevisionId = "revision:map.aatlis:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "阿特利斯"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("阿特利斯")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-27.31, 30.462, 99.799),
        vect(-45.351, 15.454, 79.671),
        vect(-23.956, 16.004, 43.016),
        vect(-29.999, 17.009, 17.751),
        vect(-87.158, 14.004, -21.012),
        vect(-70.585, 13.295, 39.948),
        vect(-21.061, 13.813, -64.931),
        vect(-45.813, 14.934, -79.517),
        vect(4.542, 17.737, 61.038),
        vect(-4.835, 12.464, -0.137),
        vect(4.44, 17.737, -60.62),
        vect(-90.802, 14.002, -60.156)
    ]
    resetPosition = vect(16.37, 15, 104.47)
    endPosition = vect(-78.02, 9.19, -39.93)
    thirdPersonPosition = vect(-6.21, 15, 104.33)
    creditsPosition = vect(5.1, 19.5, 105.79)
    controlRespawnPosition = [
        vect(4.85, 15.5, 104.6)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

    mapTitlePlayersByKey = [
        DATA_AATLIS[0].split("-"),
        DATA_AATLIS[1].split("-"),
        DATA_AATLIS[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 阿特利斯":
    @Condition (__currentMap___ == Map.AATLIS or __currentMap___ == 1826) == true
    
    platformMapRevision_AATLIS_DEFAULT()
    __currentMapPioneerText___ = "织金"
    __currentPioneerText___ = "门徒"
    startForcingSpawn(Team.1, 1)
