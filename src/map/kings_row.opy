#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_KINGS_ROW_DEFAULT():
    __currentMapText___ = "国王大道"

    bastionPosition = mapPositionPool.slice(378, 7)
    resetPosition = mapPositionPool[385]
    endPosition = mapPositionPool[386]
    thirdPersonPosition = mapPositionPool[387]
    creditsPosition = mapPositionPool[388]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - king's row":
    @Condition (__currentMap___ == Map.KINGS_ROW or __currentMap___ == 742) == true
    
    platformMapRevision_KINGS_ROW_DEFAULT()
    __currentMapText___ = "国王大道"
    startForcingSpawn(Team.1, 1)
