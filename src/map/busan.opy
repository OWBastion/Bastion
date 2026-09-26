#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_BUSAN_DEFAULT():
    __currentMapText___ = "釜山"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("釜山")
    resetPosition = vect(-409.71, 10.11, 165.61)
    endPosition = vect(158.67, 10.81, 260.91)
    thirdPersonPosition = vect(-410.4, 10.11, 162.37)
    creditsPosition = vect(-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40


#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_POSITION vect(-30.95, 17, -125.55)
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_RADIUS 30

#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_POSITION vect(291.62, 11.09, 208.25)
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_RADIUS 30
macro platformMapRevision_BUSAN_DEFAULT_ROUTE_0():
    resetPosition = vect(-409.71, 10.11, 165.61)
    endPosition = vect(158.67, 10.81, 260.91)
    thirdPersonPosition = vect(-410.4, 10.11, 162.37)
    creditsPosition = vect(-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = compressed([
        vect(-387.866, 12.231, 177.954),
        vect(-372.397, 12.203, 128.218),
        vect(-301.703, 17.422, 167.231),
        vect(-330.068, 11.551, 119.593),
        vect(-327.409, 11.539, 116.231),
        vect(-277.643, 12.071, 176.188),
        vect(-4.128, 17.014, -100.22),
        vect(36.542, 15.009, -133.395),
        vect(65.787, 15.01, -118.11),
        vect(51.653, 13.485, -97.256),
        vect(79.799, 16.029, -121.293),
        vect(102.575, 23, -133.553)
    ])
    controlCenterPosition = [
        vect(-328.53, 8.17, 153.32),
        vect(51.89, 14.5, -114.7)
    ]
    controlJumpPosition = [
        vect(-251.99, 11.34, 174.77)
    ]
    controlRespawnPosition = [
        vect(-426.04, 11.11, 165.81),
        vect(-30.95, 17, -125.55)
    ]

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_1():
    resetPosition = vect(-409.71, 10.11, 165.61)
    endPosition = vect(158.67, 10.81, 260.91)
    thirdPersonPosition = vect(-410.4, 10.11, 162.37)
    creditsPosition = vect(-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = compressed([
        vect(-4.128, 17.014, -100.22),
        vect(36.542, 15.009, -133.395),
        vect(65.787, 15.01, -118.11),
        vect(51.653, 13.485, -97.256),
        vect(79.799, 16.029, -121.293),
        vect(102.575, 23, -133.553),
        vect(269.78, 14.352, 213.057),
        vect(236.195, 15.616, 223.324),
        vect(206.817, 20.42, 205.305),
        vect(224.696, 16.14, 246.115),
        vect(165.586, 11.095, 265.157),
        vect(187.898, 18.595, 244.477)
    ])
    controlCenterPosition = [
        vect(51.89, 14.5, -114.7),
        vect(222.72, 9.24, 241.77)
    ]
    controlJumpPosition = [
        vect(104.77, 17.74, -137.21)
    ]
    controlRespawnPosition = [
        vect(-30.95, 17, -125.55),
        vect(291.62, 11.09, 208.25)
    ]

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_2():
    resetPosition = vect(-409.71, 10.11, 165.61)
    endPosition = vect(158.67, 10.81, 260.91)
    thirdPersonPosition = vect(-410.4, 10.11, 162.37)
    creditsPosition = vect(-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = compressed([
        vect(269.78, 14.352, 213.057),
        vect(236.195, 15.616, 223.324),
        vect(206.817, 20.42, 205.305),
        vect(224.696, 16.14, 246.115),
        vect(165.586, 11.095, 265.157),
        vect(187.898, 18.595, 244.477),
        vect(-387.866, 12.231, 177.954),
        vect(-372.397, 12.203, 128.218),
        vect(-301.703, 17.422, 167.231),
        vect(-330.068, 11.551, 119.593),
        vect(-327.409, 11.539, 116.231),
        vect(-277.643, 12.071, 176.188)
    ])
    controlCenterPosition = [
        vect(222.72, 9.24, 241.77),
        vect(-328.53, 8.17, 153.32)
    ]
    controlJumpPosition = [
        vect(158.67, 10.81, 260.91)
    ]
    controlRespawnPosition = [
        vect(291.62, 11.09, 208.25),
        vect(-426.04, 11.11, 165.81)
    ]

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
