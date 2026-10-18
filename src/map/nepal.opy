#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEPAL_DEFAULT():
    __currentMapText___ = "尼泊尔"

    bastionPosition = mapPositionPool.slice(418, 12)
    # (-152.68, -92.115, -64.862)
    # (-193.849, -89.578, -32.592)
    # (-199.313, -94.457, 41.386)
    # (-146.246, -88.751, 48.509)
    # (-26.436, 22, -69.808)
    # (-25.182, 13, 0.688)
    # (-73.662, 19.545, 0.132)
    # (-42.208, 20.025, 51.77)
    # (-187.057, -87.686, 7.868)
    # (73.112, 129.717, -67.245)
    # (94.679, 140.26, -17.696)
    # (92.445, 141.37, 49.176)
    resetPosition = mapPositionPool[430] # (-165.4, -95.85, -88.15)
    endPosition = mapPositionPool[431] # (103.15, 132, 52.57)
    thirdPersonPosition = mapPositionPool[432] # (-158.45, -95.97, -78.36)
    creditsPosition = mapPositionPool[433] # (-157.98, -90.95, -89.77)
    controlJumpPosition = mapPositionPool.slice(434, 2)
    # (-148.56, -92.25, 64.75)
    # (-21.67, 21, 81.47)
    controlRespawnPosition = mapPositionPool.slice(436, 3)
    # (-161, -95.97, -84.17)
    # (-39.04, 17.84, -99.75)
    # (85.52, 132.49, -96.2)
    controlRespawnAxis = 1
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 尼泊尔":
    @Condition __currentMap___ == Map.NEPAL

    platformMapRevision_NEPAL_DEFAULT()
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
