#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(titleText) > 0, Math.INFINITY)
    challengeTitleIds = [
        59, # EMOTICON_CONFUSED ？？？ 通过「作弊：暗箱操作」触发「作弊：我要验牌」，再通过「作弊：我要验牌」触发「奥利维娅的礼物」
        61, # EMOTICON_SURPRISED o_O 触发「镜像反转」并将 4 个为负的属性全部反转
    ]

    if classicMapVariant != CLASSIC_MAP_VARIANT_OFF:
        challengeTitleIds = []


rule "[VishkarEvent]: Challenge 59 Track (EMOTICON_CONFUSED)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[1] >= 2
    @Condition 59 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(59)

rule "[VishkarEvent]: Challenge 61 Track (EMOTICON_SURPRISED)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[2] >= 2
    @Condition 61 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(61)
