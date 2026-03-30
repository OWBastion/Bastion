#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 阿努比斯王座":
    @Condition (__currentMap___ == Map.THRONE_OF_ANUBIS or __currentMap___ == 886) == true
    
    __currentMapText___ = "王座"
    __currentMapPioneerText___ = __currentMapText___
    controlRespawnAxis = 2
    #距离阈值
    controlRespawnAxisThreshold = 30
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    controlRespawnPosition = vect(11.4, 9.25, 134.12)
    resetPosition = vect(6.28, 9.28, 130.05)
    thirdPersonPosition = vect(3.18, 9.28, 130.71)
    creditsPosition = vect(-157.98, -90.95, -89.77)
    endPosition = vect(-10.49, 8.92, -125.57)
    bastionPosition = [vect(-28.955, 6.079, 65.912), vect(23.873, 21.939, 104.507), vect(0.457, 10.482, 97.234), vect(-7.399, 7.583, 50.502), vect(-1.101, 1.051, 19.039), vect(11.358, 8.052, -15.668), vect(-25.866, 9.142, -44.072), vect(11.875, 7.904, -24.293), vect(-27.944, 5.78, -83.352), vect(-16.021, 5.815, -98.212)]

    mapTitlePlayersByKey = [
        DATA_THRONE_OF_ANUBIS[0].split("-"),
        DATA_THRONE_OF_ANUBIS[1].split("-"),
        DATA_THRONE_OF_ANUBIS[2].split("-")
    ]
