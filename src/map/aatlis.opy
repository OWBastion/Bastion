#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_AATLIS_DEFAULT():
    __currentMapText___ = "阿特利斯"

    bastionPosition = mapPositionPool.slice(0, 12)
    resetPosition = mapPositionPool[12]
    endPosition = mapPositionPool[13]
    thirdPersonPosition = mapPositionPool[14]
    creditsPosition = mapPositionPool[15]
    controlRespawnPosition = mapPositionPool.slice(16, 1)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 阿特利斯":
    @Condition (__currentMap___ == Map.AATLIS or __currentMap___ == 1826) == true
    
    platformMapRevision_AATLIS_DEFAULT()
    startForcingSpawn(Team.1, 1)
