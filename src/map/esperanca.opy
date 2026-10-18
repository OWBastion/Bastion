#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ESPERANCA_DEFAULT():
    __currentMapText___ = "埃斯佩兰萨"

    bastionPosition = mapPositionPool.slice(228, 12)
    # (86.815, -0.268, -54.406)
    # (63.789, 1, -57.796)
    # (14.121, 3.261, -42.146)
    # (1.238, 7.966, 13.923)
    # (0.025, -0.002, -33.787)
    # (-15.8, 3.08, -39.1)
    # (-45.384, -1.583, -60.618)
    # (60.25, -6, -93.538)
    # (-26.245, 0, -80.277)
    # (-108.094, -1.002, -60.285)
    # (-71.269, 1.05, -49.368)
    # (0.047, -2, -69.042)
    resetPosition = mapPositionPool[240] # (126.7, -1.64, -81.42)
    endPosition = mapPositionPool[241] # (-117.37, -3, -45.65)
    thirdPersonPosition = mapPositionPool[242] # (126.7, -1.64, -90.03)
    creditsPosition = mapPositionPool[243] # (116.67, -0.29, -82.29)
    springBoardPosition = mapPositionPool[244] # (-73.72, -3, -34.19)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 埃斯佩兰萨":
    @Condition (__currentMap___ == Map.ESPERANCA or __currentMap___ == 276) == true
    
    platformMapRevision_ESPERANCA_DEFAULT()
    startForcingSpawn(Team.1, 2)
