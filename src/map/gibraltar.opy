#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT():
    __currentMapText___ = "直布罗陀"

    bastionPosition = mapPositionPool.slice(686, 9)
    # (70.099, 9, 26.803)
    # (86.26, 7.46, 2.95)
    # (61.64, 3.67, -20.79)
    # (46.95, 7.65, -66.08)
    # (32.69, 4.69, -52.38)
    # (21, 4.2, -64.39)
    # (31.85, 7.62, -107.88)
    # (56.88, 9.23, -118.92)
    # (18.08, 8.78, -133.02)
    resetPosition = mapPositionPool[695] # (97.55, 1.06, 60.38)
    endPosition = mapPositionPool[696] # (43.42, 5.15, -129.34)
    thirdPersonPosition = mapPositionPool[697] # (93.88, 1.06, 63.17)
    creditsPosition = mapPositionPool[698] # (112.23, 0, 73.59)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    
    platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT()
    __currentMapText___ = "直布罗陀"
    startForcingSpawn(Team.1, 2)
