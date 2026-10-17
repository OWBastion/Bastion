#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_EICHENWALDE_DEFAULT():
    __currentMapText___ = "艾兴瓦尔德"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")

    bastionPosition = mapPositionPool.slice(204, 9)
    resetPosition = mapPositionPool[213]
    endPosition = mapPositionPool[214]
    thirdPersonPosition = mapPositionPool[215]
    creditsPosition = mapPositionPool[216]

macro platformMapRevision_EICHENWALDE_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")

    bastionPosition = mapPositionPool.slice(217, 11)
    resetPosition = mapPositionPool[213]
    endPosition = mapPositionPool[214]
    thirdPersonPosition = mapPositionPool[215]
    creditsPosition = mapPositionPool[216]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - eichenwalde":
    @Condition (__currentMap___ == Map.EICHENWALDE) == true

    platformMapRevision_EICHENWALDE_DEFAULT()
    __currentMapPioneerText___ = "十字军之王"
    startForcingSpawn(Team.1, 2)
