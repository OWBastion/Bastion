#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_COLOSSEO_DEFAULT():
    __currentMapText___ = "斗兽场"

    bastionPosition = mapPositionPool.slice(180, 8)
    resetPosition = mapPositionPool[188]
    endPosition = mapPositionPool[189]
    thirdPersonPosition = mapPositionPool[190]
    creditsPosition = mapPositionPool[191]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 斗兽场":
    @Condition (getCurrentMap() == Map.COLOSSEO or __currentMap___ == 2147) == true
    
    platformMapRevision_COLOSSEO_DEFAULT()
    startForcingSpawn(Team.1, 2)
