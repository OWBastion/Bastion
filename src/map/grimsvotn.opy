#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NEW_A021ED61_DEFAULT():
    __currentMapText___ = "监测站：格里姆火山"

    bastionPosition = mapPositionPool.slice(251, 11)
    resetPosition = mapPositionPool[262]
    endPosition = mapPositionPool[263]
    thirdPersonPosition = mapPositionPool[264]
    creditsPosition = mapPositionPool[265]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 监测站：格里姆火山":
    @Condition __currentMap___ == Map.GRIMSVOTN

    platformMapRevision_NEW_A021ED61_DEFAULT()
    startForcingSpawn(Team.1, 0)
