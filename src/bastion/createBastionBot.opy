#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine createBastionBot

def createBastionBot():
    @Name "create bastion bots"
    
    while getNumberOfPlayers(Team.2) < len(bastionPosition):
        createDummy(Hero.BASTION, Team.2, getNumberOfPlayers(Team.2), random.choice(getSpawnPoints(Team.2)))
        wait(0.25)
        if getNumberOfPlayers(Team.2) >= len(bastionPosition) or getTotalTimeElapsed() > 120:
            return
    if kills == 0 or len(kills) == 0:
        kills = [0, 0, 0, 0, 0, 0]


rule "create bastion bots when the game starts and there are not enough":
    @Condition getNumberOfPlayers(Team.2) < len(bastionPosition)
    @Condition getTotalTimeElapsed() > 10
    
    wait(1)
    if getNumberOfPlayers(Team.2) < len(bastionPosition):
        createBastionBot()
    wait(2)
    wait(max(0.5, getAverageServerLoad() / 100 * 0.8))
    if ruleCondition:
        loop()


rule "SAFE create bastion bots when the game start and there are no bastion bots - emergency backup":
    @Condition getNumberOfPlayers(Team.2) == 0
    @Condition getTotalTimeElapsed() > 15
    @Condition getNumberOfPlayers(Team.1) > 0
    
    wait(2)
    if getNumberOfPlayers(Team.2) == 0:
        destroyAllDummies()
        wait(0.5)
        createBastionBot()
    wait(max(1, getAverageServerLoad() / 100 * 3.2))
    if ruleCondition:
        loop()


