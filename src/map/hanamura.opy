#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_HANAMURA_DEFAULT():
    __currentMapText___ = "花村"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-20.75, 9.21, -78.14),
        vect(11.87, 7.21, -47.22),
        vect(28.31, 10.47, 6.6),
        vect(-6.95, 8.01, -10.86),
        vect(49.13, 14.56, 17.96),
        vect(52.2, -1, -0.58),
        vect(15.61, 11.98, 17.47),
        vect(46.87, -0.16, -15.6),
        vect(60.13, -1.04, -15.61)
    ]
    resetPosition = vect(-46.98, 1, -101.54)
    endPosition = vect(51.7, -1.87, 25.91)
    thirdPersonPosition = vect(-33.2, 1, -115.04)
    creditsPosition = vect(-48.1, 2.5, -116.08)

    mapTitlePlayersByKey = [
        DATA_HANAMURA[0].split("-"),
        DATA_HANAMURA[1].split("-"),
        DATA_HANAMURA[2].split("-")
    ]

macro platformMapRevision_HANAMURA_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花村")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-15.46, 9.68, -89.3),
        vect(1.87, 5, -41.04),
        vect(-6.95, 8.01, -10.86),
        vect(27, 0, -7.87),
        vect(34.66, 6, 16.47),
        vect(63.63, 6, -11.98)
    ]
    resetPosition = vect(-46.98, 1, -101.54)
    endPosition = vect(72.38, -1.96, -0.16)
    thirdPersonPosition = vect(-33.2, 1, -115.04)
    creditsPosition = vect(-48.1, 2.5, -116.08)

    mapTitlePlayersByKey = [
        [],
        [],
        [],
        playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "云雀", "八月八月八", "训犬大师"], "-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 花村":
    @Condition (__currentMap___ == Map.HANAMURA or __currentMap___ == 1848 or __currentMap___ == Map.HANAMURA_WINTER) == true

    if classicMapVariant == CLASSIC_MAP_VARIANT_HANAMURA:
        platformMapRevision_HANAMURA_CLASSIC()
    else:
        platformMapRevision_HANAMURA_DEFAULT()
    __currentMapClassicText___ = "ミ櫻花落亽噯成殤"
