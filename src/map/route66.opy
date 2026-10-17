#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ROUTE66_DEFAULT():
    __currentMapText___ = "66号公路"

    bastionPosition = mapPositionPool.slice(574, 7)
    resetPosition = mapPositionPool[581]
    endPosition = mapPositionPool[582]
    thirdPersonPosition = mapPositionPool[583]
    creditsPosition = mapPositionPool[584]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - route 66":
    @Condition __currentMap___ == Map.ROUTE66
    
    platformMapRevision_ROUTE66_DEFAULT()
    startForcingSpawn(Team.1, 1)
