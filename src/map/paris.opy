#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_PARIS_DEFAULT():
    __currentMapText___ = "巴黎"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")

    bastionPosition = mapPositionPool.slice(546, 6)
    resetPosition = mapPositionPool[552]
    endPosition = mapPositionPool[553]
    thirdPersonPosition = mapPositionPool[554]
    creditsPosition = mapPositionPool[555]

macro platformMapRevision_PARIS_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")

    bastionPosition = mapPositionPool.slice(556, 6)
    resetPosition = mapPositionPool[552]
    endPosition = mapPositionPool[553]
    thirdPersonPosition = mapPositionPool[554]
    creditsPosition = mapPositionPool[555]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - paris":
    @Condition __currentMap___ == Map.PARIS

    if classicMapVariant == CLASSIC_MAP_VARIANT_PARIS:
        platformMapRevision_PARIS_CLASSIC()
    else:
        platformMapRevision_PARIS_DEFAULT()
    __currentMapClassicText___ = "塞納河畔灬噯已散場"
    startForcingSpawn(Team.1, 1)
