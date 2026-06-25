#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - 霓虹枢纽":
    @Condition (__currentMap___ == Map.NEON_JUNCTION or __currentMap___ == -6860) == true

    thirdPersonPosition = vect(-17.28, 0.75, 431.46)
    resetPosition = vect(2.31, 0.75, 431.46)
    creditsPosition = vect(-7.51, 4.05, 438.32)
    startForcingSpawn(Team.1, 2)