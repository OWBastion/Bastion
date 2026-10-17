#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_VOLSKAYA_DEFAULT():
    __currentMapText___ = "沃斯卡娅工业区"

    bastionPosition = mapPositionPool.slice(680, 8)
    resetPosition = mapPositionPool[688]
    endPosition = mapPositionPool[689]
    thirdPersonPosition = mapPositionPool[690]
    creditsPosition = mapPositionPool[691]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - volskaya industries":
    @Condition __currentMap___ == Map.VOLSKAYA
    
    platformMapRevision_VOLSKAYA_DEFAULT()
    __currentMapText___ = "沃斯卡娅"
    startForcingSpawn(Team.1, 0)
