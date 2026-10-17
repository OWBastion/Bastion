#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ILIOS_DEFAULT():
    __currentMapText___ = "伊利奥斯"

    bastionPosition = mapPositionPool.slice(334, 6)
    resetPosition = mapPositionPool[340]
    endPosition = mapPositionPool[341]
    thirdPersonPosition = mapPositionPool[342]
    creditsPosition = mapPositionPool[343]

#!define platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_POSITION mapPositionPool[344]
#!define platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_RADIUS 30
macro platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE():
    bastionPosition = mapPositionPool.slice(345, 7)
    resetPosition = mapPositionPool[352]
    endPosition = mapPositionPool[353]
    thirdPersonPosition = mapPositionPool[354]
    creditsPosition = mapPositionPool[355]

#!define platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_POSITION mapPositionPool[356]
#!define platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_RADIUS 30
macro platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS():
    bastionPosition = mapPositionPool.slice(357, 6)
    resetPosition = mapPositionPool[363]
    endPosition = mapPositionPool[364]
    thirdPersonPosition = mapPositionPool[365]
    creditsPosition = mapPositionPool[366]

macro platformMapRevision_ILIOS_DEFAULT_SETUP_ROUTE():
    if len(getPlayersInRadius(platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_POSITION, platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE()
    elif len(getPlayersInRadius(platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_POSITION, platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS()


# END AUTO-GENERATED PLATFORM MAP REVISION

rule "map - 伊利奥斯":
    @Condition __currentMap___ == Map.ILIOS

    platformMapRevision_ILIOS_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    if len(getPlayersInRadius(platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_POSITION, platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS()
    elif len(getPlayersInRadius(platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_POSITION, platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE()
