#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ROUTE66_DEFAULT():
    __currentMapText___ = "66号公路"

    bastionPosition = mapPositionPool.slice(574, 7)
    # (-95.624, 12.66, -5.541)
    # (-61.87, 10.87, 5.36)
    # (-38.68, 12.75, -22.136)
    # (-20.44, 12.17, -15.13)
    # (26.871, 7.01, 2.468)
    # (53.82, 12.86, 10.55)
    # (33.75, 5.54, 48.5)
    resetPosition = mapPositionPool[581] # (-115.01, 4.5, -46.01)
    endPosition = mapPositionPool[582] # (47.956, 5.2, 47.318)
    thirdPersonPosition = mapPositionPool[583] # (-115.228, 5.799, -49.59)
    creditsPosition = mapPositionPool[584] # (-113.27, 7.5, -63.14)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - route 66":
    @Condition __currentMap___ == Map.ROUTE66
    
    platformMapRevision_ROUTE66_DEFAULT()
    startForcingSpawn(Team.1, 1)
