#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - blizzworld":
    @Condition (__currentMap___ == Map.BLIZZ_WORLD or __currentMap___ == 1228) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.blizzard_world"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "暴雪世界"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
