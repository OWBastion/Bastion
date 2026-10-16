#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_A021ED61_DEFAULT():
    __currentMapText___ = "监测站：格里姆火山"

    bastionPosition = [
        vect(-122.36, 13.155, -60.554),
        vect(-95.895, 15.006, -81.424),
        vect(-77.323, 9.769, -84.199),
        vect(-115.764, 12.01, -69.951),
        vect(-100.756, 12.668, -39.497),
        vect(-125.222, 6.47, -26.48),
        vect(-51.496, 8, -69.975),
        vect(-18.169, 12.827, -82.178),
        vect(-18.379, 4.62, -112.326),
        vect(6.685, 9.098, -118.302),
        vect(-3.923, 4.538, -144.039)
    ]
    resetPosition = vect(-148.4, 6.86, -65.1)
    endPosition = vect(-4, 2.88, -146.45)
    thirdPersonPosition = vect(-143.45, 6.86, -68.19)
    creditsPosition = vect(-146.73, 2, -141.47)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 监测站：格里姆火山":
    @Condition __currentMap___ == Map.GRIMSVOTN

    platformMapRevision_NEW_A021ED61_DEFAULT()
    startForcingSpawn(Team.1, 0)
