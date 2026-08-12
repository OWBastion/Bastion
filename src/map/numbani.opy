#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - numbani":
    @Condition __currentMap___ == Map.NUMBANI
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.numbani"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
