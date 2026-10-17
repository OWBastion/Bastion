#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HOLLYWOOD_DEFAULT():
    __currentMapText___ = "好莱坞"

    bastionPosition = mapPositionPool.slice(291, 8)
    resetPosition = mapPositionPool[299]
    endPosition = mapPositionPool[300]
    thirdPersonPosition = mapPositionPool[301]
    creditsPosition = mapPositionPool[302]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - hollywood":
    @Condition (__currentMap___ == Map.HOLLYWOOD or __currentMap___ == 1505) == true
    
    platformMapRevision_HOLLYWOOD_DEFAULT()
    __currentMapText___ = "好莱坞"
    startForcingSpawn(Team.1, 2)
