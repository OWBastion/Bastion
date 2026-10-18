#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_SHAMBALI_MONASTERY_DEFAULT():
    __currentMapText___ = "香巴里寺院"

    bastionPosition = mapPositionPool.slice(620, 11)
    # (-16.139, 40.508, 181.288)
    # (-44.29, 40.509, 203.816)
    # (-13.976, 29.775, 143.323)
    # (-50.623, 27.354, 113.051)
    # (-10.115, 37.04, 130.901)
    # (-4.849, 14, 61.562)
    # (-16.627, 9.917, 13.463)
    # (16.27, 20.587, 99.534)
    # (-38.962, 16.615, 69.858)
    # (26.033, 9.149, 19.823)
    # (-9.824, 8.001, -21.875)
    resetPosition = mapPositionPool[631] # (-1.97, 31.07, 221.85)
    endPosition = mapPositionPool[632] # (-19.43, 8, -22.02)
    thirdPersonPosition = mapPositionPool[633] # (-7.69, 31.07, 226.97)
    creditsPosition = mapPositionPool[634] # (1.75, 35, 232.5)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - shambali monastery":
    @Condition __currentMap___ == Map.SHAMBALI_MONASTERY
    
    platformMapRevision_SHAMBALI_MONASTERY_DEFAULT()
    __currentMapText___ = "香巴佬寺院"
    startForcingSpawn(Team.1, 2)
