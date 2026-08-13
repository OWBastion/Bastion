#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT():
    platformMapRevisionId = "revision:map.antarctic_peninsula:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "南极半岛"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("南极半岛")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = compressed([
        vect(-98.119, 15.423, 46.112),
        vect(-103.198, 12.267, 17.698),
        vect(-94, 19.5, -28.74),
        vect(-68, 16.41, -47.6),
        vect(-85.854, 8.087, -0.132),
        vect(-113.76, 9.5, -23.19),
        vect(244.902, -1, -226.505),
        vect(236.299, -3.86, -255.149),
        vect(283.34, 28.04, -201.87),
        vect(318.253, -4.899, -211.882),
        vect(336.311, -6.618, -242.569),
        vect(283.936, -8.688, -253.317)
    ])
    resetPosition = vect(-95.12, 9.47, 90.05)
    endPosition = vect(354.1, -9.5, -226.25)
    thirdPersonPosition = vect(-76.97, 9.04, 87)
    creditsPosition = vect(-85.96, 9.25, 98.83)
    controlJumpPosition = [
        vect(-79.07, 12.7, -63.71)
    ]
    controlRespawnPosition = [
        vect(-90.25, 9.25, 90),
        vect(175.87, -9.5, -228)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

    mapTitlePlayersByKey = [
        DATA_ANTARCTIC_PENINSULA[0].split("-"),
        DATA_ANTARCTIC_PENINSULA[1].split("-"),
        DATA_ANTARCTIC_PENINSULA[2].split("-")
    ]

#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_POSITION vect(175.87, -9.5, -228)
#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_RADIUS 30
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER():
    bastionPosition = [
        vect(244.902, -1, -226.505),
        vect(236.299, -3.86, -255.149),
        vect(283.34, 28.04, -201.87),
        vect(318.253, -4.899, -211.882),
        vect(336.311, -6.618, -242.569),
        vect(283.936, -8.688, -253.317),
        vect(358.414, 64.664, 155.328),
        vect(329.109, 48.084, 166.447),
        vect(269.63, 68.9, 209.25),
        vect(270.34, 42.58, 139.77),
        vect(214.64, 53.09, 189.61)
    ]
    resetPosition = vect(173.68, -6.85, -246.89)
    endPosition = vect(209.17, 51.5, 161.47)
    thirdPersonPosition = vect(171.42, -6.88, -236.82)
    creditsPosition = vect(172.58, -8.46, -229.17)
    controlJumpPosition = [
        vect(354.1, -9.5, -226.25)
    ]
    controlRespawnPosition = [
        vect(175.87, -9.5, -228),
        vect(371, 46, 176)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_POSITION vect(371, 46, 176)
#!define platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_RADIUS 30
macro platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY():
    bastionPosition = [
        vect(358.414, 64.664, 155.328),
        vect(329.109, 48.084, 166.447),
        vect(269.63, 68.9, 209.25),
        vect(270.34, 42.58, 139.77),
        vect(214.64, 53.09, 189.61),
        vect(246.75, 55.6, 151.36),
        vect(-98.119, 15.423, 46.112),
        vect(-103.198, 12.267, 17.698),
        vect(-94, 19.5, -28.74),
        vect(-68, 16.41, -47.6),
        vect(-85.854, 8.087, -0.132)
    ]
    resetPosition = vect(371.95, 47.01, 185.5)
    endPosition = vect(-79.07, 12.7, -63.71)
    thirdPersonPosition = vect(370.25, 47, 164.04)
    creditsPosition = vect(380.23, 47.21, 173.1)
    controlJumpPosition = [
        vect(209.17, 51.5, 161.47)
    ]
    controlRespawnPosition = [
        vect(371, 46, 176),
        vect(-90.25, 9.25, 90)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

# END AUTO-GENERATED PLATFORM MAP REVISION

rule "map - 南极半岛":
    @Condition (getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177) == true

    platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT()
    __currentMapPioneerText___ = "科研先锋"
    __currentPioneerText___ = ""
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    if len(getPlayersInRadius(platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_POSITION, platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_ICEBREAKER()
    elif len(getPlayersInRadius(platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_POSITION, platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ANTARCTIC_PENINSULA_DEFAULT_STAGE_LABORATORY()

    waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
    titleColor[TITLE.PIONEER] = vect(109, 171, 235)
