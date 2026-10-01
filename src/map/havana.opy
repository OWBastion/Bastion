#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HAVANA_DEFAULT():
    __currentMapText___ = "哈瓦那"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("哈瓦那")

    bastionPosition = [
        vect(117.332, 14.433, -58.091),
        vect(97, 9.01, -25.51),
        vect(62.21, 12.06, -83.3),
        vect(11.58, 7.96, -52.71),
        vect(10.13, 6, -100.38),
        vect(-37.54, 8.23, -72.23),
        vect(-77.17, 10.13, -66.78)
    ]
    resetPosition = vect(158.3, 11, -44.35)
    endPosition = vect(-77.24, 7.22, -49.83)
    thirdPersonPosition = vect(158.256, 11, -47.739)
    creditsPosition = vect(193.45, 13.25, -46.49)

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - havana":
    @Condition __currentMap___ == Map.HAVANA
    
    __currentMapText___ = "哈瓦那"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("哈瓦那")
    bastionPosition = [
        vect(-63.395, 6.193, -56.447),
        vect(-29.994, 12.010, -61.347),
        vect(-1.735, 12.010, -51.495),
        vect(-2.938, 12.435, -81.086),
        vect(32.042, 17.452, -72.872),
        vect(35.807, 12.092, -59.372),
        vect(91.728, 7.207, -93.998),
        vect(100.988, 9.073, -21.881),
        vect(129.322, 12.047, -54.572)
    ]
    endPosition = vect(141.96, 4.99, -16.79)
    thirdPersonPosition = vect(-92.94, 4, -72.19)
    resetPosition = vect(-100.18, 4, -65.78)
    anniversarySpawnPosition = vect(-108.74, 4, -79.66)
    minefieldPosition = [
        vect(-12.62, 7.96, -70.82),
        vect(55.36, 8.06, -94.88),
        vect(127, 6, -30.56)
    ]
    startForcingSpawn(Team.2, 2)
