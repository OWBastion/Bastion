#!mainFile "../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[Core] ..." 前缀不变
#!rulePrefix "Core"

# 对局码固定承载 round(事件目录总权重 * 100) 的 4 位数字：第 1 段第 2-3 位、第 2 段第 3 位、第 3 段第 4 位，其余位随机
rule "Generate mastery run code":
    @Condition len(eventCatalogId) > 0
    @Condition masteryRunCode == ""

    runCodeWeightTotal = 0
    I = 0
    for I in range(len(eventCatalogId)):
        runCodeWeightTotal += eventCatalogWeight[eventCatalogId[I]]
    # 保留未取整的实际总权重供 hashTag 超限校验使用
    eventCatalogWeightTotal = runCodeWeightTotal
    runCodeWeightTotal = round(runCodeWeightTotal * 100)
    masteryRunCode = "{0}-{1}-{2}".format(
        random.randint(1, 9) * 1000 + (floor(runCodeWeightTotal / 1000) % 10) * 100 + (floor(runCodeWeightTotal / 100) % 10) * 10 + random.randint(0, 9),
        random.randint(1, 9) * 1000 + random.randint(0, 9) * 100 + (floor(runCodeWeightTotal / 10) % 10) * 10 + random.randint(0, 9),
        random.randint(1, 9) * 1000 + random.randint(0, 9) * 100 + random.randint(0, 9) * 10 + runCodeWeightTotal % 10
    )
