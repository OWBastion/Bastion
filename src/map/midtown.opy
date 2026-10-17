#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_MIDTOWN_DEFAULT():
    __currentMapText___ = "中城"

    bastionPosition = mapPositionPool.slice(391, 10)
    resetPosition = mapPositionPool[401]
    endPosition = mapPositionPool[402]
    thirdPersonPosition = mapPositionPool[403]
    creditsPosition = mapPositionPool[404]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 中城":
    @Condition __currentMap___ == Map.MIDTOWN
    
    platformMapRevision_MIDTOWN_DEFAULT()
    startForcingSpawn(Team.1, 2)
