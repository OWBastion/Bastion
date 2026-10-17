#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_AYUTTHAYA_DEFAULT():
    __currentMapText___ = "阿育陀耶"

    bastionPosition = mapPositionPool.slice(71, 6)
    resetPosition = mapPositionPool[77]
    endPosition = mapPositionPool[78]
    thirdPersonPosition = mapPositionPool[79]
    creditsPosition = mapPositionPool[80]

# END AUTO-GENERATED PLATFORM MAP REVISION



rule "map - 阿育陀耶":
    @Condition (__currentMap___ == Map.AYUTTHAYA or __currentMap___ == 1826) == true
    
    rebootTime = 5400
    platformMapRevision_AYUTTHAYA_DEFAULT()
    startForcingSpawn(Team.1, 1)
