#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_JUNKERTOWN_DEFAULT():
    __currentMapText___ = "渣客镇"

    bastionPosition = mapPositionPool.slice(367, 7)
    resetPosition = mapPositionPool[374]
    endPosition = mapPositionPool[375]
    thirdPersonPosition = mapPositionPool[376]
    creditsPosition = mapPositionPool[377]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - junkertown":
    @Condition __currentMap___ == Map.JUNKERTOWN
    
    platformMapRevision_JUNKERTOWN_DEFAULT()
    startForcingSpawn(Team.1, 2)
