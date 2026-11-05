#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.F5_REFRESH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

# eventMission 记录被选中的技能：0 = 未选，1 = 技能 1，2 = 技能 2。
# 只在当前英雄未被大厅禁用的技能中抽取（禁用清单与 progressHero 一致）。
#!define EVT_24_SLOT_BUTTON(slot) (Button.ABILITY_1 if slot == 1 else Button.ABILITY_2)
#!define EVT_24_SLOT_USABLE(player, slot) ((slot == 1 and player.getHero() not in [Hero.TORBJORN, Hero.SYMMETRA]) or (slot == 2 and player.getHero() != Hero.LIFEWEAVER))

rule "[VishkarEvent]: F5 (抽取技能)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.F5_REFRESH, eventPlayer.eventMission == 0]) == true

    eventPlayer.eventMission = random.choice([slot for slot in [1, 2] if EVT_24_SLOT_USABLE(eventPlayer, slot)])
    # 死亡、换英雄使所选技能失效、事件结束时放弃所选技能；重生或换英雄后重新抽取。
    waitUntil(eventPlayer.hasSpawned() == false or eventPlayer.eventId != EventId.F5_REFRESH or eventPlayer.eventEndTime <= getTotalTimeElapsed() or EVT_24_SLOT_USABLE(eventPlayer, eventPlayer.eventMission) == false, Math.INFINITY)
    eventPlayer.eventMission = 0
    if ruleCondition and eventPlayer.eventEndTime > getTotalTimeElapsed():
        wait(0.25)
        loop()

rule "[VishkarEvent]: F5 (所选技能冷却归零)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.eventId == EventId.F5_REFRESH
    @Condition eventPlayer.eventMission != 0
    @Condition eventPlayer.getAbilityCooldown(EVT_24_SLOT_BUTTON(eventPlayer.eventMission)) > 0

    eventPlayer.setAbilityCooldown(EVT_24_SLOT_BUTTON(eventPlayer.eventMission), 0)
