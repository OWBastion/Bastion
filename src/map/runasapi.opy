#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RUNASAPI_DEFAULT():
    __currentMapText___ = "鲁纳塞彼"

    bastionPosition = mapPositionPool.slice(594, 8)
    # (70.39, 7.86, 24.73)
    # (40.8, 4.01, 5.96)
    # (61.26, 5.99, -16.04)
    # (0.08, 8.34, 83.49)
    # (-25.99, 1.21, 15.51)
    # (-43.32, 4, 36.5)
    # (-71.28, 14.62, 38.58)
    # (-93.05, 7.06, 18.11)
    resetPosition = mapPositionPool[602] # (111.34, 7.09, -5.6)
    endPosition = mapPositionPool[603] # (-106.93, 7.99, 22.24)
    thirdPersonPosition = mapPositionPool[604] # (113.31, 7.09, -3.5)
    creditsPosition = mapPositionPool[605] # (124.6, 8.77, -15.99)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 鲁纳塞彼":
    @Condition __currentMap___ == Map.RUNASAPI or __currentMap___ == 8048

    platformMapRevision_RUNASAPI_DEFAULT()
    mapPositionPool = []
    startForcingSpawn(Team.1, 2)
