#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SAMOA_DEFAULT():
    __currentMapText___ = "萨摩亚"

    bastionPosition = mapPositionPool.slice(603, 14)
    resetPosition = mapPositionPool[617]
    endPosition = mapPositionPool[618]
    thirdPersonPosition = mapPositionPool[619]
    creditsPosition = mapPositionPool[620]
    controlJumpPosition = mapPositionPool.slice(621, 2)
    controlRespawnPosition = mapPositionPool.slice(623, 3)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 萨摩亚":
    @Condition (__currentMap___ == Map.SAMOA or __currentMap___ == 13628) == true

    platformMapRevision_SAMOA_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
