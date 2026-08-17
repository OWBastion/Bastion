#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEPAL_DEFAULT():
    __currentMapText___ = "尼泊尔"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("尼泊尔")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-152.68, -92.115, -64.862),
        vect(-193.849, -89.578, -32.592),
        vect(-199.313, -94.457, 41.386),
        vect(-146.246, -88.751, 48.509),
        vect(-26.436, 22, -69.808),
        vect(-25.182, 13, 0.688),
        vect(-73.662, 19.545, 0.132),
        vect(-42.208, 20.025, 51.77),
        vect(-187.057, -87.686, 7.868),
        vect(73.112, 129.717, -67.245),
        vect(94.679, 140.26, -17.696),
        vect(92.445, 141.37, 49.176)
    ]
    resetPosition = vect(-165.4, -95.85, -88.15)
    endPosition = vect(103.15, 132, 52.57)
    thirdPersonPosition = vect(-158.45, -95.97, -78.36)
    creditsPosition = vect(-157.98, -90.95, -89.77)
    controlJumpPosition = [
        vect(-148.56, -92.25, 64.75),
        vect(-21.67, 21, 81.47)
    ]
    controlRespawnPosition = [
        vect(-161, -95.97, -84.17),
        vect(-39.04, 17.84, -99.75),
        vect(85.52, 132.49, -96.2)
    ]
    controlRespawnAxis = 1
    controlRespawnAxisThreshold = 30

    mapTitlePlayersByKey = [
        DATA_NEPAL[0].split("-"),
        DATA_NEPAL[1].split("-"),
        DATA_NEPAL[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 尼泊尔":
    @Condition __currentMap___ == Map.NEPAL

    platformMapRevision_NEPAL_DEFAULT()
    startForcingSpawn(Team.1, 1)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
