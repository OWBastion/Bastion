#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_BUSAN_DEFAULT():
    __currentMapText___ = "釜山"
    resetPosition = mapPositionPool[93]
    endPosition = mapPositionPool[94]
    thirdPersonPosition = mapPositionPool[95]
    creditsPosition = mapPositionPool[96]
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40


#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_POSITION mapPositionPool[97]
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_RADIUS 30

#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_POSITION mapPositionPool[98]
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_RADIUS 30
macro platformMapRevision_BUSAN_DEFAULT_ROUTE_0():
    bastionPosition = mapPositionPool.slice(99, 12)
    controlCenterPosition = mapPositionPool.slice(111, 2)
    controlJumpPosition = mapPositionPool.slice(113, 1)
    controlRespawnPosition = mapPositionPool.slice(114, 2)

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_1():
    bastionPosition = mapPositionPool.slice(116, 12)
    controlCenterPosition = mapPositionPool.slice(128, 2)
    controlJumpPosition = mapPositionPool.slice(130, 1)
    controlRespawnPosition = mapPositionPool.slice(131, 2)

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_2():
    bastionPosition = mapPositionPool.slice(133, 12)
    controlCenterPosition = mapPositionPool.slice(145, 2)
    controlJumpPosition = mapPositionPool.slice(147, 1)
    controlRespawnPosition = mapPositionPool.slice(148, 2)

macro platformMapRevision_BUSAN_DEFAULT_SETUP_ROUTE():
    resetPosition = mapPositionPool[93]
    endPosition = mapPositionPool[94]
    thirdPersonPosition = mapPositionPool[95]
    creditsPosition = mapPositionPool[96]
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    if len(getPlayersInRadius(platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_POSITION, platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_BUSAN_DEFAULT_ROUTE_1()
    elif len(getPlayersInRadius(platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_POSITION, platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_BUSAN_DEFAULT_ROUTE_2()
    else:
        platformMapRevision_BUSAN_DEFAULT_ROUTE_0()


# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 釜山":
    @Condition __currentMap___ == Map.BUSAN

    __currentMapText___ = "釜山"
    __currentMapPioneerText___ = "王牌驾驶员"
    platformMapRevision_BUSAN_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    platformMapRevision_BUSAN_DEFAULT_SETUP_ROUTE()
