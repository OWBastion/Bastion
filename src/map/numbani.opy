#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NUMBANI_DEFAULT():
    __currentMapText___ = "努巴尼"

    bastionPosition = mapPositionPool.slice(488, 10)
    # (203.716, 0.209, -0.271)
    # (151.942, 4.337, -5.45)
    # (127.026, 2.25, 17.094)
    # (123.932, -3.925, -10.396)
    # (85.613, 6.25, 20.496)
    # (87.894, 1.89, -3.3)
    # (39.195, 5.496, 6.518)
    # (32.85, 3.119, 34.634)
    # (69.994, 6.25, 15.541)
    # (118.084, 4.25, 3.814)
    resetPosition = mapPositionPool[498] # (224.54, 0.2, 0.39)
    endPosition = mapPositionPool[499] # (23, 3.12, 39.72)
    thirdPersonPosition = mapPositionPool[500] # (225.74, 0.2, 4.55)
    creditsPosition = mapPositionPool[501] # (254.54, 3.2, 22.87)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - numbani":
    @Condition __currentMap___ == Map.NUMBANI
    
    platformMapRevision_NUMBANI_DEFAULT()
    startForcingSpawn(Team.1, 1)
