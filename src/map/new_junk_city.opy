#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_JUNK_CITY_DEFAULT():
    platformMapRevisionId = "revision:map.new_junk_city:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "新渣客城"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("新渣客城")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-45.678, 8.298, 88.433),
        vect(-74.958, 6.937, 72.937),
        vect(-76.296, 7.756, 40.01),
        vect(-74.877, 6.937, 7.044),
        vect(-78.144, -0.941, -19.954),
        vect(-55.165, 8.251, -0.152),
        vect(-25.305, 9.706, 32.074),
        vect(13.116, 4.058, 87.188),
        vect(-15.766, 7.025, 0.028),
        vect(-31.324, 8.111, -39.913),
        vect(-85.606, 0.947, 44.387),
        vect(-74.415, 4.499, -63.359)
    ]
    resetPosition = vect(5.33, 8.14, 109.05)
    endPosition = vect(-43, 28.65, -39.96)
    thirdPersonPosition = vect(2.08, 8.02, 109.16)
    creditsPosition = vect(0.68, 11.77, 120.02)
    controlJumpPosition = [
        vect(-91.45, 2, -5.21)
    ]
    controlRespawnPosition = [
        vect(-0.7, 8.02, 113.02),
        vect(-118.06, 30.58, -2.12)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30
    portalPosition = [
        vect(-91.45, 2, -5.21),
        vect(-118.06, 30.58, -2.12)
    ]

    mapTitlePlayersByKey = [
        DATA_NEW_JUNK_CITY[0].split("-"),
        DATA_NEW_JUNK_CITY[1].split("-"),
        DATA_NEW_JUNK_CITY[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 新渣客城":
    @Condition (__currentMap___ == Map.NEW_JUNK_CITY or __currentMap___ == 3099) == true

    platformMapRevision_NEW_JUNK_CITY_DEFAULT()
    startForcingSpawn(Team.1, 1)
