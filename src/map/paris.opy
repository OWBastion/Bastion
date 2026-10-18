#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_PARIS_DEFAULT():
    __currentMapText___ = "巴黎"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")

    bastionPosition = mapPositionPool.slice(540, 6)
    # (-95.984, 13.454, -83.535)
    # (-72.132, 11.976, -44.042)
    # (-42.867, 18.51, -12.093)
    # (-30.23, 10.02, 3.28)
    # (-14.721, 14.25, -35.219)
    # (-2.715, 10.08, -52.081)
    resetPosition = mapPositionPool[546] # (-115.03, 15.97, -122.82)
    endPosition = mapPositionPool[547] # (9.563, 8.329, -59.98)
    thirdPersonPosition = mapPositionPool[548] # (-109.263, 15.3, -111.151)
    creditsPosition = mapPositionPool[549] # (-119.74, 19, -132.45)

macro platformMapRevision_PARIS_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")

    bastionPosition = mapPositionPool.slice(550, 6)
    # (-95.984, 13.454, -83.535)
    # (-72.132, 11.976, -44.042)
    # (-41.725, 13.99, -2.92)
    # (20, 10.03, -38.5)
    # (-14.721, 14.25, -35.219)
    # (0.211, 10.174, -60.874)
    resetPosition = mapPositionPool[546] # (-115.03, 15.97, -122.82)
    endPosition = mapPositionPool[547] # (9.563, 8.329, -59.98)
    thirdPersonPosition = mapPositionPool[548] # (-109.263, 15.3, -111.151)
    creditsPosition = mapPositionPool[549] # (-119.74, 19, -132.45)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - paris":
    @Condition __currentMap___ == Map.PARIS

    if classicMapVariant == CLASSIC_MAP_VARIANT_PARIS:
        platformMapRevision_PARIS_CLASSIC()
    else:
        platformMapRevision_PARIS_DEFAULT()
    __currentMapClassicText___ = "塞納河畔灬噯已散場"
    startForcingSpawn(Team.1, 1)
