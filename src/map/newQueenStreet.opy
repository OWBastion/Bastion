#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_QUEEN_STREET_DEFAULT():
    __currentMapText___ = "新皇后街"

    bastionPosition = mapPositionPool.slice(475, 9)
    # (-74.922, 14.194, -16.661)
    # (-25.688, 4, -22.819)
    # (-29.72, 7.12, -6.68)
    # (-7.696, 4.85, 35.246)
    # (-0.035, 2.376, -11.505)
    # (19.183, 1.477, -27.407)
    # (15.862, 5.063, -12.591)
    # (39.34, 8.1, -12.938)
    # (51.915, 10, -17.308)
    resetPosition = mapPositionPool[484] # (-111.17, 11, -17)
    endPosition = mapPositionPool[485] # (90, 11, -45.9)
    thirdPersonPosition = mapPositionPool[486] # (-111.26, 11, -32.03)
    creditsPosition = mapPositionPool[487] # (-102.08, 17.29, -24.46)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 新皇后街":
    @Condition __currentMap___ == Map.NEW_QUEEN_STREET
    
    platformMapRevision_NEW_QUEEN_STREET_DEFAULT()
    startForcingSpawn(Team.1, 2)
