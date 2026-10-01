#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "Init Achievement Data":
    waitUntil(len(titleText) > 0, Math.INFINITY)
    challengeTitleIds = [
        57, # PHANTOM_THIEF 怪盗 触发 10 次「窃贼」
    ]

    if classicMapVariant != CLASSIC_MAP_VARIANT_OFF:
        challengeTitleIds = []


rule "[VishkarEvent]: Challenge 53 Track (GREAT_BENEFACTOR)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition difficulty == 5
    @Condition eventPlayer.dlcTimeChallenge[1] >= 15
    @Condition 53 not in eventPlayer.earnedAchievements
    
    eventPlayer.unlockAchievement(53)

rule "[VishkarEvent]: Challenge 54 Track (BREAK_ATMOSPHERE)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition difficulty == 5
    @Condition eventPlayer.dlcTimeChallenge[2] >= 15
    @Condition 54 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(54)

rule "[VishkarEvent]: Challenge 41 Track (V50)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[0] >= 10000
    @Condition 41 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(41)

rule "[VishkarEvent]: Challenge 55 Track (LIST_THEM)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[3] >= 3
    @Condition eventPlayer.dlcTimeChallenge[4] >= 1
    @Condition eventPlayer.heart_steel[HeartSteelData.STACKS] >= 300
    @Condition 55 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(55)

rule "[VishkarEvent]: Challenge 56 Track (LIFE_GUARDS_LIFE)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[5] >= 2
    @Condition eventPlayer.dlcTimeChallenge[6] >= 2
    @Condition eventPlayer.dlcTimeChallenge[7] >= 2
    @Condition 56 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(56)

rule "[VishkarEvent]: Challenge 57 Track (PHANTOM_THIEF)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[0] >= 10
    @Condition 57 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(57)
