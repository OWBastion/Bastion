#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SHAMBALI_MONASTERY_DEFAULT():
    __currentMapText___ = "香巴里寺院"

    bastionPosition = mapPositionPool.slice(626, 11)
    resetPosition = mapPositionPool[637]
    endPosition = mapPositionPool[638]
    thirdPersonPosition = mapPositionPool[639]
    creditsPosition = mapPositionPool[640]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - shambali monastery":
    @Condition __currentMap___ == Map.SHAMBALI_MONASTERY
    
    platformMapRevision_SHAMBALI_MONASTERY_DEFAULT()
    __currentMapText___ = "香巴佬寺院"
    startForcingSpawn(Team.1, 2)
