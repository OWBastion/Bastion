#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_LIJIANG_TOWER_DEFAULT():
    __currentMapText___ = "漓江塔"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("漓江塔")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(34.55, 33.85, -36.64),
        vect(21.25, 10, -23.95),
        vect(0.93, 0, -9.84),
        vect(3.65, 8.01, -52.48),
        vect(-30.81, 25.99, -14.77),
        vect(41.48, 95.87, 140.62),
        vect(-0.08, 94, 184.97),
        vect(-16.66, 96.5, 120.91),
        vect(-66.07, 94, 150.2),
        vect(46.34, 267, 300.86),
        vect(-10.14, 270.12, 321.4),
        vect(-0.2, 278.01, 290.98),
        vect(2.79, 274.19, 301.82),
        vect(-46.63, 267.11, 300.97)
    ]
    resetPosition = vect(81.11, 4.58, -35.44)
    endPosition = vect(-44.02, 271.64, 349.77)
    thirdPersonPosition = vect(74.43, 4.46, -26.34)
    creditsPosition = vect(84.29, 6.2, -29.44)
    controlJumpPosition = [
        vect(-58.26, 6, -5.24),
        vect(-51.89, 95, 133.97)
    ]
    controlRespawnPosition = [
        vect(84.41, 4.52, -31.57),
        vect(86.21, 96.62, 147.7),
        vect(62.93, 267.64, 349.53)
    ]
    controlRespawnAxis = 1
    controlRespawnAxisThreshold = 40

    mapTitlePlayersByKey = [
        DATA_LIJIANG_TOWER[0].split("-"),
        DATA_LIJIANG_TOWER[1].split("-"),
        DATA_LIJIANG_TOWER[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 漓江塔":
    @Condition (__currentMap___ == Map.LIJIANG_TOWER or __currentMap___ == 3676) == true

    platformMapRevision_LIJIANG_TOWER_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
