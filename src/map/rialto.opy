#!mainFile "../main.opy"

#!optimizeStrict

rule "map - rialto":
    @Condition __currentMap___ == Map.RIALTO
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.rialto"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
