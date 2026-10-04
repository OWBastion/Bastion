#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_MIDTOWN_DEFAULT():
    __currentMapText___ = "中城"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("中城")

    bastionPosition = [
        vect(59.17, 9.847, -6.159),
        vect(118.361, 5.867, -78.645),
        vect(133.892, 5.637, -53.775),
        vect(92.256, 8.438, -22.921),
        vect(77.01, 13.219, -20.601),
        vect(43.662, 8.805, 12.811),
        vect(59.729, 9.199, 38.82),
        vect(7.768, 9.061, 44.804),
        vect(11.395, 9.676, 91.561),
        vect(-13.854, 9.931, 73.748)
    ]
    resetPosition = vect(119.51, 1.84, -104.94)
    endPosition = vect(12.91, 3.75, 127.69)
    thirdPersonPosition = vect(133.91, 1.84, -104.94)
    creditsPosition = vect(126.5, 3, -125.37)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 中城":
    @Condition __currentMap___ == Map.MIDTOWN

    __currentMapText___ = "中城"
    bastionPosition = [
        vect(11.159, 9.676, 96.511),
        vect(-11.167, 7.676, 50.035),
        vect(41.012, 10.858, 23.733),
        vect(55.398, 8.805, 11.518),
        vect(93.034, 3.895, -10.495),
        vect(76.469, 13.220, -21.704),
        vect(74.566, 3.837, -18.930),
        vect(88.150, 9.020, -55.622),
        vect(123.697, 5.791, -34.686),
        vect(139.517, 10.846, -29.034),
        vect(128.522, 1.844, -93.758)
    ]
    endPosition = vect(143.25, 2.85, -34.87)
    thirdPersonPosition = vect(26.5, 3.47, 108.76)
    resetPosition = vect(19.38, 3.47, 115.61)
    minefieldPosition = [
        vect(109.94, 2.84, -58.09),
        vect(55.14, 3.62, 38.15),
        vect(38.29, 3.75, 99.83)
    ]
    startForcingSpawn(Team.2, 0)
