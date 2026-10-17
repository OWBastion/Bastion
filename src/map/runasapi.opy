#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RUNASAPI_DEFAULT():
    __currentMapText___ = "鲁纳塞彼"

    bastionPosition = mapPositionPool.slice(585, 8)
    resetPosition = mapPositionPool[593]
    endPosition = mapPositionPool[594]
    thirdPersonPosition = mapPositionPool[595]
    creditsPosition = mapPositionPool[596]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 鲁纳塞彼":
    @Condition (__currentMap___ == Map.RUNASAPI or __currentMap___ == 8048) == true

    platformMapRevision_RUNASAPI_DEFAULT()
    startForcingSpawn(Team.1, 2)
