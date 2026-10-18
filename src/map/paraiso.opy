#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_PARAISO_DEFAULT():
    __currentMapText___ = "帕拉伊苏"

    bastionPosition = mapPositionPool.slice(527, 9)
    # (-10.3, 6.832, -132.595)
    # (-41.189, 3.79, -155.701)
    # (-1.528, 12.665, -112.339)
    # (10.71, 10.361, -67.628)
    # (-15.164, 9.512, -47.168)
    # (-4.057, 10.45, -18.278)
    # (13.362, 4.189, 13.072)
    # (-43.153, 3, 42.732)
    # (-58.618, 0.007, 19.441)
    resetPosition = mapPositionPool[536] # (-78.3, 5.03, -170.8)
    endPosition = mapPositionPool[537] # (-39.54, -2, 62.86)
    thirdPersonPosition = mapPositionPool[538] # (-78.25, 6.33, -167.96)
    creditsPosition = mapPositionPool[539] # (-70.2, 7.75, -183.14)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - paraiso":
    @Condition __currentMap___ == Map.PARAISO

    platformMapRevision_PARAISO_DEFAULT()

    startForcingSpawn(Team.1, 2)
