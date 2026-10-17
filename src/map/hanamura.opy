#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_HANAMURA_DEFAULT():
    __currentMapText___ = "花村"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")

    bastionPosition = mapPositionPool.slice(245, 9)
    resetPosition = mapPositionPool[254]
    endPosition = mapPositionPool[255]
    thirdPersonPosition = mapPositionPool[256]
    creditsPosition = mapPositionPool[257]

macro platformMapRevision_HANAMURA_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")

    bastionPosition = mapPositionPool.slice(258, 6)
    resetPosition = mapPositionPool[254]
    endPosition = mapPositionPool[264]
    thirdPersonPosition = mapPositionPool[256]
    creditsPosition = mapPositionPool[257]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 花村":
    @Condition (__currentMap___ == Map.HANAMURA or __currentMap___ == 1848 or __currentMap___ == Map.HANAMURA_WINTER) == true

    if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA:
        platformMapRevision_HANAMURA_CLASSIC()
    else:
        platformMapRevision_HANAMURA_DEFAULT()
    __currentMapClassicText___ = "ミ櫻花落亽噯成殤"
