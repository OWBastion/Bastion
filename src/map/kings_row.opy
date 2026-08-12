#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - king's row":
    @Condition (__currentMap___ == Map.KINGS_ROW or __currentMap___ == 742) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.kings_row"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "国王大道"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
