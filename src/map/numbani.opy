#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_NUMBANI_DEFAULT():
    __currentMapText___ = "努巴尼"

    bastionPosition = mapPositionPool.slice(494, 10)
    resetPosition = mapPositionPool[504]
    endPosition = mapPositionPool[505]
    thirdPersonPosition = mapPositionPool[506]
    creditsPosition = mapPositionPool[507]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - numbani":
    @Condition __currentMap___ == Map.NUMBANI
    
    platformMapRevision_NUMBANI_DEFAULT()
    startForcingSpawn(Team.1, 1)
