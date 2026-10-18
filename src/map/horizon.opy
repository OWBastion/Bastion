#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT():
    __currentMapText___ = "月球基地"

    bastionPosition = mapPositionPool.slice(303, 6)
    # (-15.287, 6, -127.244)
    # (16.25, 11.86, -106.756)
    # (62.52, 14, -77.97)
    # (33.14, 13.03, -43.68)
    # (19.496, 9, -1.439)
    # (66.687, 8.52, -37.241)
    resetPosition = mapPositionPool[309] # (-45.62, 5, -156.87)
    endPosition = mapPositionPool[310] # (34.476, 12, -23.518)
    thirdPersonPosition = mapPositionPool[311] # (-41.39, 5, -159.03)
    creditsPosition = mapPositionPool[312] # (-55.87, 7.68, -171.97)

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - horizon lunar colony":
    @Condition __currentMap___ == Map.HORIZON_LUNAR_COLONY
    
    platformMapRevision_HORIZON_LUNAR_COLONY_DEFAULT()
    __currentMapText___ = "月球基地"
    startForcingSpawn(Team.1, 0)
