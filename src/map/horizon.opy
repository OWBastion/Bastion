#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT():
    __currentMapText___ = "月球基地"

    bastionPosition = mapPositionPool.slice(303, 6)
    resetPosition = mapPositionPool[309]
    endPosition = mapPositionPool[310]
    thirdPersonPosition = mapPositionPool[311]
    creditsPosition = mapPositionPool[312]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - horizon lunar colony":
    @Condition __currentMap___ == Map.HORIZON_LUNAR_COLONY
    
    platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT()
    __currentMapText___ = "月球基地"
    startForcingSpawn(Team.1, 0)
