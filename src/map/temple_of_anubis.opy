#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT():
    __currentMapText___ = "阿努比斯神殿"

    bastionPosition = mapPositionPool.slice(654, 7)
    resetPosition = mapPositionPool[661]
    endPosition = mapPositionPool[662]
    thirdPersonPosition = mapPositionPool[663]
    creditsPosition = mapPositionPool[664]
    springBoardPosition = mapPositionPool[665]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - temple of anubis":
    @Condition __currentMap___ == Map.TEMPLE_OF_ANUBIS
    
    platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT()
    startForcingSpawn(Team.1, 1)
