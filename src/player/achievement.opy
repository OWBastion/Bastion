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


rule "[VishkarEvent]: Challenge 57 Track (PHANTOM_THIEF)":
    @Event eachPlayer
    @Team 1
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[0] >= 10
    @Condition 57 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(57)
