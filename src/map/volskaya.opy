#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_VOLSKAYA_DEFAULT():
    __currentMapText___ = "沃斯卡娅工业区"

    bastionPosition = [
        vect(-93.173, 6.029, 40.928),
        vect(-70.245, 2.97, 40.205),
        vect(-68.376, 2.029, 82.568),
        vect(-76.59, 2.892, 50.551),
        vect(-47.51, -0.144, 74.955),
        vect(-6.62, 3.374, 77.439),
        vect(-13.897, 40.833, 106.864),
        vect(-13.277, 5.363, 41.99),
        vect(-3.16, 5.314, 41.863),
        vect(-13.455, 5.513, 31.919)
    ]
    resetPosition = vect(-115.18, -1.98, 35.24)
    endPosition = vect(-42.09, 2.02, 42.31)
    thirdPersonPosition = vect(-113.051, -1.98, 31.996)
    creditsPosition = vect(-128.25, 0.5, 24.75)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - volskaya industries":
    @Condition __currentMap___ == Map.VOLSKAYA
    
    platformMapRevision_VOLSKAYA_DEFAULT()
    __currentMapText___ = "沃斯卡娅"
    __currentMapPioneerText___ = "Ура! Ура!"
    startForcingSpawn(Team.1, 0)
