#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_CIRCUIT_ROYAL_DEFAULT():
    __currentMapText___ = "皇家赛道"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("皇家赛道")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(97.763, 15.967, 29.045),
        vect(64.607, 19.071, 23.437),
        vect(61.918, 17.956, 15.709),
        vect(88.977, 14.931, -25.352),
        vect(59.133, 29.301, -30.146),
        vect(13.16, 16.52, -44.31),
        vect(10.33, 6, 5.54),
        vect(-23.15, 7.58, 19.14),
        vect(-15.61, 13, -45.26),
        vect(-40.6, 4.25, -35.79),
        vect(-67.822, 6.067, -43.245)
    ]
    resetPosition = vect(129.68, 10, 0.04)
    endPosition = vect(-45.08, 10, -13.37)
    thirdPersonPosition = vect(135.08, 10, -3.31)
    creditsPosition = vect(147.52, 11.5, -10.9)

    mapTitlePlayersByKey = [
        DATA_CIRCUIT_ROYAL[0].split("-"),
        DATA_CIRCUIT_ROYAL[1].split("-"),
        DATA_CIRCUIT_ROYAL[2].split("-")
    ]

macro platformMapRevision_CIRCUIT_ROYAL_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("皇家赛道")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("皇家赛道")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(105.65, 15.95, 14.28),
        vect(56.16, 18.97, 21.78),
        vect(12.3, 13.18, -27.04),
        vect(-28.93, 11, -3.85),
        vect(-14.51, 8, -34.71),
        vect(-62.89, 13.3, -45.44),
        vect(-46.18, 4.22, -69.18)
    ]
    resetPosition = vect(129.68, 10, 0.04)
    endPosition = vect(-76.75, 4.03, -74.17)
    thirdPersonPosition = vect(135.08, 10, -3.31)
    creditsPosition = vect(147.52, 11.5, -10.9)

    mapTitlePlayersByKey = [
        [],
        [],
        [],
        playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "八月八月八", "训犬大师"], "-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 皇家赛道":
    @Condition __currentMap___ == Map.CIRCUIT_ROYAL

    if classicMapVariant == CLASSIC_MAP_VARIANT_CIRCUIT_ROYAL:
        platformMapRevision_CIRCUIT_ROYAL_CLASSIC()
    else:
        platformMapRevision_CIRCUIT_ROYAL_DEFAULT()
    __currentMapClassicText___ = "賽檤の盡頭灬只剩莪"
    startForcingSpawn(Team.1, 2)
