#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_BLIZZARD_WORLD_DEFAULT():
    __currentMapText___ = "暴雪世界"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("暴雪世界")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-114.474, 4.902, 100.451),
        vect(-115.368, 4.75, 129.864),
        vect(-82.619, 1.75, 147.017),
        vect(-35.778, 11.637, 106.066),
        vect(-38.722, -0.204, 66.024),
        vect(25.083, 6, 67.282),
        vect(3.062, -0.097, 20.98),
        vect(23.863, -4, 0.817)
    ]
    resetPosition = vect(-150.25, 0.83, 104.51)
    endPosition = vect(26.53, -4.1, -7.83)
    thirdPersonPosition = vect(-149.17, 0.83, 100.85)
    creditsPosition = vect(-170.8, 3.65, 96.45)

    mapTitlePlayersByKey = [
        DATA_BLIZZARD_WORLD[0].split("-"),
        DATA_BLIZZARD_WORLD[1].split("-"),
        DATA_BLIZZARD_WORLD[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - blizzworld":
    @Condition (__currentMap___ == Map.BLIZZ_WORLD or __currentMap___ == 1228) == true
    
    platformMapRevision_BLIZZARD_WORLD_DEFAULT()
    __currentMapText___ = "暴雪世界"
    __currentMapPioneerText___ = __currentMapText___
    startForcingSpawn(Team.1, 2)
