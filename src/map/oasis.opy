#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_OASIS_DEFAULT():
    platformMapRevisionId = "revision:map.oasis:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "绿洲城"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("绿洲城")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(170.7, 13.57, -216.17),
        vect(123.6, 12, -229.92),
        vect(78.92, 10, -253.17),
        vect(111.34, 13.57, -278.41),
        vect(-196.79, 21.65, 56.69),
        vect(-202.91, 9.12, -0.1),
        vect(-177.5, 20.25, 0.19),
        vect(-183.17, 20.06, -61.79),
        vect(110.54, 2, 283.01),
        vect(140.16, 10, 250.39),
        vect(171.91, 4.12, 277),
        vect(150.98, 3.85, 223.89),
        vect(173.51, 2, 217.63)
    ]
    resetPosition = vect(193.61, 8.42, -197.03)
    endPosition = vect(195.13, 0.85, 172.87)
    thirdPersonPosition = vect(191.33, 8.42, -194.73)
    creditsPosition = vect(204.41, 8.42, -184.71)
    controlCenterPosition = [
        vect(129.5, 15.28, -235.74),
        vect(-192.08, 15, 0.26),
        vect(143.44, 2.15, 247.95)
    ]
    controlJumpPosition = [
        vect(82.13, 5.49, -273.2),
        vect(-175.4, 16, -61.35)
    ]
    controlRespawnPosition = [
        vect(200.46, 6.42, -188.28),
        vect(-195.03, 20, 89.71),
        vect(69.73, 1, 321.16)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 40

    mapTitlePlayersByKey = [
        DATA_OASIS[0].split("-"),
        DATA_OASIS[1].split("-"),
        DATA_OASIS[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 绿洲城":
    @Condition __currentMap___ == Map.OASIS

    platformMapRevision_OASIS_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
