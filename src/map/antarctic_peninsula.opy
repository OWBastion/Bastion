#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT():
    __currentMapText___ = "南极半岛"

    bastionPosition = mapPositionPool.slice(17, 12)
    # (-98.119, 15.423, 46.112)
    # (-103.198, 12.267, 17.698)
    # (-94, 19.5, -28.74)
    # (-68, 16.41, -47.6)
    # (-85.854, 8.087, -0.132)
    # (-113.76, 9.5, -23.19)
    # (244.902, -1, -226.505)
    # (236.299, -3.86, -255.149)
    # (283.34, 28.04, -201.87)
    # (318.253, -4.899, -211.882)
    # (336.311, -6.618, -242.569)
    # (283.936, -8.688, -253.317)
    resetPosition = mapPositionPool[29] # (-95.12, 9.47, 90.05)
    endPosition = mapPositionPool[30] # (354.1, -9.5, -226.25)
    thirdPersonPosition = mapPositionPool[31] # (-76.97, 9.04, 87)
    creditsPosition = mapPositionPool[32] # (-85.96, 9.25, 98.83)
    controlJumpPosition = mapPositionPool.slice(33, 1)
    # (-79.07, 12.7, -63.71)
    controlRespawnPosition = mapPositionPool.slice(34, 2)
    # (-90.25, 9.25, 90)
    # (175.87, -9.5, -228)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_POSITION mapPositionPool[35] # (175.87, -9.5, -228)
#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_RADIUS 30
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER():
    bastionPosition = mapPositionPool.slice(36, 11)
    # (244.902, -1, -226.505)
    # (236.299, -3.86, -255.149)
    # (283.34, 28.04, -201.87)
    # (318.253, -4.899, -211.882)
    # (336.311, -6.618, -242.569)
    # (283.936, -8.688, -253.317)
    # (358.414, 64.664, 155.328)
    # (329.109, 48.084, 166.447)
    # (269.63, 68.9, 209.25)
    # (270.34, 42.58, 139.77)
    # (214.64, 53.09, 189.61)
    resetPosition = mapPositionPool[47] # (173.68, -6.85, -246.89)
    endPosition = mapPositionPool[48] # (209.17, 51.5, 161.47)
    thirdPersonPosition = mapPositionPool[49] # (171.42, -6.88, -236.82)
    creditsPosition = mapPositionPool[50] # (172.58, -8.46, -229.17)
    controlJumpPosition = mapPositionPool.slice(51, 1)
    # (354.1, -9.5, -226.25)
    controlRespawnPosition = mapPositionPool.slice(52, 2)
    # (175.87, -9.5, -228)
    # (371, 46, 176)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_POSITION mapPositionPool[53] # (371, 46, 176)
#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_RADIUS 30
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY():
    bastionPosition = mapPositionPool.slice(54, 11)
    # (358.414, 64.664, 155.328)
    # (329.109, 48.084, 166.447)
    # (269.63, 68.9, 209.25)
    # (270.34, 42.58, 139.77)
    # (214.64, 53.09, 189.61)
    # (246.75, 55.6, 151.36)
    # (-98.119, 15.423, 46.112)
    # (-103.198, 12.267, 17.698)
    # (-94, 19.5, -28.74)
    # (-68, 16.41, -47.6)
    # (-85.854, 8.087, -0.132)
    resetPosition = mapPositionPool[65] # (371.95, 47.01, 185.5)
    endPosition = mapPositionPool[33] # (-79.07, 12.7, -63.71)
    thirdPersonPosition = mapPositionPool[66] # (370.25, 47, 164.04)
    creditsPosition = mapPositionPool[67] # (380.23, 47.21, 173.1)
    controlJumpPosition = mapPositionPool.slice(68, 1)
    # (209.17, 51.5, 161.47)
    controlRespawnPosition = mapPositionPool.slice(69, 2)
    # (371, 46, 176)
    # (-90.25, 9.25, 90)
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
