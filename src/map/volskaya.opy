#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - volskaya industries":
    @Condition __currentMap___ == Map.VOLSKAYA
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.volskaya"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "沃斯卡娅"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 0)
