#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 斗兽场":
    @Condition (getCurrentMap() == Map.COLOSSEO or __currentMap___ == 2147) == true
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.colosseo"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
