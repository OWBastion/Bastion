#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_EICHENWALDE_DEFAULT():
    __currentMapText___ = "艾兴瓦尔德"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")

    bastionPosition = mapPositionPool.slice(204, 9)
    # (124.187, 18.867, -24.169)
    # (117.679, 18.855, -45.604)
    # (93.569, 14.465, -62.383)
    # (96.688, 16.815, -73.03)
    # (53.939, 10.186, -58.676)
    # (50.619, 17.944, -99.546)
    # (14.67, 5.927, -29.211)
    # (13.209, 11.012, -82.084)
    # (-3.317, 5.01, -13.158)
    resetPosition = mapPositionPool[213] # (128.06, 10.72, 1.84)
    endPosition = mapPositionPool[214] # (-26.72, 1.97, -34.09)
    thirdPersonPosition = mapPositionPool[215] # (131.335, 10.72, 1.098)
    creditsPosition = mapPositionPool[216] # (132.82, 13.72, 9.04)

macro platformMapRevision_EICHENWALDE_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")

    bastionPosition = mapPositionPool.slice(217, 11)
    # (115.78, 14.732, -29.038)
    # (119.48, 18.855, -43.12)
    # (54.429, 23.32, -102.936)
    # (75.164, 12.66, -71.852)
    # (36.49, 8.938, -71.14)
    # (2.584, 8.026, -63.687)
    # (-12.503, 3.514, -31.548)
    # (0.632, 6.073, -2.154)
    # (-32.381, -1.334, 0.005)
    # (70.234, 18.381, -65.979)
    # (8.544, 10.396, -42.598)
    resetPosition = mapPositionPool[213] # (128.06, 10.72, 1.84)
    endPosition = mapPositionPool[214] # (-26.72, 1.97, -34.09)
    thirdPersonPosition = mapPositionPool[215] # (131.335, 10.72, 1.098)
    creditsPosition = mapPositionPool[216] # (132.82, 13.72, 9.04)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - eichenwalde":
    @Condition (__currentMap___ == Map.EICHENWALDE) == true

    platformMapRevision_EICHENWALDE_DEFAULT()
    __currentMapPioneerText___ = "十字军之王"
    startForcingSpawn(Team.1, 2)
