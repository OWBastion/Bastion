#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HANAOKA_DEFAULT():
    __currentMapText___ = "花冈"

    bastionPosition = mapPositionPool.slice(265, 10)
    resetPosition = mapPositionPool[275]
    endPosition = mapPositionPool[276]
    thirdPersonPosition = mapPositionPool[277]
    creditsPosition = mapPositionPool[278]
    controlRespawnPosition = mapPositionPool.slice(279, 1)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 花冈":
     @Condition (__currentMap___ == Map.HANAOKA or __currentMap___ == 2601) == true
    
    platformMapRevision_HANAOKA_DEFAULT()
     __currentMapText___ = "花冈"
     startForcingSpawn(Team.1, 2)
     waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
