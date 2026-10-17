#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SURAVASA_DEFAULT():
    __currentMapText___ = "苏拉瓦萨"

    bastionPosition = mapPositionPool.slice(635, 9)
    resetPosition = mapPositionPool[644]
    endPosition = mapPositionPool[645]
    thirdPersonPosition = mapPositionPool[646]
    creditsPosition = mapPositionPool[469]
    controlRespawnPosition = mapPositionPool.slice(647, 1)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 50

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 苏拉瓦萨":
    @Condition __currentMap___ == Map.SURAVASA
    
    platformMapRevision_SURAVASA_DEFAULT()
    startForcingSpawn(Team.1, 1)
