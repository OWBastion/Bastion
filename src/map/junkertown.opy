#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_JUNKERTOWN_DEFAULT():
    __currentMapText___ = "渣客镇"

    bastionPosition = mapPositionPool.slice(346, 7)
    # (-101.37, 12.72, -135.27)
    # (-72.634, 6.669, -145.321)
    # (-57.67, 13.98, -92.45)
    # (-27.85, 14.52, -97.33)
    # (-25.34, 8.29, -36.47)
    # (-5.66, 14.63, -74.46)
    # (32.15, 15.16, -89.13)
    resetPosition = mapPositionPool[353] # (-103.91, 11.69, -86.6)
    endPosition = mapPositionPool[354] # (30.248, 5.515, -81.733)
    thirdPersonPosition = mapPositionPool[355] # (-88.03, 11.22, -88)
    creditsPosition = mapPositionPool[356] # (-92.71, 14.04, -73.79)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - junkertown":
    @Condition __currentMap___ == Map.JUNKERTOWN
    
    platformMapRevision_JUNKERTOWN_DEFAULT()
    startForcingSpawn(Team.1, 2)
