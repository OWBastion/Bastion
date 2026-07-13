#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

rule "map - numbani":
    @Condition __currentMap___ == Map.NUMBANI
    
    #Fixed by 他又
    bastionPosition = [vect(203.716, 0.209, -0.271), vect(151.942, 4.337, -5.45), vect(127.026, 2.25, 17.094), vect(123.932, -3.925, -10.396), vect(85.613, 6.25, 20.496), vect(87.894, 1.89, -3.3), vect(39.195, 5.496, 6.518), vect(32.85, 3.119, 34.634), vect(69.994, 6.25, 15.541), vect(118.084, 4.25, 3.814)]
    endPosition = vect(23, 3.12, 39.72)
    thirdPersonPosition = vect(225.74, 0.2, 4.55)
    resetPosition = vect(224.54, 0.2, 0.39)
    creditsPosition = vect(254.54, 3.2, 22.87)
    startForcingSpawn(Team.1, 1)

    mapTitlePlayersByKey = [
        DATA_NUMBANI[0].split("-"),
        DATA_NUMBANI[1].split("-"),
        DATA_NUMBANI[2].split("-")
    ]
