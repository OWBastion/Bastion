#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_PARAISO_DEFAULT():
    __currentMapText___ = "帕拉伊苏"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("帕拉伊苏")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-10.3, 6.832, -132.595),
        vect(-41.189, 3.79, -155.701),
        vect(-1.528, 12.665, -112.339),
        vect(10.71, 10.361, -67.628),
        vect(-15.164, 9.512, -47.168),
        vect(-4.057, 10.45, -18.278),
        vect(13.362, 4.189, 13.072),
        vect(-43.153, 3, 42.732),
        vect(-58.618, 0.007, 19.441)
    ]
    resetPosition = vect(-78.3, 5.03, -170.8)
    endPosition = vect(-39.54, -2, 62.86)
    thirdPersonPosition = vect(-78.25, 6.33, -167.96)
    creditsPosition = vect(-70.2, 7.75, -183.14)

    mapTitlePlayersByKey = [
        DATA_PARAISO[0].split("-"),
        DATA_PARAISO[1].split("-"),
        DATA_PARAISO[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - paraiso":
    @Condition __currentMap___ == Map.PARAISO

    masteryRunCode = ""
    platformMapRevision_PARAISO_DEFAULT()
    startForcingSpawn(Team.1, 2)
