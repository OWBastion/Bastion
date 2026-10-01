#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SHAMBALI_MONASTERY_DEFAULT():
    __currentMapText___ = "香巴里寺院"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("香巴里寺院")

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

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - shambali monastery":
    @Condition __currentMap___ == Map.SHAMBALI_MONASTERY
    
    __currentMapText___ = "香巴佬寺院"
    bastionPosition = [
        vect(26.059, 9.096, 1.444),
        vect(-5.438, 13.974, 61.279),
        vect(-26.551, 15.039, 64.200),
        vect(-16.222, 23.250, 87.574),
        vect(18.432, 31.830, 112.015),
        vect(-52.010, 15.880, 69.600),
        vect(-58.153, 22.998, 124.358),
        vect(-4.813, 30.509, 132.552),
        vect(-51.736, 31.330, 179.529),
        vect(-38.844, 31.330, 169.245)
    ]
    endPosition = vect(-57.88, 29, 197.81)
    thirdPersonPosition = vect(4.94, 8, -19.88)
    resetPosition = vect(-4.68, 8, -19.56)
    minefieldPosition = []
    startForcingSpawn(Team.2, 0)
