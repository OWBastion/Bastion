#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_OASIS_DEFAULT():
    __currentMapText___ = "绿洲城"

    bastionPosition = mapPositionPool.slice(502, 13)
    # (170.7, 13.57, -216.17)
    # (123.6, 12, -229.92)
    # (78.92, 10, -253.17)
    # (111.34, 13.57, -278.41)
    # (-196.79, 21.65, 56.69)
    # (-202.91, 9.12, -0.1)
    # (-177.5, 20.25, 0.19)
    # (-183.17, 20.06, -61.79)
    # (110.54, 2, 283.01)
    # (140.16, 10, 250.39)
    # (171.91, 4.12, 277)
    # (150.98, 3.85, 223.89)
    # (173.51, 2, 217.63)
    resetPosition = mapPositionPool[515] # (193.61, 8.42, -197.03)
    endPosition = mapPositionPool[516] # (195.13, 0.85, 172.87)
    thirdPersonPosition = mapPositionPool[517] # (191.33, 8.42, -194.73)
    creditsPosition = mapPositionPool[518] # (204.41, 8.42, -184.71)
    controlCenterPosition = mapPositionPool.slice(519, 3)
    # (129.5, 15.28, -235.74)
    # (-192.08, 15, 0.26)
    # (143.44, 2.15, 247.95)
    controlJumpPosition = mapPositionPool.slice(522, 2)
    # (82.13, 5.49, -273.2)
    # (-175.4, 16, -61.35)
    controlRespawnPosition = mapPositionPool.slice(524, 3)
    # (200.46, 6.42, -188.28)
    # (-195.03, 20, 89.71)
    # (69.73, 1, 321.16)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 绿洲城":
    @Condition __currentMap___ == Map.OASIS

    platformMapRevision_OASIS_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
