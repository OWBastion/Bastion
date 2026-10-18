#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_AATLIS_DEFAULT():
    __currentMapText___ = "阿特利斯"

    bastionPosition = mapPositionPool.slice(0, 12)
    # (-27.31, 30.462, 99.799)
    # (-45.351, 15.454, 79.671)
    # (-23.956, 16.004, 43.016)
    # (-29.999, 17.009, 17.751)
    # (-87.158, 14.004, -21.012)
    # (-70.585, 13.295, 39.948)
    # (-21.061, 13.813, -64.931)
    # (-45.813, 14.934, -79.517)
    # (4.542, 17.737, 61.038)
    # (-4.835, 12.464, -0.137)
    # (4.44, 17.737, -60.62)
    # (-90.802, 14.002, -60.156)
    resetPosition = mapPositionPool[12] # (16.37, 15, 104.47)
    endPosition = mapPositionPool[13] # (-78.02, 9.19, -39.93)
    thirdPersonPosition = mapPositionPool[14] # (-6.21, 15, 104.33)
    creditsPosition = mapPositionPool[15] # (5.1, 19.5, 105.79)
    controlRespawnPosition = mapPositionPool.slice(16, 1)
    # (4.85, 15.5, 104.6)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 阿特利斯":
    @Condition (__currentMap___ == Map.AATLIS or __currentMap___ == 1826) == true
    
    platformMapRevision_AATLIS_DEFAULT()
    startForcingSpawn(Team.1, 1)
