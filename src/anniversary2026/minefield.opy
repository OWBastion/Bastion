#!mainFile "../anniversary2026.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Minefield"

## 地雷禁区：隐藏破坏球按低频节奏传送到预配置点位施放大招；每轮重新随机间隔
#!define MINEFIELD_CAST_INTERVAL_MIN 60
#!define MINEFIELD_CAST_INTERVAL_MAX 75
#!define MINEFIELD_SUPPORTED_MAPS [Map.ROUTE66, Map.CIRCUIT_ROYAL, Map.SHAMBALI_MONASTERY, Map.HAVANA, Map.DORADO, Map.WATCHPOINT_GIBRALTAR, Map.RIALTO, Map.EICHENWALDE, Map.KINGS_ROW, Map.NUMBANI, Map.MIDTOWN]

rule "Maintain hidden casting bot":
    @Condition len(minefieldPosition) > 0
    @Condition len(getPlayersOnHero(Hero.BASTION, Team.1)) >= len(bastionPosition)
    @Condition entityExists(minefieldBot) != true

    # 场上已有未被追踪的球时重绑而非再造；缺球时经 createBastionBot 串行补位，不在堡垒填充中途生成
    if len(getPlayersOnHero(Hero.WRECKING_BALL, Team.1)) == 0:
        createBastionBot()
    minefieldBot = getPlayersOnHero(Hero.WRECKING_BALL, Team.1)[0]
    minefieldBot.setInvisibility(Invis.ALL)
    minefieldBot.setStatusEffect(null, Status.PHASED_OUT, 99999)
    minefieldBot.setStatusEffect(null, Status.UNKILLABLE, 99999)


rule "Cast minefield on configured positions":
    @Condition len(minefieldPosition) > 0
    @Condition entityExists(minefieldBot) == true

    wait(random.uniform(MINEFIELD_CAST_INTERVAL_MIN, MINEFIELD_CAST_INTERVAL_MAX), Wait.ABORT_WHEN_FALSE)
    if len(minefieldPosition) > 1:
        minefieldPick = random.randint(1, len(minefieldPosition))
        if minefieldPick == minefieldLastCastIndex:
            minefieldPick = minefieldPick % len(minefieldPosition) + 1
        minefieldLastCastIndex = minefieldPick
    else:
        minefieldLastCastIndex = 1
    minefieldBot.teleport(minefieldPosition[minefieldLastCastIndex - 1])
    minefieldBot.clearStatusEffect(Status.PHASED_OUT)
    minefieldBot.setUltCharge(100)
    wait(0.25)
    minefieldBot.forceButtonPress(Button.ULTIMATE)
    wait(1)
    minefieldBot.setStatusEffect(null, Status.PHASED_OUT, 99999)
    minefieldBot.teleport(random.choice(getSpawnPoints(Team.1)))
    if ruleCondition:
        loop()
