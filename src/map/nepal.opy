#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 尼泊尔":
    @Condition __currentMap___ == Map.NEPAL
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.nepal"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
