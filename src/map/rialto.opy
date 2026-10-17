#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RIALTO_DEFAULT():
    __currentMapText___ = "里阿尔托"

    bastionPosition = mapPositionPool.slice(556, 11)
    resetPosition = mapPositionPool[567]
    endPosition = mapPositionPool[568]
    thirdPersonPosition = mapPositionPool[569]
    creditsPosition = mapPositionPool[570]
    controlJumpPosition = mapPositionPool.slice(571, 1)
    controlRespawnPosition = mapPositionPool.slice(572, 2)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - rialto":
    @Condition __currentMap___ == Map.RIALTO

    platformMapRevision_RIALTO_DEFAULT()
    startForcingSpawn(Team.1, 2)
