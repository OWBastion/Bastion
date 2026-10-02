#!mainFile "../anniversary2026.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Minefield"

## 地雷禁区：隐藏破坏球按低频节奏传送到预配置点位施放大招
#!define MINEFIELD_CAST_INTERVAL 60

rule "Cast minefield on configured positions":
    @Condition len(minefieldPosition) > 0
    @Condition entityExists(minefieldBot) == true

    wait(MINEFIELD_CAST_INTERVAL, Wait.ABORT_WHEN_FALSE)
    if len(minefieldPosition) > 1:
        minefieldPick = random.randint(1, len(minefieldPosition))
        if minefieldPick == minefieldLastCastIndex:
            minefieldPick = minefieldPick % len(minefieldPosition) + 1
        minefieldLastCastIndex = minefieldPick
    else:
        minefieldLastCastIndex = 1
    minefieldBot.teleport(minefieldPosition[minefieldLastCastIndex - 1])
    minefieldBot.setUltCharge(100)
    wait(0.25)
    minefieldBot.forceButtonPress(Button.ULTIMATE)
    wait(1)
    minefieldBot.teleport(random.choice(getSpawnPoints(Team.1)))
    if ruleCondition:
        loop()
