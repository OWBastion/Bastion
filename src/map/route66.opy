#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ROUTE66_DEFAULT():
    platformMapRevisionId = "revision:map.route66:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "66号公路"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("66号公路")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-95.624, 12.66, -5.541),
        vect(-61.87, 10.87, 5.36),
        vect(-38.68, 12.75, -22.136),
        vect(-20.44, 12.17, -15.13),
        vect(26.871, 7.01, 2.468),
        vect(53.82, 12.86, 10.55),
        vect(33.75, 5.54, 48.5)
    ]
    resetPosition = vect(-115.01, 4.5, -46.01)
    endPosition = vect(47.956, 5.2, 47.318)
    thirdPersonPosition = vect(-115.228, 5.799, -49.59)
    creditsPosition = vect(-113.27, 7.5, -63.14)

    mapTitlePlayersByKey = [
        DATA_ROUTE66[0].split("-"),
        DATA_ROUTE66[1].split("-"),
        DATA_ROUTE66[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - route 66":
    @Condition __currentMap___ == Map.ROUTE66
    
    platformMapRevision_ROUTE66_DEFAULT()
    startForcingSpawn(Team.1, 1)
