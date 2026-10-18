#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_COLOSSEO_DEFAULT():
    __currentMapText___ = "斗兽场"

    bastionPosition = mapPositionPool.slice(180, 8)
    # (60.94, 12.5, -13.78)
    # (30.54, 5.09, 6.64)
    # (-7.85, 20, -29.95)
    # (-21.88, 7.49, -3)
    # (-54.52, 12.46, -10.1)
    # (-9.98, 5, -39.5)
    # (-60.93, 12.21, -11.91)
    # (-87.64, 16.77, -22.43)
    resetPosition = mapPositionPool[188] # (111.17, 9, -50.91)
    endPosition = mapPositionPool[189] # (-90.31, 9, -33.55)
    thirdPersonPosition = mapPositionPool[190] # (117.38, 9, -38.98)
    creditsPosition = mapPositionPool[191] # (117.64, 13, -48.66)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - 斗兽场":
    @Condition (getCurrentMap() == Map.COLOSSEO or __currentMap___ == 2147) == true
    
    platformMapRevision_COLOSSEO_DEFAULT()
    startForcingSpawn(Team.1, 2)
