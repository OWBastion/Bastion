#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "map - 苏拉瓦萨":
    @Condition __currentMap___ == Map.SURAVASA
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.suravasa"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapPioneerText___ = "瓦拉纳西"
    __currentPioneerText___ = "守护者"
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
