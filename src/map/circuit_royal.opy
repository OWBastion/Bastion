#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_CIRCUIT_ROYAL_DEFAULT():
    __currentMapText___ = "皇家赛道"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("皇家赛道")

    bastionPosition = mapPositionPool.slice(150, 11)
    resetPosition = mapPositionPool[161]
    endPosition = mapPositionPool[162]
    thirdPersonPosition = mapPositionPool[163]
    creditsPosition = mapPositionPool[164]

macro platformMapRevision_CIRCUIT_ROYAL_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("皇家赛道")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("皇家赛道")

    bastionPosition = mapPositionPool.slice(165, 7)
    resetPosition = mapPositionPool[161]
    endPosition = mapPositionPool[172]
    thirdPersonPosition = mapPositionPool[163]
    creditsPosition = mapPositionPool[164]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 皇家赛道":
    @Condition __currentMap___ == Map.CIRCUIT_ROYAL

    if classicMapVariant == CLASSIC_MAP_VARIANT_CIRCUIT_ROYAL:
        platformMapRevision_CIRCUIT_ROYAL_CLASSIC()
    else:
        platformMapRevision_CIRCUIT_ROYAL_DEFAULT()
    __currentMapClassicText___ = "賽檤の盡頭灬只剩莪"
    startForcingSpawn(Team.1, 2)
