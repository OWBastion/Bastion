#!mainFile "../main.opy"

#!optimizeStrict

# BEGIN AUTO-GENERATED PLATFORM MAP REVISION
# Source: OWBastion Agents API
macro platformMapRevision_RIALTO_DEFAULT():
    __currentMapText___ = "里阿尔托"
    __currentMapClassicText___ = STR_HUD_MAP_CLASSIC_SUFFIX.format("里阿尔托")

    bastionPosition = [
        vect(-64.421, 5.04, -125.927),
        vect(-36.002, 4.75, -77.344),
        vect(-19.68, 3.7, -38.47),
        vect(59.058, 0.07, -8.103),
        vect(54.797, 1.74, -59.938),
        vect(87.874, -0.37, 0.268),
        vect(60.53, 50.43, 61.63),
        vect(-13.12, 4.75, 47.31),
        vect(27.18, 4.75, 36.89),
        vect(20.9, 0.75, 54.61),
        vect(-19.85, 10.75, 11.92)
    ]
    resetPosition = vect(-59.05, 3.75, -158.41)
    endPosition = vect(-12.27, -1.25, -14.73)
    thirdPersonPosition = vect(-54.92, 3.75, -158.32)
    creditsPosition = vect(-57.06, 5.25, -181.51)
    controlJumpPosition = [
        vect(98.662, -1.5, -21.009)
    ]
    controlRespawnPosition = [
        vect(-52.36, 3.83, -176.36),
        vect(53.17, 1.25, 22.99)
    ]

# END AUTO-GENERATED PLATFORM MAP REVISION


rule "map - rialto":
    @Condition __currentMap___ == Map.RIALTO

    platformMapRevision_RIALTO_DEFAULT()
    bastionPosition = [
        vect(86.462, 3.750, -24.675),
        vect(59.071, 0.033, -7.725),
        vect(15.521, 4.768, -36.975),
        vect(62.498, 1.760, -61.589),
        vect(-36.781, 2.259, -30.124),
        vect(-53.760, -2.133, -54.656),
        vect(-33.886, 2.978, -112.114),
        vect(-83.864, 1.750, -94.886),
        vect(-57.053, 11.698, -138.997)
    ]
    endPosition = vect(-56.88, 2.8, -131.49)
    anniversarySpawnPosition = vect(139.8, -1.08, -16.24)
    thirdPersonPosition = vect(131.4, -1.24, -15.46)
    resetPosition = vect(131.17, -1.24, -26.41)
    minefieldPosition = [
        vect(45.93, 0.65, -36.49),
        vect(-51.39, 2.75, -130.46),
        vect(-63.02, 2.75, -130.61)
    ]
    controlJumpPosition = null
    controlRespawnPosition = null
    startForcingSpawn(Team.1, 2)
