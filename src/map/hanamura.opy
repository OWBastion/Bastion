#!mainFile "../main.opy"

#!optimizeStrict

rule "map - 花村":
    @Condition (__currentMap___ == Map.HANAMURA or __currentMap___ == 1848 or __currentMap___ == Map.HANAMURA_WINTER) == true
    @Condition platformMapRevisionLoaded == false

    platformMapRevisionMapId = "map.hanamura"
    platformMapRevisionVariant = "classic" if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA else null
    applyPlatformMapRevision()
    __currentMapClassicText___ = "ミ櫻花落亽噯成殤"
