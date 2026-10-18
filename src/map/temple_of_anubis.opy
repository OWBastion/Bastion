#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT():
    __currentMapText___ = "阿努比斯神殿"

    bastionPosition = mapPositionPool.slice(648, 7)
    # (-17.188, 11.237, 105.646)
    # (-3.47, 20.35, 97.61)
    # (-4.69, 22.57, 79.47)
    # (-37.62, 1.91, 47.85)
    # (-25.2, 1.07, 25.16)
    # (-37.5, 16.8, -4.79)
    # (-0.35, 17.87, -24.21)
    resetPosition = mapPositionPool[655] # (-17.16, 4.46, 137.76)
    endPosition = mapPositionPool[656] # (-7.02, -0.66, -36.43)
    thirdPersonPosition = mapPositionPool[657] # (-7.969, 4.701, 137.39)
    creditsPosition = mapPositionPool[658] # (-11.3, 7.35, 149.11)
    springBoardPosition = mapPositionPool[659] # (-47.93, 1.5, 51.33)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - temple of anubis":
    @Condition __currentMap___ == Map.TEMPLE_OF_ANUBIS
    
    platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT()
    startForcingSpawn(Team.1, 1)
