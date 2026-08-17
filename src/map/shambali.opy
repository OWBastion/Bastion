#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SHAMBALI_MONASTERY_DEFAULT():
    __currentMapText___ = "香巴里寺院"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("香巴里寺院")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-16.139, 40.508, 181.288),
        vect(-44.29, 40.509, 203.816),
        vect(-13.976, 29.775, 143.323),
        vect(-50.623, 27.354, 113.051),
        vect(-10.115, 37.04, 130.901),
        vect(-4.849, 14, 61.562),
        vect(-16.627, 9.917, 13.463),
        vect(16.27, 20.587, 99.534),
        vect(-38.962, 16.615, 69.858),
        vect(26.033, 9.149, 19.823),
        vect(-9.824, 8.001, -21.875)
    ]
    resetPosition = vect(-1.97, 31.07, 221.85)
    endPosition = vect(-19.43, 8, -22.02)
    thirdPersonPosition = vect(-7.69, 31.07, 226.97)
    creditsPosition = vect(1.75, 35, 232.5)

    mapTitlePlayersByKey = [
        DATA_SHAMBALI_MONASTERY[0].split("-"),
        DATA_SHAMBALI_MONASTERY[1].split("-"),
        DATA_SHAMBALI_MONASTERY[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - shambali monastery":
    @Condition __currentMap___ == Map.SHAMBALI_MONASTERY
    
    platformMapRevision_SHAMBALI_MONASTERY_DEFAULT()
    __currentMapText___ = "香巴佬寺院"
    __currentMapPioneerText___ = __currentMapText___
    startForcingSpawn(Team.1, 2)
