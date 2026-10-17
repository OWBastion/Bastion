#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEPAL_DEFAULT():
    __currentMapText___ = "尼泊尔"

    bastionPosition = mapPositionPool.slice(439, 12)
    resetPosition = mapPositionPool[451]
    endPosition = mapPositionPool[452]
    thirdPersonPosition = mapPositionPool[453]
    creditsPosition = mapPositionPool[454]
    controlJumpPosition = mapPositionPool.slice(455, 2)
    controlRespawnPosition = mapPositionPool.slice(457, 3)
    controlRespawnAxis = 1
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 尼泊尔":
    @Condition __currentMap___ == Map.NEPAL

    platformMapRevision_NEPAL_DEFAULT()
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
