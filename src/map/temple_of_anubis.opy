#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT():
    platformMapRevisionId = "revision:map.temple_of_anubis:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "阿努比斯神殿"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("阿努比斯神殿")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-17.188, 11.237, 105.646),
        vect(-3.47, 20.35, 97.61),
        vect(-4.69, 22.57, 79.47),
        vect(-37.62, 1.91, 47.85),
        vect(-25.2, 1.07, 25.16),
        vect(-37.5, 16.8, -4.79),
        vect(-0.35, 17.87, -24.21)
    ]
    resetPosition = vect(-17.16, 4.46, 137.76)
    endPosition = vect(-7.02, -0.66, -36.43)
    thirdPersonPosition = vect(-7.969, 4.701, 137.39)
    creditsPosition = vect(-11.3, 7.35, 149.11)
    springBoardPosition = vect(-47.93, 1.5, 51.33)

    mapTitlePlayersByKey = [
        DATA_TEMPLE_OF_ANUBIS[0].split("-"),
        DATA_TEMPLE_OF_ANUBIS[1].split("-"),
        DATA_TEMPLE_OF_ANUBIS[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - temple of anubis":
    @Condition __currentMap___ == Map.TEMPLE_OF_ANUBIS
    
    platformMapRevision_TEMPLE_OF_ANUBIS_DEFAULT()
    startForcingSpawn(Team.1, 1)
