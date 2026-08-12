#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "map - 阿育陀耶":
    @Condition (__currentMap___ == Map.AYUTTHAYA or __currentMap___ == 1826) == true
    @Condition platformMapRevisionLoaded == false
    
    rebootTime = 5400
    platformMapRevisionMapId = "map.ayutthaya"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapPioneerText___ = "大城"
    __currentPioneerText___ = "守护者"
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
