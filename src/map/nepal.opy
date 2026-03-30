#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 尼泊尔":
    @Condition __currentMap___ == Map.NEPAL
    
    controlRespawnAxis = 1
    #距离阈值
    controlRespawnAxisThreshold = 30
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    controlRespawnPosition = vect(-161, -95.97, -84.17)
    #大学重生点
    controlRespawnPosition.append(vect(-39.04, 17.84, -99.75))
    controlRespawnPosition.append(vect(85.52, 132.49, -96.2))
    resetPosition = vect(-165.4, -95.85, -88.15)
    thirdPersonPosition = vect(-158.45, -95.97, -78.36)
    creditsPosition = vect(-157.98, -90.95, -89.77)
    endPosition = vect(103.15, 132, 52.57)
    controlJumpPosition = vect(-148.56, -92.25, 64.75)
    controlJumpPosition.append(vect(-21.67, 21, 81.47))
    bastionPosition = [vect(-152.68, -92.115, -64.862), vect(-193.849, -89.578, -32.592), vect(-199.313, -94.457, 41.386), vect(-146.246, -88.751, 48.509), vect(-26.436, 22, -69.808), vect(-25.182, 13, 0.688), vect(-73.662, 19.545, 0.132), vect(-42.208, 20.025, 51.77), vect(-187.057, -87.686, 7.868), vect(73.112, 129.717, -67.245), vect(94.679, 140.26, -17.696), vect(92.445, 141.37, 49.176)]

    mapTitlePlayersByKey = [
        DATA_NEPAL[0].split("-"),
        DATA_NEPAL[1].split("-"),
        DATA_NEPAL[2].split("-")
    ]
