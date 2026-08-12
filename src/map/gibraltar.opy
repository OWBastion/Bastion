#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - watchpoint gibraltar":
    @Condition __currentMap___ == Map.WATCHPOINT_GIBRALTAR
    @Condition platformMapRevisionLoaded == false
    
    platformMapRevisionMapId = "map.watchpoint_gibraltar"
    platformMapRevisionVariant = null
    applyPlatformMapRevision()
    __currentMapText___ = "直布罗陀"
    if random.randint(0, 99) < 50:
        __currentMapPioneerText___ = "守望先锋"
        __currentPioneerText___ = ""
    else:
        __currentMapPioneerText___ = "黑爪特工"
        __currentPioneerText___ = ""
    if not platformMapRevisionDataError:
        startForcingSpawn(Team.1, 2)

    waitUntil(len(titleText) > TITLE.PIONEER, Math.INFINITY)
    if __currentMapPioneerText___ == "守望先锋":
        titleColor[TITLE.PIONEER] = vect(240, 101, 20)
    else:
        titleColor[TITLE.PIONEER] = vect(227, 3, 3)
