#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 釜山":
    @Condition __currentMap___ == Map.BUSAN
    @Condition platformMapRevisionLoaded == false

    masteryRunCode = ""
    platformMapRevisionMapId = "map.busan"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
