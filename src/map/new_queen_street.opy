#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_QUEEN_STREET_DEFAULT():
    __currentMapText___ = "新皇后街"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("新皇后街")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-74.922, 14.194, -16.661),
        vect(-25.688, 4, -22.819),
        vect(-29.72, 7.12, -6.68),
        vect(-7.696, 4.85, 35.246),
        vect(-0.035, 2.376, -11.505),
        vect(19.183, 1.477, -27.407),
        vect(15.862, 5.063, -12.591),
        vect(39.34, 8.1, -12.938),
        vect(51.915, 10, -17.308)
    ]
    resetPosition = vect(-111.17, 11, -17)
    endPosition = vect(90, 11, -45.9)
    thirdPersonPosition = vect(-111.26, 11, -32.03)
    creditsPosition = vect(-102.08, 17.29, -24.46)

    mapTitlePlayersByKey = [
        DATA_NEW_QUEEN_STREET[0].split("-"),
        DATA_NEW_QUEEN_STREET[1].split("-"),
        DATA_NEW_QUEEN_STREET[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 新皇后街":
    @Condition __currentMap___ == Map.NEW_QUEEN_STREET
    
    platformMapRevision_NEW_QUEEN_STREET_DEFAULT()
    startForcingSpawn(Team.1, 2)
