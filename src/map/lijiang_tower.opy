#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 漓江塔":
    @Condition (__currentMap___ == Map.LIJIANG_TOWER or __currentMap___ == 3676) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.lijiang_tower"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
