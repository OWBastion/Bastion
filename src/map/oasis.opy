#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_OASIS_DEFAULT():
    __currentMapText___ = "绿洲城"

    bastionPosition = mapPositionPool.slice(508, 13)
    resetPosition = mapPositionPool[521]
    endPosition = mapPositionPool[522]
    thirdPersonPosition = mapPositionPool[523]
    creditsPosition = mapPositionPool[524]
    controlCenterPosition = mapPositionPool.slice(525, 3)
    controlJumpPosition = mapPositionPool.slice(528, 2)
    controlRespawnPosition = mapPositionPool.slice(530, 3)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 绿洲城":
    @Condition __currentMap___ == Map.OASIS

    platformMapRevision_OASIS_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
