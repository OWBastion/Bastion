#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_DORADO_DEFAULT():
    __currentMapText___ = "多拉多"

    bastionPosition = mapPositionPool.slice(185, 8)
    resetPosition = mapPositionPool[193]
    endPosition = mapPositionPool[194]
    thirdPersonPosition = mapPositionPool[195]
    creditsPosition = mapPositionPool[196]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - dorado":
    @Condition __currentMap___ == Map.DORADO
    
    platformMapRevision_DORADO_DEFAULT()
    startForcingSpawn(Team.1, 1)
