#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_ILIOS_DEFAULT():
    platformMapRevisionId = "revision:map.ilios:initial"
    platformMapRevisionVariant = null
    __currentMapText___ = "伊利奥斯"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("伊利奥斯")
    __currentMapPioneerText___ = __currentMapText___

    bastionPosition = [
        vect(-173.701, -0.46, -71.552),
        vect(-207.983, 5.46, -31.971),
        vect(-222.539, 0.1, -30.825),
        vect(-223.926, 5.56, -16.079),
        vect(-245.721, 5.56, 5.19),
        vect(-257.45, 2.85, 35.113)
    ]
    resetPosition = vect(-160.308, -1.355, -91.403)
    endPosition = vect(-271.14, -5.585, 33.279)
    thirdPersonPosition = vect(-148.168, -1.504, -88.932)
    creditsPosition = vect(-150.88, 0.2, -97.02)

    mapTitlePlayersByKey = [
        DATA_ILIOS[0].split("-"),
        DATA_ILIOS[1].split("-"),
        DATA_ILIOS[2].split("-")
    ]

#!define platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_POSITION vect(322.692, -21.52, 42.832)
#!define platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_RADIUS 30
macro platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE():
    bastionPosition = [
        vect(321.799, -17.29, 26.126),
        vect(314.215, -16.35, -18.283),
        vect(358.768, -6.597, -47.48),
        vect(353.915, -10.86, -53.746),
        vect(364.601, -25.62, -54.434),
        vect(304.692, -15.91, -42.049),
        vect(319.744, -24.11, -69.502)
    ]
    resetPosition = vect(331.08, -21.52, 41.121)
    endPosition = vect(321.229, -26.291, -88.556)
    thirdPersonPosition = vect(318.997, -21.52, 37.66)
    creditsPosition = vect(321.8, -20, 46)

#!define platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_POSITION vect(131.609, 64.254, -159.135)
#!define platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_RADIUS 30
macro platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS():
    bastionPosition = [
        vect(111.31, 68.78, -183.068),
        vect(83.25, 67.65, -179.529),
        vect(28.394, 61.39, -148.333),
        vect(5.918, 60.37, -170.376),
        vect(-26.8, 67.62, -178.826),
        vect(-52.04, 65.39, -179.058)
    ]
    resetPosition = vect(128.072, 63.254, -165.528)
    endPosition = vect(-47.306, 58.37, -184.722)
    thirdPersonPosition = vect(129.56, 62.45, -153.472)
    creditsPosition = vect(137.54, 63.92, -158.9)

# END AUTO-GENERATED PLATFORM MAP REVISION

rule "map - 伊利奥斯":
    @Condition __currentMap___ == Map.ILIOS

    platformMapRevision_ILIOS_DEFAULT()
    startForcingSpawn(Team.1, 2)
    waitUntil(getPlayers(Team.1).any(lambda player: player.hasSpawned()), 99999)
    if len(getPlayersInRadius(platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_POSITION, platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ILIOS_DEFAULT_STAGE_RUINS()
    elif len(getPlayersInRadius(platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_POSITION, platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE_SETUP_RADIUS, Team.1)) != 0:
        platformMapRevision_ILIOS_DEFAULT_STAGE_LIGHTHOUSE()
