#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_KINGS_ROW_DEFAULT():
    __currentMapText___ = "国王大道"

    bastionPosition = mapPositionPool.slice(357, 7)
    # (-143.9, 7.13, 10.15)
    # (-116.44, 6.13, 5.72)
    # (-103.12, 6.93, -4.02)
    # (-91.99, 7.5, -28.63)
    # (-66.62, 4.5, -35.93)
    # (-29.17, 2.55, -31.43)
    # (-10.67, 16.97, 5.65)
    resetPosition = mapPositionPool[364] # (-175.23, -0.07, 43.03)
    endPosition = mapPositionPool[365] # (-1.9, 5, -0.29)
    thirdPersonPosition = mapPositionPool[366] # (-176.048, -0.07, 36.54)
    creditsPosition = mapPositionPool[367] # (-185.56, 3.53, 38.32)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - king's row":
    @Condition (__currentMap___ == Map.KINGS_ROW or __currentMap___ == 742) == true
    
    platformMapRevision_KINGS_ROW_DEFAULT()
    __currentMapText___ = "国王大道"
    startForcingSpawn(Team.1, 1)
