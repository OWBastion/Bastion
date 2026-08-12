#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - temple of anubis":
    @Condition __currentMap___ == Map.TEMPLE_OF_ANUBIS
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.temple_of_anubis"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
