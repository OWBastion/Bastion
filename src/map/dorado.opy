#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_DORADO_DEFAULT():
    __currentMapText___ = "多拉多"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("多拉多")

    bastionPosition = [
        vect(167.25, 10.85, 42.4),
        vect(113.04, 13.8, 24.63),
        vect(112.06, 17.25, -2.91),
        vect(102.79, 11.01, -23.56),
        vect(78.973, 17.48, -6.843),
        vect(34.78, 10.05, -6.8),
        vect(32.21, 10.59, 20.55),
        vect(8.83, 2.38, 25.76)
    ]
    resetPosition = vect(183.3, 7.04, 37.96)
    endPosition = vect(15.47, 9.54, -1)
    thirdPersonPosition = vect(182.47, 7.04, 42.27)
    creditsPosition = vect(197.72, 10.01, 44.63)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - dorado":
    @Condition __currentMap___ == Map.DORADO
    
    __currentMapText___ = "多拉多"
    bastionPosition = [
        vect(26.169, 10.636, 21.274),
        vect(5.052, 2.990, 6.116),
        vect(70.229, 17.391, 44.750),
        vect(81.050, 17.626, -9.782),
        vect(87.635, 18.233, 14.470),
        vect(125.039, 12.653, -19.477),
        vect(127.749, 16.001, 15.107),
        vect(162.342, 11, 26.637),
        vect(175.257, 19.100, 50.621),
        vect(170.187, 19.100, 44.979),
        vect(182.129, 12.793, 66.128)
    ]
    endPosition = vect(176.64, 11.01, 24.68)
    thirdPersonPosition = vect(-15.02, -0.3, -12.99)
    resetPosition = vect(-22.04, -0.3, -4.21)
    minefieldPosition = [
        vect(188.52, 15, 27.43),
        vect(176.64, 11.01, 24.68),
        vect(21.69, -1.98, 21.76)
    ]
    startForcingSpawn(Team.2, 0)
