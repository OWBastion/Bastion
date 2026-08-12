#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 埃斯佩兰萨":
    @Condition (__currentMap___ == Map.ESPERANCA or __currentMap___ == 276) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.esperanca"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
