#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API

macro platformMapRevision_EICHENWALDE_DEFAULT():
    __currentMapText___ = "艾兴瓦尔德"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")

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

macro platformMapRevision_EICHENWALDE_CLASSIC():
    __currentMapText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("艾兴瓦尔德")

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

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - eichenwalde":
    @Condition (__currentMap___ == Map.EICHENWALDE) == true

    __currentMapText___ = "艾兴瓦尔德"
    __currentMapPioneerText___ = "十字军之王"
    bastionPosition = [
        vect(-6.063, 7.205, -22.764),
        vect(20.971, 5.470, -67.047),
        vect(5.458, 11.271, -85.199),
        vect(70.312, 12.812, -70.142),
        vect(49.286, 6.987, -79.333),
        vect(11.803, 9.814, -38.032),
        vect(38.242, 14.378, -95.285),
        vect(90.889, 13.645, -96.644),
        vect(81.945, 15.723, -36.631),
        vect(109.665, 9.609, -45.579),
        vect(113.579, 14.723, -35.492)
    ]
    endPosition = vect(126.62, 14.76, -15)
    thirdPersonPosition = vect(-14.17, 1, -1.02)
    resetPosition = vect(-11.01, 1, -0.74)
    minefieldPosition = [
        vect(20.94, 6, -77.51),
        vect(28.66, 6.4, -47.61),
        vect(71.29, 13.34, -72.97)
    ]
    startForcingSpawn(Team.2, 2)
