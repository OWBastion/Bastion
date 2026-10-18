#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RIALTO_DEFAULT():
    __currentMapText___ = "里阿尔托"

    bastionPosition = mapPositionPool.slice(556, 11)
    # (-64.421, 5.04, -125.927)
    # (-36.002, 4.75, -77.344)
    # (-19.68, 3.7, -38.47)
    # (59.058, 0.07, -8.103)
    # (54.797, 1.74, -59.938)
    # (87.874, -0.37, 0.268)
    # (60.53, 50.43, 61.63)
    # (-13.12, 4.75, 47.31)
    # (27.18, 4.75, 36.89)
    # (20.9, 0.75, 54.61)
    # (-19.85, 10.75, 11.92)
    resetPosition = mapPositionPool[567] # (-59.05, 3.75, -158.41)
    endPosition = mapPositionPool[568] # (-12.27, -1.25, -14.73)
    thirdPersonPosition = mapPositionPool[569] # (-54.92, 3.75, -158.32)
    creditsPosition = mapPositionPool[570] # (-57.06, 5.25, -181.51)
    controlJumpPosition = mapPositionPool.slice(571, 1)
    # (98.662, -1.5, -21.009)
    controlRespawnPosition = mapPositionPool.slice(572, 2)
    # (-52.36, 3.83, -176.36)
    # (53.17, 1.25, 22.99)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - rialto":
    @Condition __currentMap___ == Map.RIALTO

    platformMapRevision_RIALTO_DEFAULT()
    startForcingSpawn(Team.1, 2)
