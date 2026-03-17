#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(allTitle) > 0, MAX_TIME)
    challengeTitleIds = [
        33,  # 幸运星 LUCKYSTAR 连续 10 次抽到增益事件
        36,  # 倒霉蛋 UNLUCKY 抽到的减益事件数量是增益事件的 1.5 倍及以上
        37,  # What can i say 连续 10 次抽到减益事件
        41, # V_50 V 我 50 使用"吸血鬼 ProMax"从队友身上吸取 5000+ 生命值
        42, # STEEL 钢门 心之钢层数达到 1200 层
    ]


rule "[VishkarEvent]: Challenge 0 Track":
    @Event eachPlayer
    @Team 1
    @Condition len(challengeTitleIds) != 0
    @Condition dlcVishkarEvent == true
    @Condition eventPlayer.eventLucky >= 10
    @Condition 33 not in eventPlayer.earnedAchievements
    
    eventPlayer.unlockAchievement(33)

rule "[VishkarEvent]: Challenge 1 Track":
    @Event eachPlayer
    @Team 1
    @Condition len(challengeTitleIds) != 0
    @Condition dlcVishkarEvent == true
    @Condition all([eventPlayer.eventCount[0] + eventPlayer.eventCount[1] >= 50
    , eventPlayer.eventCount[1] * 2 >= eventPlayer.eventCount[0] * 3])
    @Condition 36 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(36)

rule "[VishkarEvent]: Challenge 2 Track":
    @Event eachPlayer
    @Team 1
    @Condition len(challengeTitleIds) != 0
    @Condition dlcVishkarEvent == true
    @Condition eventPlayer.eventLucky <= -10
    @Condition 37 not in eventPlayer.earnedAchievements
    

    eventPlayer.unlockAchievement(37)

rule "[VishkarEvent]: Challenge 41 Track (V50)":
    @Event eachPlayer
    @Team 1
    @Condition dlcVishkarEvent == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[4] >= 5000
    @Condition 41 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(41)

rule "[VishkarEvent]: Challenge 42 Track (STEEL)":
    @Event eachPlayer
    @Team 1
    @Condition dlcVishkarEvent == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.heart_steel >= 1200
    @Condition 42 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(42)
