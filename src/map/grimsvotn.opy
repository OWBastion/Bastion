#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_A021ED61_DEFAULT():
    __currentMapText___ = "监测站：格里姆火山"

    bastionPosition = mapPositionPool.slice(439, 11)
    # (-122.36, 13.155, -60.554)
    # (-95.895, 15.006, -81.424)
    # (-77.323, 9.769, -84.199)
    # (-115.764, 12.01, -69.951)
    # (-100.756, 12.668, -39.497)
    # (-125.222, 6.47, -26.48)
    # (-51.496, 8, -69.975)
    # (-18.169, 12.827, -82.178)
    # (-18.379, 4.62, -112.326)
    # (6.685, 9.098, -118.302)
    # (-3.923, 4.538, -144.039)
    resetPosition = mapPositionPool[450] # (-148.4, 6.86, -65.1)
    endPosition = mapPositionPool[451] # (-4, 2.88, -146.45)
    thirdPersonPosition = mapPositionPool[452] # (-143.45, 6.86, -68.19)
    creditsPosition = mapPositionPool[453] # (-146.73, 2, -141.47)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 监测站：格里姆火山":
    @Condition __currentMap___ == Map.GRIMSVOTN

    platformMapRevision_NEW_A021ED61_DEFAULT()
    startForcingSpawn(Team.1, 0)
