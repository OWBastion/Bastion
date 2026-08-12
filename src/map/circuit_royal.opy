#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 皇家赛道":
    @Condition __currentMap___ == Map.CIRCUIT_ROYAL
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.circuit_royal"
    platformMapRevisionVariant = "classic" if classicMapVariant == CLASSIC_MAP_VARIANT_CIRCUIT_ROYAL else null
    applyPlatformMapRevision()
    __currentMapClassicText___ = "賽檤の盡頭灬只剩莪"
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)
