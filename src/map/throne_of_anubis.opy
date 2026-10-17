#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_THRONE_OF_ANUBIS_DEFAULT():
    __currentMapText___ = "阿努比斯王座"

    bastionPosition = mapPositionPool.slice(660, 10)
    resetPosition = mapPositionPool[670]
    endPosition = mapPositionPool[671]
    thirdPersonPosition = mapPositionPool[672]
    creditsPosition = mapPositionPool[433]
    controlRespawnPosition = mapPositionPool.slice(673, 1)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 阿努比斯王座":
    @Condition (__currentMap___ == Map.THRONE_OF_ANUBIS or __currentMap___ == 886) == true
    
    platformMapRevision_THRONE_OF_ANUBIS_DEFAULT()
    __currentMapText___ = "王座"
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
