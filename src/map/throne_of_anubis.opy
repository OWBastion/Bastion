#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 阿努比斯王座":
    @Condition (__currentMap___ == Map.THRONE_OF_ANUBIS or __currentMap___ == 886) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.throne_of_anubis"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "王座"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
