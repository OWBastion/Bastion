#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_COLOSSEO_DEFAULT():
    __currentMapText___ = "斗兽场"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("斗兽场")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(60.94, 12.5, -13.78),
        vect(30.54, 5.09, 6.64),
        vect(-7.85, 20, -29.95),
        vect(-21.88, 7.49, -3),
        vect(-54.52, 12.46, -10.1),
        vect(-9.98, 5, -39.5),
        vect(-60.93, 12.21, -11.91),
        vect(-87.64, 16.77, -22.43)
    ]
    resetPosition = vect(111.17, 9, -50.91)
    endPosition = vect(-90.31, 9, -33.55)
    thirdPersonPosition = vect(117.38, 9, -38.98)
    creditsPosition = vect(117.64, 13, -48.66)

    mapTitlePlayersByKey = [
        DATA_COLOSSEO[0].split("-"),
        DATA_COLOSSEO[1].split("-"),
        DATA_COLOSSEO[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 斗兽场":
    @Condition (getCurrentMap() == Map.COLOSSEO or __currentMap___ == 2147) == true
    
    platformMapRevision_COLOSSEO_DEFAULT()
    startForcingSpawn(Team.1, 2)
