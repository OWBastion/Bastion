#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NUMBANI_DEFAULT():
    __currentMapText___ = "努巴尼"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("努巴尼")

    bastionPosition = [
        vect(203.716, 0.209, -0.271),
        vect(151.942, 4.337, -5.45),
        vect(127.026, 2.25, 17.094),
        vect(123.932, -3.925, -10.396),
        vect(85.613, 6.25, 20.496),
        vect(87.894, 1.89, -3.3),
        vect(39.195, 5.496, 6.518),
        vect(32.85, 3.119, 34.634),
        vect(69.994, 6.25, 15.541),
        vect(118.084, 4.25, 3.814)
    ]
    resetPosition = vect(224.54, 0.2, 0.39)
    endPosition = vect(23, 3.12, 39.72)
    thirdPersonPosition = vect(225.74, 0.2, 4.55)
    creditsPosition = vect(254.54, 3.2, 22.87)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - numbani":
    @Condition __currentMap___ == Map.NUMBANI

    __currentMapText___ = "努巴尼"
    bastionPosition = [
        vect(78.559, 5.250, -21),
        vect(39.048, 5.505, 9.138),
        vect(27.073, 0.073, 10.578),
        vect(67.304, 0.994, 6.553),
        vect(127.331, -4.796, -8.442),
        vect(162.479, 4.250, -3.873),
        vect(161.207, -3.927, 7.055),
        vect(147.639, -1.686, 36.638),
        vect(191.210, 4.388, 33.519),
        vect(224.667, 0.199, 22.715),
        vect(194.448, 2.065, 40.147)
    ]
    endPosition = vect(201.98, 4.2, 38.77)
    thirdPersonPosition = vect(-5.17, 3.24, 16.69)
    resetPosition = vect(-5.12, 3.24, 19.74)
    minefieldPosition = [
        vect(207.47, 0.2, 38.61),
        vect(92.64, 0.25, -9.18),
        vect(54.87, -1.92, 19.53)
    ]
    startForcingSpawn(Team.2, 0)
