#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 鲁纳塞彼":
    @Condition (__currentMap___ == Map.RUNASAPI or __currentMap___ == 8048) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.runasapi"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
