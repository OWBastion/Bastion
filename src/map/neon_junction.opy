#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 霓虹枢纽":
    @Condition (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.neon_junction"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapPioneerText___ = "桥元御守"
    __currentPioneerText___ = ""
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)

    waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
    titleColor[TITLE.PIONEER] = vect(250, 120, 115)
