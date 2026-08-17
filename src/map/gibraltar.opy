#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT():
    __currentMapText___ = "直布罗陀"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("直布罗陀")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(70.099, 9, 26.803),
        vect(86.26, 7.46, 2.95),
        vect(61.64, 3.67, -20.79),
        vect(46.95, 7.65, -66.08),
        vect(32.69, 4.69, -52.38),
        vect(21, 4.2, -64.39),
        vect(31.85, 7.62, -107.88),
        vect(56.88, 9.23, -118.92),
        vect(18.08, 8.78, -133.02)
    ]
    resetPosition = vect(97.55, 1.06, 60.38)
    endPosition = vect(43.42, 5.15, -129.34)
    thirdPersonPosition = vect(93.88, 1.06, 63.17)
    creditsPosition = vect(112.23, 0, 73.59)

    mapTitlePlayersByKey = [
        DATA_WATCHPOINT_GIBRALTAR[0].split("-"),
        DATA_WATCHPOINT_GIBRALTAR[1].split("-"),
        DATA_WATCHPOINT_GIBRALTAR[2].split("-")
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    
    platformMapRevision_WATCHPOINT_GIBRALTAR_DEFAULT()
    __currentMapText___ = "直布罗陀"
    if random.randint(0, 99) < 50:
        __currentMapPioneerText___ = "守望先锋"
        __currentPioneerText___ = ""
    else:
        __currentMapPioneerText___ = "黑爪特工"
        __currentPioneerText___ = ""
    startForcingSpawn(Team.1, 2)

    waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
    if __currentMapPioneerText___ == "守望先锋":
        titleColor[TITLE.PIONEER] = vect(240, 101, 20)
    else:
        titleColor[TITLE.PIONEER] = vect(227, 3, 3)
