#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - paraiso":
    @Condition __currentMap___ == Map.PARAISO
    @Condition platformMapRevisionLoaded == false

    masteryRunCode = ""
    platformMapRevisionMapId = "map.paraiso"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
