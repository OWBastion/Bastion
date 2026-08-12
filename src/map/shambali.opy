#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - shambali monastery":
    @Condition __currentMap___ == Map.SHAMBALI_MONASTERY
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.shambali_monastery"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "香巴佬寺院"
    __currentMapPioneerText___ = __currentMapText___
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
