#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_EICHENWALDE_DEFAULT():
    __currentMapText___ = "艾兴瓦尔德"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(115.78, 14.732, -29.038),
        vect(119.48, 18.855, -43.12),
        vect(54.429, 23.32, -102.936),
        vect(75.164, 12.66, -71.852),
        vect(36.49, 8.938, -71.14),
        vect(2.584, 8.026, -63.687),
        vect(-12.503, 3.514, -31.548),
        vect(0.632, 6.073, -2.154),
        vect(-32.381, -1.334, 0.005),
        vect(70.234, 18.381, -65.979),
        vect(8.544, 10.396, -42.598)
    ]
    resetPosition = vect(128.06, 10.72, 1.84)
    endPosition = vect(-26.72, 1.97, -34.09)
    thirdPersonPosition = vect(131.335, 10.72, 1.098)
    creditsPosition = vect(132.82, 13.72, 9.04)

    mapTitlePlayersByKey = [
        DATA_EICHENWALDE[0].split("-"),
        DATA_EICHENWALDE[1].split("-"),
        DATA_EICHENWALDE[2].split("-")
    ]

macro platformMapRevision_EICHENWALDE_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(115.78, 14.732, -29.038),
        vect(119.48, 18.855, -43.12),
        vect(54.429, 23.32, -102.936),
        vect(75.164, 12.66, -71.852),
        vect(36.49, 8.938, -71.14),
        vect(3.66, 9.08, -62.94),
        vect(-12.503, 3.514, -31.548),
        vect(0.632, 6.073, -2.154),
        vect(-32.381, -1.334, 0.005),
        vect(70.234, 18.381, -65.979),
        vect(8.544, 10.396, -42.598)
    ]
    resetPosition = vect(128.06, 10.72, 1.84)
    endPosition = vect(-26.72, 1.97, -34.09)
    thirdPersonPosition = vect(131.335, 10.72, 1.098)
    creditsPosition = vect(132.82, 13.72, 9.04)

    mapTitlePlayersByKey = [
        [],
        [],
        [],
        []
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - eichenwalde":
    @Condition (__currentMap___ == Map.EICHENWALDE or __currentMap___ == 565) == true

    masteryRunCode = ""
    if __currentMap___ == 565:
        platformMapRevision_EICHENWALDE_CLASSIC()
    else:
        platformMapRevision_EICHENWALDE_DEFAULT()
    startForcingSpawn(Team.1, 2)
