#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_JUNK_CITY_DEFAULT():
    __currentMapText___ = "新渣客城"

    bastionPosition = mapPositionPool.slice(454, 12)
    # (-45.678, 8.298, 88.433)
    # (-74.958, 6.937, 72.937)
    # (-76.296, 7.756, 40.01)
    # (-74.877, 6.937, 7.044)
    # (-78.144, -0.941, -19.954)
    # (-55.165, 8.251, -0.152)
    # (-25.305, 9.706, 32.074)
    # (13.116, 4.058, 87.188)
    # (-15.766, 7.025, 0.028)
    # (-31.324, 8.111, -39.913)
    # (-85.606, 0.947, 44.387)
    # (-74.415, 4.499, -63.359)
    resetPosition = mapPositionPool[466] # (5.33, 8.14, 109.05)
    endPosition = mapPositionPool[467] # (-43, 28.65, -39.96)
    thirdPersonPosition = mapPositionPool[468] # (2.08, 8.02, 109.16)
    creditsPosition = mapPositionPool[469] # (0.68, 11.77, 120.02)
    controlJumpPosition = mapPositionPool.slice(470, 1)
    # (-91.45, 2, -5.21)
    controlRespawnPosition = mapPositionPool.slice(471, 2)
    # (-0.7, 8.02, 113.02)
    # (-118.06, 30.58, -2.12)
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30
    portalPosition = mapPositionPool.slice(473, 2)
    # (-91.45, 2, -5.21)
    # (-118.06, 30.58, -2.12)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 新渣客城":
    @Condition (__currentMap___ == Map.NEW_JUNK_CITY or __currentMap___ == 3099) == true

    platformMapRevision_NEW_JUNK_CITY_DEFAULT()
    startForcingSpawn(Team.1, 1)
