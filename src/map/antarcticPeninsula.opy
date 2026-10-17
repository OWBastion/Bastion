#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT():
    __currentMapText___ = "南极半岛"

    bastionPosition = mapPositionPool.slice(17, 12)
    resetPosition = mapPositionPool[29]
    endPosition = mapPositionPool[30]
    thirdPersonPosition = mapPositionPool[31]
    creditsPosition = mapPositionPool[32]
    controlJumpPosition = mapPositionPool.slice(33, 1)
    controlRespawnPosition = mapPositionPool.slice(34, 2)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_POSITION mapPositionPool[35]
#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_RADIUS 30
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER():
    bastionPosition = mapPositionPool.slice(36, 11)
    resetPosition = mapPositionPool[47]
    endPosition = mapPositionPool[48]
    thirdPersonPosition = mapPositionPool[49]
    creditsPosition = mapPositionPool[50]
    controlJumpPosition = mapPositionPool.slice(51, 1)
    controlRespawnPosition = mapPositionPool.slice(52, 2)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_POSITION mapPositionPool[53]
#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_RADIUS 30
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY():
    bastionPosition = mapPositionPool.slice(54, 11)
    resetPosition = mapPositionPool[65]
    endPosition = mapPositionPool[33]
    thirdPersonPosition = mapPositionPool[66]
    creditsPosition = mapPositionPool[67]
    controlJumpPosition = mapPositionPool.slice(68, 1)
    controlRespawnPosition = mapPositionPool.slice(69, 2)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_SETUP_ROUTE():
    if len(getPlayersInRadius(platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_POSITION, platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER()
    elif len(getPlayersInRadius(platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_POSITION, platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY()


# END AUTO-GENERATED PLATFORM MAP REVISION

rule "map - 南极半岛":
    @Condition (getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177) == true

    platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_SETUP_ROUTE()
