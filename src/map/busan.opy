#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_BUSAN_DEFAULT():
    __currentMapText___ = "釜山"
    resetPosition = mapPositionPool[93] # (-409.71, 10.11, 165.61)
    endPosition = mapPositionPool[94] # (158.67, 10.81, 260.91)
    thirdPersonPosition = mapPositionPool[95] # (-410.4, 10.11, 162.37)
    creditsPosition = mapPositionPool[96] # (-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40


#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_POSITION mapPositionPool[97] # (-30.95, 17, -125.55)
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_1_SETUP_RADIUS 30

#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_POSITION mapPositionPool[98] # (291.62, 11.09, 208.25)
#!define platformMapRevision_BUSAN_DEFAULT_COMPOSITE_STAGE_2_SETUP_RADIUS 30
macro platformMapRevision_BUSAN_DEFAULT_ROUTE_0():
    resetPosition = mapPositionPool[93] # (-409.71, 10.11, 165.61)
    endPosition = mapPositionPool[99] # (104.77, 17.74, -137.21)
    thirdPersonPosition = mapPositionPool[95] # (-410.4, 10.11, 162.37)
    creditsPosition = mapPositionPool[96] # (-426.04, 13.11, 165.81)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = mapPositionPool.slice(100, 12)
    # (-387.866, 12.231, 177.954)
    # (-372.397, 12.203, 128.218)
    # (-301.703, 17.422, 167.231)
    # (-330.068, 11.551, 119.593)
    # (-327.409, 11.539, 116.231)
    # (-277.643, 12.071, 176.188)
    # (-4.128, 17.014, -100.22)
    # (36.542, 15.009, -133.395)
    # (65.787, 15.01, -118.11)
    # (51.653, 13.485, -97.256)
    # (79.799, 16.029, -121.293)
    # (102.575, 23, -133.553)
    controlCenterPosition = mapPositionPool.slice(112, 2)
    # (-328.53, 8.17, 153.32)
    # (51.89, 14.5, -114.7)
    controlJumpPosition = mapPositionPool.slice(114, 1)
    # (-251.99, 11.34, 174.77)
    controlRespawnPosition = mapPositionPool.slice(115, 2)
    # (-426.04, 12.67, 165.81)
    # (-30.95, 17.2, -125.55)

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_1():
    resetPosition = mapPositionPool[117] # (-30.05, 17, -118.12)
    endPosition = mapPositionPool[94] # (158.67, 10.81, 260.91)
    thirdPersonPosition = mapPositionPool[118] # (-30.05, 17, -133.42)
    creditsPosition = mapPositionPool[119] # (-43.73, 19, -125.54)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = mapPositionPool.slice(120, 12)
    # (-4.128, 17.014, -100.22)
    # (36.542, 15.009, -133.395)
    # (65.787, 15.01, -118.11)
    # (51.653, 13.485, -97.256)
    # (79.799, 16.029, -121.293)
    # (102.575, 23, -133.553)
    # (269.78, 14.352, 213.057)
    # (236.195, 15.616, 223.324)
    # (206.817, 20.42, 205.305)
    # (224.696, 16.14, 246.115)
    # (165.586, 11.095, 265.157)
    # (187.898, 18.595, 244.477)
    controlCenterPosition = mapPositionPool.slice(132, 2)
    # (51.89, 14.5, -114.7)
    # (222.72, 9.24, 241.77)
    controlJumpPosition = mapPositionPool.slice(134, 1)
    # (104.77, 17.74, -137.21)
    controlRespawnPosition = mapPositionPool.slice(135, 2)
    # (-30.95, 17.2, -125.55)
    # (291.62, 12.16, 208.25)

macro platformMapRevision_BUSAN_DEFAULT_ROUTE_2():
    resetPosition = mapPositionPool[137] # (282.34, 12.1, 201.72)
    endPosition = mapPositionPool[114] # (-251.99, 11.34, 174.77)
    thirdPersonPosition = mapPositionPool[138] # (289.73, 12.1, 199.05)
    creditsPosition = mapPositionPool[139] # (297.09, 14.1, 208.95)
    controlRespawnAxis = 0
    controlRespawnAxisThreshold = 40
    bastionPosition = mapPositionPool.slice(140, 12)
    # (269.78, 14.352, 213.057)
    # (236.195, 15.616, 223.324)
    # (206.817, 20.42, 205.305)
    # (224.696, 16.14, 246.115)
    # (165.586, 11.095, 265.157)
    # (187.898, 18.595, 244.477)
    # (-387.866, 12.231, 177.954)
    # (-372.397, 12.203, 128.218)
    # (-301.703, 17.422, 167.231)
    # (-330.068, 11.551, 119.593)
    # (-327.409, 11.539, 116.231)
    # (-277.643, 12.071, 176.188)
    controlCenterPosition = mapPositionPool.slice(152, 2)
    # (222.72, 9.24, 241.77)
    # (-328.53, 8.17, 153.32)
    controlJumpPosition = mapPositionPool.slice(154, 1)
    # (158.67, 10.81, 260.91)
    controlRespawnPosition = mapPositionPool.slice(155, 2)
    # (291.62, 12.16, 208.25)
    # (-426.04, 12.67, 165.81)

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
