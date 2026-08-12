#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - horizon lunar colony":
    @Condition __currentMap___ == Map.HORIZON_LUNAR_COLONY
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.horizon_lunar_colony"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "月球基地"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 0)
