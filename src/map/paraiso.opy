#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_PARAISO_DEFAULT():
    __currentMapText___ = "帕拉伊苏"

    bastionPosition = mapPositionPool.slice(527, 9)
    resetPosition = mapPositionPool[536]
    endPosition = mapPositionPool[537]
    thirdPersonPosition = mapPositionPool[538]
    creditsPosition = mapPositionPool[539]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - paraiso":
    @Condition __currentMap___ == Map.PARAISO

    platformMapRevision_PARAISO_DEFAULT()

    startForcingSpawn(Team.1, 2)
