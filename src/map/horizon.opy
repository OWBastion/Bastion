#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT():
    __currentMapText___ = "月球基地"

    bastionPosition = mapPositionPool.slice(307, 11)
    # (-22.864, 9.09, -142.979)
    # (-35.879, 10.01, -123.692)
    # (-41.905, 7.976, -103.056)
    # (-0.83, 9.154, -81.664)
    # (7.424, 11.863, -98.89)
    # (23.59, 21.719, -83.503)
    # (51.56, 14, -78.802)
    # (48.87, 9.426, -62.885)
    # (63.909, 14.063, -60.577)
    # (40.157, 12.013, -40.984)
    # (42.736, 9.469, -28.141)
    resetPosition = mapPositionPool[318] # (-45.62, 5, -156.87)
    endPosition = mapPositionPool[319] # (34.476, 12, -23.518)
    thirdPersonPosition = mapPositionPool[320] # (-41.39, 5, -159.03)
    creditsPosition = mapPositionPool[321] # (-55.87, 7.68, -171.97)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - horizon lunar colony":
    @Condition __currentMap___ == Map.HORIZON_LUNAR_COLONY
    
    platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT()
    mapPositionPool = []
    __currentMapText___ = "月球基地"
    startForcingSpawn(Team.1, 0)
