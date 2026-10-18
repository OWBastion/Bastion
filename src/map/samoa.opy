#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SAMOA_DEFAULT():
    __currentMapText___ = "萨摩亚"

    bastionPosition = mapPositionPool.slice(597, 14)
    # (-408.95, 14.4, -84.76)
    # (-384.05, 12.05, -86.88)
    # (-330.08, 10.01, -98.04)
    # (-276.43, 11.02, -89.16)
    # (307.13, 18.61, -206.17)
    # (231.6, 16.28, -270.76)
    # (233.69, 9, -229.7)
    # (170.96, 12.56, -242.33)
    # (97.68, 340.63, 397.23)
    # (46.64, 345.49, 387.04)
    # (26.69, 341.63, 376.43)
    # (27.74, 360.5, 356.07)
    # (0.96, 346.65, 390.11)
    # (-4.4, 353.05, 407.42)
    resetPosition = mapPositionPool[611] # (-430.71, 10.3, -105.96)
    endPosition = mapPositionPool[612] # (-29.3, 340.56, 410.76)
    thirdPersonPosition = mapPositionPool[613] # (-425.32, 10.23, -116.48)
    creditsPosition = mapPositionPool[614] # (-436.16, 12.2, -111.37)
    controlJumpPosition = mapPositionPool.slice(615, 2)
    # (-256.82, 14.85, -94.9)
    # (177.52, 12.3, -239.3)
    controlRespawnPosition = mapPositionPool.slice(617, 3)
    # (-428, 10.5, -109)
    # (330.12, 14.64, -216.31)
    # (107.83, 343, 415.6)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 萨摩亚":
    @Condition (__currentMap___ == Map.SAMOA or __currentMap___ == 13628) == true

    platformMapRevision_SAMOA_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
