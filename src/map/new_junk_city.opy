#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_JUNK_CITY_DEFAULT():
    __currentMapText___ = "新渣客城"

    bastionPosition = mapPositionPool.slice(460, 12)
    resetPosition = mapPositionPool[472]
    endPosition = mapPositionPool[473]
    thirdPersonPosition = mapPositionPool[474]
    creditsPosition = mapPositionPool[475]
    controlJumpPosition = mapPositionPool.slice(476, 1)
    controlRespawnPosition = mapPositionPool.slice(477, 2)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30
    portalPosition = mapPositionPool.slice(479, 2)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 新渣客城":
    @Condition (__currentMap___ == Map.NEW_JUNK_CITY or __currentMap___ == 3099) == true

    platformMapRevision_NEW_JUNK_CITY_DEFAULT()
    startForcingSpawn(Team.1, 1)
