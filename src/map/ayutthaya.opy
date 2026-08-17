#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_AYUTTHAYA_DEFAULT():
    __currentMapText___ = "阿育陀耶"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("阿育陀耶")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(18.158, 1.217, -56.711),
        vect(17.999, 6.029, -30.873),
        vect(14.01, 3.189, -9.077),
        vect(34.905, 5.09, 4.157),
        vect(4.54, 6.004, 26.42),
        vect(10.071, 1.931, 38.699)
    ]
    resetPosition = vect(20.46, 1, -104.03)
    endPosition = vect(16.12, 1, 66.52)
    thirdPersonPosition = vect(15.45, 1, -103.8)
    creditsPosition = vect(17.69, 9.22, -111.87)

    mapTitlePlayersByKey = [
        DATA_AYUTTHAYA[0].split("-"),
        DATA_AYUTTHAYA[1].split("-"),
        DATA_AYUTTHAYA[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 阿育陀耶":
    @Condition (__currentMap___ == Map.AYUTTHAYA or __currentMap___ == 1826) == true
    
    rebootTime = 5400
    platformMapRevision_AYUTTHAYA_DEFAULT()
    __currentMapPioneerText___ = "大城"
    __currentPioneerText___ = "守护者"
    startForcingSpawn(Team.1, 1)
