#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - blizzworld":
    @Condition (__currentMap___ == Map.BLIZZ_WORLD or __currentMap___ == 1228) == true
    
    bastionPosition = [vect(-114.474, 4.902, 100.451), vect(-115.368, 4.75, 129.864), vect(-82.619, 1.75, 147.017), vect(-35.778, 11.637, 106.066), vect(-38.722, -0.204, 66.024), vect(25.083, 6, 67.282), vect(3.062, -0.097, 20.98), vect(23.863, -4, 0.817)]
    endPosition = vect(26.53, -4.1, -7.83)
    thirdPersonPosition = vect(-149.17, 0.83, 100.85)
    resetPosition = vect(-150.25, 0.83, 104.51)
    creditsPosition = vect(-170.8, 3.65, 96.45)
    startForcingSpawn(Team.1, 2)
    __currentMapText___ = "暴雪世界"
    __currentMapPioneerText___ = __currentMapText___

    mapTitlePlayersByKey = [
        DATA_BLIZZARD_WORLD[0].split("-"),
        DATA_BLIZZARD_WORLD[1].split("-"),
        DATA_BLIZZARD_WORLD[2].split("-")
    ]
