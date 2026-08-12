#!mainFile "../main.opy"

#!optimizeStrict

rule "map - paris":
    @Condition __currentMap___ == Map.PARIS
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.paris"
    platformMapRevisionVariant = "classic" if classicMapVariant == CLASSIC_MAP_VARIANT_PARIS else null
    applyPlatformMapRevision()
    __currentMapClassicText___ = "塞納河畔灬噯已散場"
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 1)
