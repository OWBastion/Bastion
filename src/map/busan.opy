#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

globalvar platformMapRevision_BUSAN_COMPOSITE_AVAILABLE_STAGE_INDICES
globalvar platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES
globalvar platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX
globalvar platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER
globalvar platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS
globalvar platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED

macro platformMapRevision_BUSAN_DEFAULT():
    __currentMapText___ = "釜山"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("釜山")
    resetPosition = vect(-409.71, 10.11, 165.61)
    endPosition = vect(158.67, 10.81, 260.91)
    thirdPersonPosition = vect(-410.4, 10.11, 162.37)
    creditsPosition = vect(-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40


macro platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_0(stageOrder):
    platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS = compressed([
        vect(-387.866, 12.231, 177.954),
        vect(-372.397, 12.203, 128.218),
        vect(-301.703, 17.422, 167.231),
        vect(-330.068, 11.551, 119.593),
        vect(-327.409, 11.539, 116.231),
        vect(-277.643, 12.071, 176.188)
    ])
    if stageOrder == 0:
        bastionPosition = platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS
    else:
        bastionPosition.append(platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS)
    if platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED != true:
        controlCenterPosition = []
        platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED = true
    controlCenterPosition.append(vect(-328.53, 8.17, 153.32))
    if stageOrder < 1:
        controlJumpPosition.append(vect(-251.99, 11.34, 174.77))
    controlRespawnPosition.append(vect(-426.04, 11.11, 165.81))


#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_POSITION vect(-30.95, 17, -125.55)
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_RADIUS 30
macro platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1(stageOrder):
    platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS = compressed([
        vect(-4.128, 17.014, -100.22),
        vect(36.542, 15.009, -133.395),
        vect(65.787, 15.01, -118.11),
        vect(51.653, 13.485, -97.256),
        vect(79.799, 16.029, -121.293),
        vect(102.575, 23, -133.553)
    ])
    if stageOrder == 0:
        bastionPosition = platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS
    else:
        bastionPosition.append(platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS)
    if platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED != true:
        controlCenterPosition = []
        platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED = true
    controlCenterPosition.append(vect(51.89, 14.5, -114.7))
    if stageOrder < 1:
        controlJumpPosition.append(vect(104.77, 17.74, -137.21))
    controlRespawnPosition.append(vect(-30.95, 17, -125.55))


#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_POSITION vect(291.62, 11.09, 208.25)
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_RADIUS 30
macro platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2(stageOrder):
    platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS = compressed([
        vect(269.78, 14.352, 213.057),
        vect(236.195, 15.616, 223.324),
        vect(206.817, 20.42, 205.305),
        vect(224.696, 16.14, 246.115),
        vect(165.586, 11.095, 265.157),
        vect(187.898, 18.595, 244.477)
    ])
    if stageOrder == 0:
        bastionPosition = platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS
    else:
        bastionPosition.append(platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS)
    if platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED != true:
        controlCenterPosition = []
        platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED = true
    controlCenterPosition.append(vect(222.72, 9.24, 241.77))
    if stageOrder < 1:
        controlJumpPosition.append(vect(158.67, 10.81, 260.91))
    controlRespawnPosition.append(vect(291.62, 11.09, 208.25))

macro platformMapRevision_BUSAN_DEFAULT_SETUP_ROUTE():
    platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED = false
    controlJumpPosition = []
    controlRespawnPosition = []
    platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES = []
    if len(getPlayersInRadius(platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_POSITION, platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX = 1
    elif len(getPlayersInRadius(platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_POSITION, platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX = 2
    else:
        platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX = 0
    platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES.append(platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX)
    for platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER in range(1):
        platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX = (platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX + 1) % 3
        platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES.append(platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX)
    for platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER in range(2):
        if platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES[platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER] == 0:
            platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_0(platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER)
        elif platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES[platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER] == 1:
            platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1(platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER)
        elif platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES[platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER] == 2:
            platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2(platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER)
    platformMapRevision_BUSAN_COMPOSITE_AVAILABLE_STAGE_INDICES = null
    platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDICES = null
    platformMapRevision_BUSAN_COMPOSITE_SELECTED_STAGE_INDEX = null
    platformMapRevision_BUSAN_COMPOSITE_STAGE_ORDER = null
    platformMapRevision_BUSAN_COMPOSITE_STAGE_BASTION_POSITIONS = null
    platformMapRevision_BUSAN_COMPOSITE_CENTER_POSITIONS_INITIALIZED = null


# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 釜山":
    @Condition __currentMap___ == Map.BUSAN

    masteryRunCode = ""
    platformMapRevision_BUSAN_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
