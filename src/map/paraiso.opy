#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_PARAISO_DEFAULT():
    platformMapRevisionId = "revision:map.paraiso:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "帕拉伊苏"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("帕拉伊苏")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-47.03, 6.86, -141.73),
        vect(5.22, 12, -122),
        vect(-5.81, 10, -88.75),
        vect(10.08, 3.9, -56.92),
        vect(-13.62, 8.22, -44.11),
        vect(11.42, 5.1, -24.26),
        vect(-6.88, 0.5, 26.09),
        vect(-40.63, 3, 40.01)
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
