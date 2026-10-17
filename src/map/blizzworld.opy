#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_BLIZZARD_WORLD_DEFAULT():
    __currentMapText___ = "暴雪世界"

    bastionPosition = mapPositionPool.slice(81, 8)
    resetPosition = mapPositionPool[89]
    endPosition = mapPositionPool[90]
    thirdPersonPosition = mapPositionPool[91]
    creditsPosition = mapPositionPool[92]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - blizzworld":
    @Condition (__currentMap___ == Map.BLIZZ_WORLD or __currentMap___ == 1228) == true
    
    platformMapRevision_BLIZZARD_WORLD_DEFAULT()
    __currentMapText___ = "暴雪世界"
    startForcingSpawn(Team.1, 2)
