#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 伊利奥斯":
    @Condition __currentMap___ == Map.ILIOS
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.ilios"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
        applyPlatformMapRevisionStage()
