#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(titleText) > 0, Math.INFINITY)
    challengeTitleIds = [
        68, # CHALLENGE_89683D0A 我大受震撼 触发「先知」，并在首次观测中观测到 7 个减益事件
        72, # TITLE_5E15AB66 祸不单行 在「命运赋格曲」的单次事件内承受至少 5 次实际结算的延迟伤害，并存活至事件结束
        73, # TITLE_78561F19 闲庭信步 在「命运变奏曲」的单次事件内 heroNumber 增加至少 4
        74, # TITLE_DE83386D To Be NO.1 在「赌徒：赢家通吃」中单次赢得至少 800 层心之钢
    ]

    if classicMapVariant != CLASSIC_MAP_VARIANT_OFF:
        challengeTitleIds = []


# 我大受震撼：「先知」打开后只结算一次首次观测。
# 观测范围：其他已出生的一队玩家；等待他们的下一个事件坍缩（最多 2 秒，先知缓存每秒刷新一次），
# 再统计其中已确定的下一个事件里的减益事件数。无资格的玩家不会坍缩，只会让等待跑满 2 秒。
# 过滤数组内不能引用 PROFILE_EVENT_PLAYER_ELIGIBLE(p)：它展开为对元素玩家变量的两层数组取值，Workshop 客户端会拒绝导入。
# dlcTimeChallenge[3] 标记本次先知已结算，先知结束时复位。
rule "[VishkarEvent]: Challenge 68 Track (CHALLENGE_89683D0A)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.eventId == EventId.PROPHET
    @Condition eventPlayer.dlcTimeChallenge[3] == 0
    @Condition 68 not in eventPlayer.earnedAchievements

    waitUntil(
        len(getPlayers(Team.1).exclude(eventPlayer).filter(lambda p: p.hasSpawned() == true and p.eventNextIndex == -1)) == 0,
        2
    )
    if eventPlayer.eventId != EventId.PROPHET:
        return
    eventPlayer.dlcTimeChallenge[3] = 1
    if len(getPlayers(Team.1).exclude(eventPlayer).filter(lambda p: p.eventNextIndex != -1 and eventCatalogType[p.eventNextIndex] == EventType.DEBUFF)) >= 7:
        eventPlayer.unlockAchievement(68)

rule "[VishkarEvent]: Challenge 68 Reset (CHALLENGE_89683D0A)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.dlcTimeChallenge[3] == 1
    @Condition eventPlayer.eventId != EventId.PROPHET

    eventPlayer.dlcTimeChallenge[3] = 0

# 闲庭信步：命运变奏曲开始时在 eventMissionGoal 记录 heroNumber + 1 作基准，事件内 heroNumber 增量达标即解锁。
rule "[VishkarEvent]: Challenge 73 Track (TITLE_78561F19)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.eventId == EventId.FATE_VARIATION
    @Condition eventPlayer.eventMissionGoal > 0
    @Condition eventPlayer.heroNumber + 1 - eventPlayer.eventMissionGoal >= EVT_39_CHALLENGE_HERO_CLEARS
    @Condition 73 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(73)

# 祸不单行：命运赋格曲每次实际结算延迟伤害计数 dlcTimeChallenge[4]，死亡清零；
# 事件结束时仍存活且计数达标才解锁。
rule "[VishkarEvent]: Challenge 72 Track (TITLE_5E15AB66)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.dlcTimeChallenge[4] != 0
    @Condition eventPlayer.eventId != EventId.FATE_FUGUE

    if hashTag and len(challengeTitleIds) != 0 and eventPlayer.hasSpawned() and eventPlayer.isAlive() and eventPlayer.dlcTimeChallenge[4] >= EVT_DEBUFF_26_CHALLENGE_HITS and 72 not in eventPlayer.earnedAchievements:
        eventPlayer.unlockAchievement(72)
    eventPlayer.dlcTimeChallenge[4] = 0

rule "[VishkarEvent]: Challenge 72 Death Reset (TITLE_5E15AB66)":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.eventId == EventId.FATE_FUGUE
    @Condition eventPlayer.dlcTimeChallenge[4] != 0

    eventPlayer.dlcTimeChallenge[4] = 0

# To Be NO.1：赢家通吃赢得奖池达标时置位 dlcTimeChallenge[5]，解锁后立即复位。
rule "[VishkarEvent]: Challenge 74 Track (TITLE_DE83386D)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.dlcTimeChallenge[5] == 1

    if hashTag and len(challengeTitleIds) != 0 and 74 not in eventPlayer.earnedAchievements:
        eventPlayer.unlockAchievement(74)
    eventPlayer.dlcTimeChallenge[5] = 0
