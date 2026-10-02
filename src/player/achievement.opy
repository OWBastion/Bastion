#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(titleText) > 0, Math.INFINITY)
    challengeTitleIds = [
        41, # V_50 V 我 50 使用"吸血鬼 ProMax"从队友身上吸取 5000+ 生命值
        53, # GREAT_BENEFACTOR 大舍天下 地狱难度中触发 15 次舍己为人并通关
        54, # BREAK_ATMOSPHERE 冲出地表 地狱难度中触发 20 次登月火箭并通关
        55, # LIST_THEM 把他们上市 触发并赢下 3 次「赌徒：短期投资」与 1 次「赌徒：长期投资」，心之钢层数 ≥ 300
        56, # LIFE_GUARDS_LIFE 生命守护生命 触发 2 次「有难同当」、「保持距离」与「电磁脉冲 ProMax」
        57, # PHANTOM_THIEF 怪盗 触发 10 次「窃贼」
    ]

    if classicMapVariant != CLASSIC_MAP_VARIANT_OFF:
        challengeTitleIds = []

