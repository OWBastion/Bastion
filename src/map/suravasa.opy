#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SURAVASA_DEFAULT():
    __currentMapText___ = "苏拉瓦萨"

    bastionPosition = mapPositionPool.slice(641, 9)
    resetPosition = mapPositionPool[650]
    endPosition = mapPositionPool[651]
    thirdPersonPosition = mapPositionPool[652]
    creditsPosition = mapPositionPool[475]
    controlRespawnPosition = mapPositionPool.slice(653, 1)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 50

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 苏拉瓦萨":
    @Condition __currentMap___ == Map.SURAVASA
    
    platformMapRevision_SURAVASA_DEFAULT()
    startForcingSpawn(Team.1, 1)
