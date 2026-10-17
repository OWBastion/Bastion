#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEON_JUNCTION_DEFAULT():
    __currentMapText___ = "霓虹枢纽"

    bastionPosition = mapPositionPool.slice(405, 9)
    resetPosition = mapPositionPool[414]
    endPosition = mapPositionPool[415]
    thirdPersonPosition = mapPositionPool[416]
    creditsPosition = mapPositionPool[417]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 霓虹枢纽":
    @Condition (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true

    platformMapRevision_NEON_JUNCTION_DEFAULT()
    startForcingSpawn(Team.1, 2)
