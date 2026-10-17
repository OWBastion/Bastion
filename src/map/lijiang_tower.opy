#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_LIJIANG_TOWER_DEFAULT():
    __currentMapText___ = "漓江塔"

    bastionPosition = mapPositionPool.slice(389, 14)
    resetPosition = mapPositionPool[403]
    endPosition = mapPositionPool[404]
    thirdPersonPosition = mapPositionPool[405]
    creditsPosition = mapPositionPool[406]
    controlJumpPosition = mapPositionPool.slice(407, 2)
    controlRespawnPosition = mapPositionPool.slice(409, 3)
    controlRespawnAxis = 1
    controlRespawnAxisThreshold = 40

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 漓江塔":
    @Condition (__currentMap___ == Map.LIJIANG_TOWER or __currentMap___ == 3676) == true

    platformMapRevision_LIJIANG_TOWER_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
