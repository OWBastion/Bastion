#!mainFile "../../../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# Event: EventId.F5_REFRESH
# 下线规范：若下线此事件，请在本文件内将相关 rule 标记为 @Disabled（并写明日期/原因），然后同步移除 eventCatalog 注册、EVENT_CATALOG_ORDER 顺序项与聚合 include。

# eventMission 记录被选中的技能：0 = 未选，1 = 技能 1，2 = 技能 2，3 = 辅助攻击，4 = 主要攻击。
# 只在当前英雄未被大厅禁用、且确有冷却的技能中抽取（技能 1 禁用清单与 progressHero 一致；技能 2 另外排除堡垒（需打威能才能用）与探奇（无技能 2））。
# 辅助攻击、主要攻击只对下列有冷却的英雄开放；其余英雄的对应攻击无冷却，不参与抽取。
#!define EVT_24_SECONDARY_COOLDOWN_HEROES [Hero.DOOMFIST, Hero.ROADHOG, Hero.DOMINA, Hero.PHARAH, Hero.MIZUKI]
#!define EVT_24_PRIMARY_COOLDOWN_HEROES [Hero.REINHARDT, Hero.BRIGITTE]
#!define EVT_24_SLOT_BUTTON(slot) (Button.ABILITY_1 if slot == 1 else (Button.ABILITY_2 if slot == 2 else (Button.SECONDARY_FIRE if slot == 3 else Button.PRIMARY_FIRE)))
#!define EVT_24_SLOT_USABLE(player, slot) ((slot == 1 and player.getHero() not in [Hero.TORBJORN, Hero.SYMMETRA]) or (slot == 2 and player.getHero() not in [Hero.LIFEWEAVER, Hero.BASTION, Hero.VENTURE]) or (slot == 3 and player.getHero() in EVT_24_SECONDARY_COOLDOWN_HEROES) or (slot == 4 and player.getHero() in EVT_24_PRIMARY_COOLDOWN_HEROES))

rule "[VishkarEvent]: F5 (抽取技能)":
    @Event eachPlayer
    @Team 1
    @Condition all([eventPlayer.hasSpawned(), eventPlayer.eventId == EventId.F5_REFRESH, eventPlayer.eventMission == 0]) == true

    eventPlayer.eventMission = random.choice([slot for slot in [1, 2, 3, 4] if EVT_24_SLOT_USABLE(eventPlayer, slot)])
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
