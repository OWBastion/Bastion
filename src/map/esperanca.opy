#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ESPERANCA_DEFAULT():
    __currentMapText___ = "埃斯佩兰萨"

    bastionPosition = mapPositionPool.slice(228, 12)
    resetPosition = mapPositionPool[240]
    endPosition = mapPositionPool[241]
    thirdPersonPosition = mapPositionPool[242]
    creditsPosition = mapPositionPool[243]
    springBoardPosition = mapPositionPool[244]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 埃斯佩兰萨":
    @Condition (__currentMap___ == Map.ESPERANCA or __currentMap___ == 276) == true
    
    platformMapRevision_ESPERANCA_DEFAULT()
    startForcingSpawn(Team.1, 2)
