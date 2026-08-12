#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 新皇后街":
    @Condition __currentMap___ == Map.NEW_QUEEN_STREET
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.new_queen_street"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
