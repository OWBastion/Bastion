#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 萨摩亚":
    @Condition (__currentMap___ == Map.SAMOA or __currentMap___ == 13628) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.samoa"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
