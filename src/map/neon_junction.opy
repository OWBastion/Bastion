#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEON_JUNCTION_DEFAULT():
    __currentMapText___ = "霓虹枢纽"

    bastionPosition = mapPositionPool.slice(405, 9)
    # (0.708, 4.061, 388.523)
    # (-12.132, 8.845, 372.132)
    # (19.299, 2.75, 355.878)
    # (1.929, 8.359, 320.916)
    # (35.587, 7.414, 295.986)
    # (35.936, 7.413, 287.017)
    # (5.606, 12.76, 268.637)
    # (15.272, 5.226, 241.462)
    # (-22.805, 6.146, 239.808)
    resetPosition = mapPositionPool[414] # (2.31, 0.75, 431.46)
    endPosition = mapPositionPool[415] # (-12.85, 8.09, 220.7)
    thirdPersonPosition = mapPositionPool[416] # (-17.28, 0.75, 431.46)
    creditsPosition = mapPositionPool[417] # (-7.51, 4.05, 438.32)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 霓虹枢纽":
    @Condition (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true

    platformMapRevision_NEON_JUNCTION_DEFAULT()
    startForcingSpawn(Team.1, 2)
