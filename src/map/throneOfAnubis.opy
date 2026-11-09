#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_THRONE_OF_ANUBIS_DEFAULT():
    __currentMapText___ = "阿努比斯王座"

    bastionPosition = mapPositionPool.slice(665, 10)
    # (-28.955, 6.079, 65.912)
    # (23.873, 21.939, 104.507)
    # (0.457, 10.482, 97.234)
    # (-7.399, 7.583, 50.502)
    # (-1.101, 1.051, 19.039)
    # (11.358, 8.052, -15.668)
    # (-25.866, 9.142, -44.072)
    # (11.875, 7.904, -24.293)
    # (-27.944, 5.78, -83.352)
    # (-16.021, 5.815, -98.212)
    resetPosition = mapPositionPool[675] # (6.28, 9.28, 130.05)
    endPosition = mapPositionPool[676] # (-10.49, 8.92, -125.57)
    thirdPersonPosition = mapPositionPool[677] # (3.18, 9.28, 130.71)
    creditsPosition = mapPositionPool[438] # (-157.98, -90.95, -89.77)
    controlRespawnPosition = mapPositionPool.slice(678, 1)
    # (11.4, 9.25, 134.12)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 阿努比斯王座":
    @Condition __currentMap___ == Map.THRONE_OF_ANUBIS or __currentMap___ == 886
    
    platformMapRevision_THRONE_OF_ANUBIS_DEFAULT()
    __currentMapText___ = "王座"
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
