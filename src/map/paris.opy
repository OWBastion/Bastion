#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_PARIS_DEFAULT():
    __currentMapText___ = "巴黎"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-95.984, 13.454, -83.535),
        vect(-72.132, 11.976, -44.042),
        vect(-42.867, 18.51, -12.093),
        vect(-30.23, 10.02, 3.28),
        vect(-14.721, 14.25, -35.219),
        vect(-2.715, 10.08, -52.081)
    ]
    resetPosition = vect(-115.03, 15.97, -122.82)
    endPosition = vect(9.563, 8.329, -59.98)
    thirdPersonPosition = vect(-109.263, 15.3, -111.151)
    creditsPosition = vect(-119.74, 19, -132.45)

    mapTitlePlayersByKey = [
        DATA_PARIS[0].split("-"),
        DATA_PARIS[1].split("-"),
        DATA_PARIS[2].split("-")
    ]

macro platformMapRevision_PARIS_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("巴黎")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-95.984, 13.454, -83.535),
        vect(-72.132, 11.976, -44.042),
        vect(-41.725, 13.99, -2.92),
        vect(20, 10.03, -38.5),
        vect(-14.721, 14.25, -35.219),
        vect(0.211, 10.174, -60.874)
    ]
    resetPosition = vect(-115.03, 15.97, -122.82)
    endPosition = vect(9.563, 8.329, -59.98)
    thirdPersonPosition = vect(-109.263, 15.3, -111.151)
    creditsPosition = vect(-119.74, 19, -132.45)

    mapTitlePlayersByKey = [
        [],
        [],
        [],
        playerNameToIndexDelimited(["嘤嘤嘤丶", "吾携秋水揽星河", "卖核弹的小女孩", "云雀", "八月八月八", "训犬大师"], "-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - paris":
    @Condition __currentMap___ == Map.PARIS

    if classicMapVariant == CLASSIC_MAP_VARIANT_PARIS:
        platformMapRevision_PARIS_CLASSIC()
    else:
        platformMapRevision_PARIS_DEFAULT()
    __currentMapClassicText___ = "塞納河畔灬噯已散場"
    startForcingSpawn(Team.1, 1)
