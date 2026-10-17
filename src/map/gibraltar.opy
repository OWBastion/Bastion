#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT():
    __currentMapText___ = "直布罗陀"

    bastionPosition = mapPositionPool.slice(238, 9)
    resetPosition = mapPositionPool[247]
    endPosition = mapPositionPool[248]
    thirdPersonPosition = mapPositionPool[249]
    creditsPosition = mapPositionPool[250]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    
    platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT()
    __currentMapText___ = "直布罗陀"
    startForcingSpawn(Team.1, 2)
