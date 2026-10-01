#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ROUTE66_DEFAULT():
    __currentMapText___ = "66号公路"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("66号公路")

    bastionPosition = [
        vect(-95.624, 12.66, -5.541),
        vect(-61.87, 10.87, 5.36),
        vect(-38.68, 12.75, -22.136),
        vect(-20.44, 12.17, -15.13),
        vect(26.871, 7.01, 2.468),
        vect(53.82, 12.86, 10.55),
        vect(33.75, 5.54, 48.5)
    ]
    resetPosition = vect(-115.01, 4.5, -46.01)
    endPosition = vect(47.956, 5.2, 47.318)
    thirdPersonPosition = vect(-115.228, 5.799, -49.59)
    creditsPosition = vect(-113.27, 7.5, -63.14)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - route 66":
    @Condition __currentMap___ == Map.ROUTE66
    
    __currentMapText___ = "66号公路"
    bastionPosition = [
        vect(42.910, 12.468, 57.186),
        vect(46.957, 10.348, 23.420),
        vect(13.375, 7.628, 2.053),
        vect(-7.499, 8.146, -9.483),
        vect(-37.229, 10.592, 5.707),
        vect(-39.299, 12.762, -22.170),
        vect(-57.958, 11.751, 22.969),
        vect(-80.025, 12.557, -1.539),
        vect(-83.831, 12.891, -28.936)
    ]
    endPosition = vect(-92.4, 6.53, -23.45)
    minefieldPosition = [
        vect(23.25, 3.31, -36.88),
        vect(-44.98, 3.39, 9.38),
        vect(75.41, 6.5, 21.77)
    ]
    resetPosition = null
    thirdPersonPosition = null
    startForcingSpawn(Team.2, 0)
