#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "map - 阿特利斯":
    @Condition (__currentMap___ == Map.AATLIS or __currentMap___ == 1826) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.aatlis"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapPioneerText___ = "织金"
    __currentPioneerText___ = "门徒"
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
