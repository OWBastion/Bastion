#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_KINGS_ROW_DEFAULT():
    __currentMapText___ = "国王大道"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("国王大道")

    bastionPosition = [
        vect(-143.9, 7.13, 10.15),
        vect(-116.44, 6.13, 5.72),
        vect(-103.12, 6.93, -4.02),
        vect(-91.99, 7.5, -28.63),
        vect(-66.62, 4.5, -35.93),
        vect(-29.17, 2.55, -31.43),
        vect(-10.67, 16.97, 5.65)
    ]
    resetPosition = vect(-175.23, -0.07, 43.03)
    endPosition = vect(-1.9, 5, -0.29)
    thirdPersonPosition = vect(-176.048, -0.07, 36.54)
    creditsPosition = vect(-185.56, 3.53, 38.32)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - king's row":
    @Condition (__currentMap___ == Map.KINGS_ROW or __currentMap___ == 742) == true

    __currentMapText___ = "国王大道"
    bastionPosition = [
        vect(-0.627, 13.944, 16.525),
        vect(-5.488, 8.796, -22.473),
        vect(-29.998, 2.366, -30.744),
        vect(-60.572, 4.956, -15.599),
        vect(-81.551, 4.714, -44.309),
        vect(-89.028, 6.929, -4.412),
        vect(-129.880, 6.315, 10.195),
        vect(-155.314, -2.879, 29.579),
        vect(-156.722, -2.878, 21.307),
        vect(-169.730, 2.046, 4.874)
    ]
    endPosition = vect(-165.38, 0.07, 14.43)
    thirdPersonPosition = vect(-3.79, 1, 29.39)
    resetPosition = vect(0.89, 1, 28.2)
    minefieldPosition = [
        vect(-152.07, -2.85, 24.96),
        vect(-89.92, 5.21, 4.62),
        vect(1.83, 0.15, 0.75)
    ]
    startForcingSpawn(Team.2, 0)
