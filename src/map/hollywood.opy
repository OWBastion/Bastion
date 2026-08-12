#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - hollywood":
    @Condition (__currentMap___ == Map.HOLLYWOOD or __currentMap___ == 1505) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.hollywood"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "好莱坞"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
