#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_QUEEN_STREET_DEFAULT():
    __currentMapText___ = "新皇后街"

    bastionPosition = mapPositionPool.slice(481, 9)
    resetPosition = mapPositionPool[490]
    endPosition = mapPositionPool[491]
    thirdPersonPosition = mapPositionPool[492]
    creditsPosition = mapPositionPool[493]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 新皇后街":
    @Condition __currentMap___ == Map.NEW_QUEEN_STREET
    
    platformMapRevision_NEW_QUEEN_STREET_DEFAULT()
    startForcingSpawn(Team.1, 2)
