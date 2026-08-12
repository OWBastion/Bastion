#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 绿洲城":
    @Condition __currentMap___ == Map.OASIS
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.oasis"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
