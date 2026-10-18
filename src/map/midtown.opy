#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_MIDTOWN_DEFAULT():
    __currentMapText___ = "中城"

    bastionPosition = mapPositionPool.slice(391, 10)
    # (59.17, 9.847, -6.159)
    # (118.361, 5.867, -78.645)
    # (133.892, 5.637, -53.775)
    # (92.256, 8.438, -22.921)
    # (77.01, 13.219, -20.601)
    # (43.662, 8.805, 12.811)
    # (59.729, 9.199, 38.82)
    # (7.768, 9.061, 44.804)
    # (11.395, 9.676, 91.561)
    # (-13.854, 9.931, 73.748)
    resetPosition = mapPositionPool[401] # (119.51, 1.84, -104.94)
    endPosition = mapPositionPool[402] # (12.91, 3.75, 127.69)
    thirdPersonPosition = mapPositionPool[403] # (133.91, 1.84, -104.94)
    creditsPosition = mapPositionPool[404] # (126.5, 3, -125.37)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 中城":
    @Condition __currentMap___ == Map.MIDTOWN
    
    platformMapRevision_MIDTOWN_DEFAULT()
    startForcingSpawn(Team.1, 2)
