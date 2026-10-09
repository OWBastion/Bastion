#!mainFile "../main.opy"
#!optimizeStrict

rule "map - 监测站：格里姆火山":
    @Condition __currentMap___ == Map.GRIMSVOTN

    __currentMapText___ = "监测站：格里姆火山"
    bastionPosition = [
        vect(-3.768, 10, -154.293),
        vect(-179.890, 8.049, 13.651),
        vect(-36.030, 10, -102.202),
        vect(-66.893, 7, -89.602),
        vect(-73.647, 12.511, -68.793),
        vect(-108.909, 8.998, -92.838),
        vect(-96.866, 10.524, -47.811),
        vect(-124.518, 10.125, -40.118),
        vect(6.668, 9.107, -118.208),
        vect(-157.713, 3.002, -26.847),
        vect(-162.507, 11.002, 37.040),
        vect(-130.920, 8, 13.563)
    ]
    endPosition = vect(-182.38, 3.26, 35.29)
    thirdPersonPosition = vect(-2.27, 4, -184.3)
    resetPosition = vect(-5.9, 4, -183.68)
    minefieldPosition = [
        vect(-173.29, 4, 27.19),
        vect(-105.84, 10.99, -97.14),
        vect(-15.94, 4, -131.55)
    ]
    startForcingSpawn(Team.2, 0)
