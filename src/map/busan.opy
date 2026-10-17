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
    resetPosition = mapPositionPool[93]
    endPosition = mapPositionPool[99]
    thirdPersonPosition = mapPositionPool[95]
    creditsPosition = mapPositionPool[96]
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = mapPositionPool.slice(100, 12)
    controlCenterPosition = mapPositionPool.slice(112, 2)
    controlJumpPosition = mapPositionPool.slice(114, 1)
    controlRespawnPosition = mapPositionPool.slice(115, 2)

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_1():
    resetPosition = mapPositionPool[117]
    endPosition = mapPositionPool[94]
    thirdPersonPosition = mapPositionPool[118]
    creditsPosition = mapPositionPool[119]
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = mapPositionPool.slice(120, 12)
    controlCenterPosition = mapPositionPool.slice(132, 2)
    controlJumpPosition = mapPositionPool.slice(134, 1)
    controlRespawnPosition = mapPositionPool.slice(135, 2)

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_2():
    resetPosition = mapPositionPool[137]
    endPosition = mapPositionPool[114]
    thirdPersonPosition = mapPositionPool[138]
    creditsPosition = mapPositionPool[139]
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = mapPositionPool.slice(140, 12)
    controlCenterPosition = mapPositionPool.slice(152, 2)
    controlJumpPosition = mapPositionPool.slice(154, 1)
    controlRespawnPosition = mapPositionPool.slice(155, 2)

macro platformMapRevision_BUSAN_DEFAULT_SETUP_ROUTE():
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
