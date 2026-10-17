#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEPAL_DEFAULT():
    __currentMapText___ = "尼泊尔"

    bastionPosition = mapPositionPool.slice(418, 12)
    resetPosition = mapPositionPool[430]
    endPosition = mapPositionPool[431]
    thirdPersonPosition = mapPositionPool[432]
    creditsPosition = mapPositionPool[433]
    controlJumpPosition = mapPositionPool.slice(434, 2)
    controlRespawnPosition = mapPositionPool.slice(436, 3)
    controlRespawnAxis = 1
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 尼泊尔":
    @Condition __currentMap___ == Map.NEPAL

    platformMapRevision_NEPAL_DEFAULT()
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
