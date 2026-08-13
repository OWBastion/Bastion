#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SAMOA_DEFAULT():
    platformMapRevisionId = "revision:map.samoa:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "萨摩亚"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("萨摩亚")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-408.95, 14.4, -84.76),
        vect(-384.05, 12.05, -86.88),
        vect(-330.08, 10.01, -98.04),
        vect(-276.43, 11.02, -89.16),
        vect(307.13, 18.61, -206.17),
        vect(231.6, 16.28, -270.76),
        vect(233.69, 9, -229.7),
        vect(170.96, 12.56, -242.33),
        vect(97.68, 340.63, 397.23),
        vect(46.64, 345.49, 387.04),
        vect(26.69, 341.63, 376.43),
        vect(27.74, 360.5, 356.07),
        vect(0.96, 346.65, 390.11),
        vect(-4.4, 353.05, 407.42)
    ]
    resetPosition = vect(-430.71, 10.3, -105.96)
    endPosition = vect(-29.3, 340.56, 410.76)
    thirdPersonPosition = vect(-425.32, 10.23, -116.48)
    creditsPosition = vect(-436.16, 12.2, -111.37)
    controlJumpPosition = [
        vect(-256.82, 14.85, -94.9),
        vect(177.52, 12.3, -239.3)
    ]
    controlRespawnPosition = [
        vect(-428, 10.5, -109),
        vect(330.12, 14.64, -216.31),
        vect(107.83, 343, 415.6)
    ]
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40

    mapTitlePlayersByKey = [
        DATA_SAMOA[0].split("-"),
        DATA_SAMOA[1].split("-"),
        DATA_SAMOA[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 萨摩亚":
    @Condition (__currentMap___ == Map.SAMOA or __currentMap___ == 13628) == true

    platformMapRevision_SAMOA_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
