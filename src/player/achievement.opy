#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(allTitle) > 0, Math.INFINITY)
    challengeTitleIds = [
        41, # V_50 V 我 50 使用"吸血鬼 ProMax"从队友身上吸取 5000+ 生命值
        42, # STEEL 钢门 心之钢层数达到 1200 层
        50, # EVENT5_BLACK_SHEEP 害群之马
        51, # EVENT5_I_WANT_TO_CHECK_CARDS 我要验牌
        52, # EVENT5_CARDS_ARE_FINE 牌没有问题
        53, # GREAT_BENEFACTOR 大舍天下 地狱难度中触发 15 次舍己为人并通关
        54, # BREAK_ATMOSPHERE 冲出地表 地狱难度中触发 20 次登月火箭并通关
    ]


rule "[VishkarEvent]: Challenge 53 Track (GREAT_BENEFACTOR)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition dlcVishkarEvent == true
    @Condition difficulty == 5
    @Condition eventPlayer.dlcTimeChallenge[9] >= 15
    @Condition 53 not in eventPlayer.earnedAchievements
    
    eventPlayer.unlockAchievement(53)

rule "[VishkarEvent]: Challenge 54 Track (BREAK_ATMOSPHERE)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition dlcVishkarEvent == true
    @Condition difficulty == 5
    @Condition eventPlayer.dlcTimeChallenge[10] >= 20
    @Condition 54 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(54)

rule "[VishkarEvent]: Challenge 41 Track (V50)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition dlcVishkarEvent == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[1] >= 10000
    @Condition 41 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(41)

rule "[VishkarEvent]: Challenge 42 Track (STEEL)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition dlcVishkarEvent == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.heart_steel[HeartSteelData.STACKS] >= 800
    @Condition 42 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(42)

rule "[VishkarEvent]: Challenge 50 Track (EVENT5_BLACK_SHEEP)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition dlcVishkarEvent == true
    @Condition difficulty == 5
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[6] >= 12
    @Condition eventPlayer.dlcTimeChallenge[7] >= 1
    @Condition 50 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(50)

rule "[VishkarEvent]: Challenge 51 Track (EVENT5_I_WANT_TO_CHECK_CARDS)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition dlcVishkarEvent == true
    @Condition difficulty == 5
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[5] >= 8
    @Condition 51 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(51)

rule "[VishkarEvent]: Challenge 52 Track (EVENT5_CARDS_ARE_FINE)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition dlcVishkarEvent == true
    @Condition difficulty == 5
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[3] >= 5
    @Condition eventPlayer.dlcTimeChallenge[4] == 0
    @Condition 52 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(52)
