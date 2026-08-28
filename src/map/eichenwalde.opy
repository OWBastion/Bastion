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
        vect(124.187, 18.867, -24.169),
        vect(117.679, 18.855, -45.604),
        vect(93.569, 14.465, -62.383),
        vect(96.688, 16.815, -73.03),
        vect(53.939, 10.186, -58.676),
        vect(50.619, 17.944, -99.546),
        vect(14.67, 5.927, -29.211),
        vect(13.209, 11.012, -82.084),
        vect(-3.317, 5.01, -13.158)
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
        [],
        [],
        [],
        []
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - eichenwalde":
    @Condition (__currentMap___ == Map.EICHENWALDE) == true

    platformMapRevision_EICHENWALDE_DEFAULT()
    startForcingSpawn(Team.1, 2)
