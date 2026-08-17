#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HANAOKA_DEFAULT():
    __currentMapText___ = "花冈"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("花冈")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-22.263, 46.024, -89.586),
        vect(-5.326, 42.977, -59.814),
        vect(6.729, 45.55, -48.776),
        vect(29.532, 44.5, 7.09),
        vect(-2.847, 42.51, 7.305),
        vect(-17.813, 45.889, 63.611),
        vect(-21.392, 45.952, 103.426),
        vect(14.139, 41.045, 99.842),
        vect(-12.338, 40.538, 39.81),
        vect(-17.161, 40.545, -19.673)
    ]
    resetPosition = vect(-9.08, 44.05, -133.26)
    endPosition = vect(20.36, 39.83, 112.51)
    thirdPersonPosition = vect(-0.64, 44.05, -133.89)
    creditsPosition = vect(-5.02, 50.05, -142.63)
    controlRespawnPosition = [
        vect(-7.69, 44.25, -140.5)
    ]
    controlRespawnAxis = 2
    controlRespawnAxisThreshold = 30

    mapTitlePlayersByKey = [
        DATA_HANAOKA[0].split("-"),
        DATA_HANAOKA[1].split("-"),
        DATA_HANAOKA[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 花冈":
     @Condition (__currentMap___ == Map.HANAOKA or __currentMap___ == 2601) == true
    
    platformMapRevision_HANAOKA_DEFAULT()
     __currentMapText___ = "花冈"
     __currentMapPioneerText___ = __currentMapText___
     startForcingSpawn(Team.1, 2)
     waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
