#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict

# 「镜中回响」周年限定挑战（26.1001.1）：周年模式只结算本模式的限定挑战，
# 常规成就挑战不在此结算；已结束的旧挑战（41/53-56）不保留追踪。
# 64「到此一游」要求通关全部八张周年地图，属跨局聚合，Workshop 变量随新局重置
# 无法在局内检测——由平台按各图通关记录结算，本文件不含对应规则。

rule "Init Achievement Data":
    waitUntil(len(titleText) > 0, Math.INFINITY)
    challengeTitleIds = [
        65, # PROPHET 麦迪文 触发 10 次「先知」
        66, # QUANTUM_UNLUCKY 哪里有完美的时间线 对局被「先知」观测后累计抽取 45 个减益事件
        67, # 我滴任务完成辣 单局成功完成全部任务类事件（称号身份由 owbastion.com#304 配发后核对）
    ]

    if classicMapVariant != CLASSIC_MAP_VARIANT_OFF:
        challengeTitleIds = []

rule "[VishkarEvent]: Challenge 65 Track (PROPHET)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[0] >= 10
    @Condition 65 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(65)

rule "[VishkarEvent]: Challenge 66 Track (QUANTUM_UNLUCKY)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition eventPlayer.dlcTimeChallenge[1] >= 45
    @Condition 66 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(66)

# 周年挑战 67「我滴任务完成辣」：单局内全部启用任务类事件均至少成功结算一次
# 集合以真实成功结算为准（含通关自动成功）；绘制失败/超时/未抽取不计入
rule "[VishkarEvent]: Challenge 67 Track (ALL_TASKS_DONE)":
    @Event eachPlayer
    @Team 2
    @Condition hashTag == true
    @Condition len(challengeTitleIds) != 0
    @Condition all([BuffEventId.PHEIDIPPIDES_TRIAL in eventPlayer.taskSuccessEvents, BuffEventId.MARTYR_TRIAL in eventPlayer.taskSuccessEvents, BuffEventId.TEMPER_HEART in eventPlayer.taskSuccessEvents, BuffEventId.BATTLEFIELD_MEDIC in eventPlayer.taskSuccessEvents, BuffEventId.SHARED_BLESSING in eventPlayer.taskSuccessEvents]) == true
    @Condition 67 not in eventPlayer.earnedAchievements

    eventPlayer.unlockAchievement(67)
