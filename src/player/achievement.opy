#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(titleText) > 0, Math.INFINITY)
    challengeTitleIds = [
        57, # PHANTOM_THIEF 怪盗 触发 10 次「窃贼」
        59, # EMOTICON_CONFUSED ？？？ 通过「作弊：暗箱操作」触发「作弊：我要验牌」，再通过「作弊：我要验牌」触发「奥利维娅的礼物」
        60, # EMOTICON_GRIMACE ＞_＜ 「我独自闯关」期间因队友「赌徒：乐于助人」赌输降至 1 血后存活至事件结束
        61, # EMOTICON_SURPRISED o_O 触发「镜像反转」并将 4 个为负的属性全部反转
        62, # I_THINK_NO 我觉得不行 「我独自决定」立即结束至少两名队友的不同减益事件
        63, # I_THINK_YES 我觉得可以 「我独自决定」延长队友的「我独自升级」
        68, # CHALLENGE_89683D0A 我大受震撼 触发「先知」，并在首次观测中观测到 7 个减益事件
    ]

    if classicMapVariant != CLASSIC_MAP_VARIANT_OFF:
        challengeTitleIds = []


rule "[VishkarEvent]: Challenge 57 Track (PHANTOM_THIEF)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[0] >= 10
    @Condition 57 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(57)

rule "[VishkarEvent]: Challenge 59 Track (EMOTICON_CONFUSED)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[1] >= 2
    @Condition 59 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(59)

# ＞_＜ 标记在事件离开 SOLO_RUN 时结算：存活即解锁，同时无论成败都复位标记
rule "[VishkarEvent]: Challenge 60 Resolve (EMOTICON_GRIMACE)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.dlcTimeChallenge[3] == 1
    @Condition eventPlayer.eventId != EventId.SOLO_RUN

    if hashTag == true and len(challengeTitleIds) != 0 and eventPlayer.isAlive() == true:
        eventPlayer.unlockAchievement(60)
    eventPlayer.dlcTimeChallenge[3] = 0

rule "[VishkarEvent]: Challenge 60 Reset On Death (EMOTICON_GRIMACE)":
    @Event playerDied
    @Team 1
    @Condition eventPlayer.dlcTimeChallenge[3] == 1

    eventPlayer.dlcTimeChallenge[3] = 0

rule "[VishkarEvent]: Challenge 61 Track (EMOTICON_SURPRISED)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[2] >= 2
    @Condition 61 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(61)

rule "[VishkarEvent]: Challenge 62 Track (I_THINK_NO)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[4] >= 1
    @Condition 62 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(62)

rule "[VishkarEvent]: Challenge 63 Track (I_THINK_YES)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[5] >= 1
    @Condition 63 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(63)

# 我大受震撼：「先知」打开后只结算一次首次观测。
# 观测范围与先知头顶文本一致：其他已出生且有资格的一队玩家；等待他们的下一个事件坍缩（最多 5 秒），
# 再统计其中已确定的下一个事件里的减益事件数。dlcTimeChallenge[6] 标记本次先知已结算，先知结束时复位。
rule "[VishkarEvent]: Challenge 68 Track (CHALLENGE_89683D0A)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.eventId == EventId.PROPHET
    @Condition eventPlayer.dlcTimeChallenge[6] == 0
    @Condition 68 not in eventPlayer.earnedAchievements

    waitUntil(
        len(getPlayers(Team.1).exclude(eventPlayer).filter(lambda p: p.hasSpawned() == true and PROFILE_EVENT_PLAYER_ELIGIBLE(p) == true and p.eventNextIndex == -1)) == 0,
        5
    )
    if eventPlayer.eventId != EventId.PROPHET:
        return
    eventPlayer.dlcTimeChallenge[6] = 1
    if len(getPlayers(Team.1).exclude(eventPlayer).filter(lambda p: p.eventNextIndex != -1 and eventCatalogType[p.eventNextIndex] == EventType.DEBUFF)) >= 7:
        eventPlayer.unlockAchievement(68)

rule "[VishkarEvent]: Challenge 68 Reset (CHALLENGE_89683D0A)":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.dlcTimeChallenge[6] == 1
    @Condition eventPlayer.eventId != EventId.PROPHET

    eventPlayer.dlcTimeChallenge[6] = 0
