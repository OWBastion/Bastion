#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 新渣客城":
    @Condition (__currentMap___ == Map.NEW_JUNK_CITY or __currentMap___ == 3099) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.new_junk_city"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
