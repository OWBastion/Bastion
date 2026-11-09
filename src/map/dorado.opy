#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_DORADO_DEFAULT():
    __currentMapText___ = "多拉多"

    bastionPosition = mapPositionPool.slice(192, 8)
    # (167.25, 10.85, 42.4)
    # (113.04, 13.8, 24.63)
    # (112.06, 17.25, -2.91)
    # (102.79, 11.01, -23.56)
    # (78.973, 17.48, -6.843)
    # (34.78, 10.05, -6.8)
    # (32.21, 10.59, 20.55)
    # (8.83, 2.38, 25.76)
    resetPosition = mapPositionPool[200] # (183.3, 7.04, 37.96)
    endPosition = mapPositionPool[201] # (15.47, 9.54, -1)
    thirdPersonPosition = mapPositionPool[202] # (182.47, 7.04, 42.27)
    creditsPosition = mapPositionPool[203] # (197.72, 10.01, 44.63)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - dorado":
    @Condition __currentMap___ == Map.DORADO
    
    platformMapRevision_DORADO_DEFAULT()
    startForcingSpawn(Team.1, 1)
