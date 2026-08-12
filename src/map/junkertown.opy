#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - junkertown":
    @Condition __currentMap___ == Map.JUNKERTOWN
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.junkertown"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
