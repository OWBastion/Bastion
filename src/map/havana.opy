#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HAVANA_DEFAULT():
    __currentMapText___ = "哈瓦那"

    bastionPosition = mapPositionPool.slice(280, 7)
    resetPosition = mapPositionPool[287]
    endPosition = mapPositionPool[288]
    thirdPersonPosition = mapPositionPool[289]
    creditsPosition = mapPositionPool[290]

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - havana":
    @Condition __currentMap___ == Map.HAVANA
    
    platformMapRevision_HAVANA_DEFAULT()
    startForcingSpawn(Team.1, 2)
