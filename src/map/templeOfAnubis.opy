#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT():
    __currentMapText___ = "阿努比斯神殿"

    bastionPosition = mapPositionPool.slice(653, 11)
    # (-30.115, 9.922, 122.607)
    # (-7.842, 4.625, 103.274)
    # (11.571, 4.413, 124.972)
    # (-5.32, 22.584, 79.126)
    # (-13.472, 22.584, 79.761)
    # (-35.951, 17.538, 63.843)
    # (-22.726, 8.029, 41.783)
    # (-26.368, 10.903, 19.658)
    # (-19.242, 21.163, 7.157)
    # (-1.506, 20.195, 17.402)
    # (8.352, 15.617, -16.322)
    resetPosition = mapPositionPool[664] # (-17.16, 4.46, 137.76)
    endPosition = mapPositionPool[665] # (2.45, 0.3, -19.4)
    thirdPersonPosition = mapPositionPool[666] # (-7.969, 4.701, 137.39)
    creditsPosition = mapPositionPool[667] # (-11.3, 7.35, 149.11)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - temple of anubis":
    @Condition __currentMap___ == Map.TEMPLE_OF_ANUBIS
    
    platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT()
    mapPositionPool = []
    startForcingSpawn(Team.1, 1)
