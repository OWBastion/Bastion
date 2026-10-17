#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RIALTO_DEFAULT():
    __currentMapText___ = "里阿尔托"

    bastionPosition = mapPositionPool.slice(562, 11)
    resetPosition = mapPositionPool[573]
    endPosition = mapPositionPool[574]
    thirdPersonPosition = mapPositionPool[575]
    creditsPosition = mapPositionPool[576]
    controlJumpPosition = mapPositionPool.slice(577, 1)
    controlRespawnPosition = mapPositionPool.slice(578, 2)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - rialto":
    @Condition __currentMap___ == Map.RIALTO

    platformMapRevision_RIALTO_DEFAULT()
    startForcingSpawn(Team.1, 2)
