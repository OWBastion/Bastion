#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 南极半岛":
    @Condition (getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177) == true

    __currentMapPioneerText___ = "科研先锋"
    __currentPioneerText___ = ""
    
    #0 = X轴 1 = Y轴 2 = Z轴
    controlRespawnAxis = 2
    #距离阈值
    controlRespawnAxisThreshold = 40
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)

    bastionPosition = [
        vect(-98.119, 15.423, 46.112), vect(-103.198, 12.267, 17.698), vect(-94, 19.5, -28.74), vect(-63.558, 14.947, -46.977), vect(-85.854, 8.087, -0.132), 
        vect(244.902, -1, -226.505), vect(236.299, -3.86, -255.149), vect(283.34, 28.04,-201.87), vect(318.253, -4.899, -211.882), vect(336.311, -6.618, -242.569), vect(283.936, -8.688, -253.317), 
        vect(358.414, 64.664, 155.328), vect(329.109, 48.084, 166.447), vect(269.63, 68.9, 209.25), vect(270.34, 42.58, 139.77), vect(214.64, 53.09, 189.61), vect(246.75, 55.6, 151.36)
    ]

    if len(getPlayersInRadius(vect(-90.25, 9.25, 90.00), 30, Team.1)) != 0:
        controlRespawnPosition = vect(-90.25, 9.25, 90.00)
        controlRespawnPosition.append(vect(175.87,-9.5,-228))
        bastionPosition = bastionPosition.slice(0, 11)
        #冰下层-破冰船 传送点
        controlJumpPosition = vect(-79.07,12.7,-63.71)
        endPosition = vect(354.1,-9.50,-226.25)
        resetPosition = vect(-95.12,9.47,90.05)
        thirdPersonPosition = vect(-76.97,9.04,87)
        creditsPosition = vect(-85.96,9.25,98.83)
    
    elif len(getPlayersInRadius(vect(175.87,-9.5,-228), 30, Team.1)) != 0:
        controlRespawnPosition = vect(175.87,-9.5,-228)
        controlRespawnPosition.append(vect(371,46,176))
        bastionPosition = bastionPosition.slice(5, 16)
        #破冰船-研究中心  传送点
        controlJumpPosition = vect(354.1,-9.50,-226.25)
        endPosition = vect(209.17,51.5,161.47)

        resetPosition = vect(173.68,-6.85,-246.89)
        thirdPersonPosition = vect(171.42,-6.88,-236.82)
        creditsPosition = vect(172.58,-8.46,-229.17)
    else:
        controlRespawnPosition = vect(371,46,176)
        controlRespawnPosition.append(vect(-90.25, 9.25, 90.00))
        bastionPosition = bastionPosition.slice(10, 15)
        bastionPosition = bastionPosition.concat([vect(-98.119, 15.423, 46.112), vect(-103.198, 12.267, 17.698), vect(-94, 16.5, -28.74), vect(-63.558, 14.947, -46.977), vect(-85.854, 8.087, -0.132)])

        #研究中心-冰下层  传送点
        controlJumpPosition = vect(209.17,51.5,161.47)
        endPosition = vect(-79.07,12.7,-63.71)

        resetPosition = vect(371.95,47.01,185.5)
        thirdPersonPosition = vect(370.25,47,164.04)
        creditsPosition = vect(380.23,47.21,173.1)

    mapTitlePlayersByKey = [
        DATA_ANTARCTIC_PENINSULA[0].split("-"),
        DATA_ANTARCTIC_PENINSULA[1].split("-"),
        DATA_ANTARCTIC_PENINSULA[2].split("-")
    ]

    waitUntil(len(allTitle) > TITLE.PIONEER, MAX_TIME)
    allTitle[TITLE.PIONEER][1] = vect(109, 171, 235)