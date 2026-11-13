#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_HANAMURA_DEFAULT():
    __currentMapText___ = "花村"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")

    bastionPosition = mapPositionPool.slice(245, 11)
    # (-19.486, 7.268, -84.64)
    # (2.807, 5, -71.176)
    # (-14.682, 3, -42.659)
    # (-2.195, 0.649, -53.808)
    # (42.514, 1.585, -57.729)
    # (35.735, 2.002, -24.213)
    # (6.352, 8.059, -11.463)
    # (18.229, 9.604, 14.806)
    # (49.375, 14.557, 18.15)
    # (45.582, 6.009, -9.355)
    # (56.387, 4.257, 13.861)
    resetPosition = mapPositionPool[256] # (-34.66, 1, -98.8)
    endPosition = mapPositionPool[257] # (49.02, 6, 18.79)
    thirdPersonPosition = mapPositionPool[258] # (-30.39, 1, -102.96)
    creditsPosition = mapPositionPool[259] # (-48.1, 2.5, -116.08)

macro platformMapRevision_HANAMURA_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")

    bastionPosition = mapPositionPool.slice(260, 6)
    # (-15.46, 9.68, -89.3)
    # (1.87, 5, -41.04)
    # (-6.95, 8.01, -10.86)
    # (27, 0, -7.87)
    # (34.66, 6, 16.47)
    # (63.63, 6, -11.98)
    resetPosition = mapPositionPool[266] # (-46.98, 1, -101.54)
    endPosition = mapPositionPool[267] # (72.38, -1.96, -0.16)
    thirdPersonPosition = mapPositionPool[268] # (-33.2, 1, -115.04)
    creditsPosition = mapPositionPool[259] # (-48.1, 2.5, -116.08)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 花村":
    @Condition __currentMap___ == Map.HANAMURA or __currentMap___ == 1848 or __currentMap___ == Map.HANAMURA_WINTER

    if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA:
        platformMapRevision_HANAMURA_CLASSIC()
    else:
        platformMapRevision_HANAMURA_DEFAULT()
    mapPositionPool = []
    __currentMapClassicText___ = "ミ櫻花落亽噯成殤"
