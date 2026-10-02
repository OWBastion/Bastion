#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

subroutine createBastionBot
subroutine createBallBot

def createBastionBot():
    @Name "create bastion bots"
    
    while len(getPlayersOnHero(Hero.BASTION, Team.1)) < len(bastionPosition):
        createDummy(Hero.BASTION, Team.1, -1, random.choice(getSpawnPoints(Team.1)))
        wait(0.25)
        if len(getPlayersOnHero(Hero.BASTION, Team.1)) >= len(bastionPosition) or getTotalTimeElapsed() > 120:
            return
    
    if kills == 0 or len(kills) == 0:
        kills = [0, 0, 0, 0, 0, 0]

def createBallBot():
    @Name "create ball bots"

    createDummy(Hero.WRECKING_BALL, Team.1, -1, random.choice(getSpawnPoints(Team.1)))
    wait(0.25)
    minefieldBot = getPlayersOnHero(Hero.WRECKING_BALL, Team.1).first()

rule "create bastion bots when the game starts and there are not enough":
    @Condition len(getPlayersOnHero(Hero.BASTION, Team.1)) < len(bastionPosition)
    @Condition getTotalTimeElapsed() > 10
    
    wait(1)
    if len(getPlayersOnHero(Hero.BASTION, Team.1)) < len(bastionPosition):
        createBastionBot()
    wait(2)
    wait(max(0.5, getAverageServerLoad() / 100 * 0.8))
    if ruleCondition:
        loop()


rule "SAFE create bastion bots when the game start and there are no bastion bots - emergency backup":
    @Condition len(getPlayersOnHero(Hero.BASTION, Team.1)) == 0
    @Condition getTotalTimeElapsed() > 15
    @Condition getNumberOfPlayers(Team.2) > 0
    
    wait(2)
    if len(getPlayersOnHero(Hero.BASTION, Team.1)) == 0:
        destroyAllDummies()
        wait(0.496)
        createBastionBot()
    wait(max(1, getAverageServerLoad() / 100 * 3.2))
    if ruleCondition:
        loop()


rule "SAFE create ball bots when the game start and there are no ball bots - emergency backup":
    @Condition len(getPlayersOnHero(Hero.WRECKING_BALL, Team.1)) == 0
    @Condition getTotalTimeElapsed() > 15
    @Condition getNumberOfPlayers(Team.2) > 0

    wait(2)
    if len(getPlayersOnHero(Hero.WRECKING_BALL, Team.1)) == 0:
        createBallBot()
        wait(0.496)
        minefieldBot.setInvisibility(Invis.ALL)
        minefieldBot.setStatusEffect(null, Status.PHASED_OUT, 99999)
        minefieldBot.setStatusEffect(null, Status.UNKILLABLE, 99999)
    if ruleCondition:
        loop()