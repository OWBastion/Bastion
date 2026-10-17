#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT():
    __currentMapText___ = "阿努比斯神殿"

    bastionPosition = mapPositionPool.slice(648, 7)
    resetPosition = mapPositionPool[655]
    endPosition = mapPositionPool[656]
    thirdPersonPosition = mapPositionPool[657]
    creditsPosition = mapPositionPool[658]
    springBoardPosition = mapPositionPool[659]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - temple of anubis":
    @Condition __currentMap___ == Map.TEMPLE_OF_ANUBIS
    
    platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT()
    startForcingSpawn(Team.1, 1)
