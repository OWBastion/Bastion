#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_JUNKERTOWN_DEFAULT():
    __currentMapText___ = "渣客镇"

    bastionPosition = mapPositionPool.slice(346, 7)
    resetPosition = mapPositionPool[353]
    endPosition = mapPositionPool[354]
    thirdPersonPosition = mapPositionPool[355]
    creditsPosition = mapPositionPool[356]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - junkertown":
    @Condition __currentMap___ == Map.JUNKERTOWN
    
    platformMapRevision_JUNKERTOWN_DEFAULT()
    startForcingSpawn(Team.1, 2)
