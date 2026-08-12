#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 南极半岛":
    @Condition (getCurrentMap() == Map.ANTARCTIC_PENINSULA or __currentMap___ == 6177) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.antarctic_peninsula"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapPioneerText___ = "科研先锋"
    __currentPioneerText___ = ""
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
        waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
        applyPlatformMapRevisionStage()
        if not platformMapRevisionDataError:
            waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
            titleColor[TITLE.PIONEER] = vect(109, 171, 235)
