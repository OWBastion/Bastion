#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
# 保留迁移前发射规则名 "[Core] ..." 前缀不变
#!rulePrefix "Core"

rule "Resolve finish":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.hasSpawned() == true
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.anchorPos(eventPlayer.possess).y >= endPosition.y
    @Condition distance(eventPlayer.anchorPos(eventPlayer.possess) * vect(1, 0, 1), endPosition * vect(1, 0, 1)) <= 4

    if len(eventPlayer.possessed) > 0:
        eventPlayer.possessed = []
    eventPlayer.respawn()
    wait(0.032)
    if controlRespawnPosition == null:
        goto lbl_0
    eventPlayer.controlJumpIndex = 0
    eventPlayer.teleport(controlRespawnPosition[0])
    wait(0.032)
    eventPlayer.setFacing(directionTowards(eventPlayer.getEyePosition(), controlJumpPosition[0].getPosition()), Relativity.TO_WORLD)
    lbl_0:
    if eventPlayer.heroNumber + 1 < len(heroList) and eventPlayer.getHero() == heroList[eventPlayer.heroNumber]:
        progressHero()
    elif eventPlayer.getHero() == heroList.last() and not eventPlayer.isWinner:
        eventPlayer.isWinner = true
        eventPlayer.winnerTime = evalOnce(getTotalTimeElapsed()) - eventPlayer.joinTime
        if any([eventPlayer.dmgReduc, eventPlayer.invincible, eventPlayer.isPortalEnabled, eventPlayer.isAirWalkEnabled]):
            goto lbl_1
        bigMessage(
            getPlayers(Team.1),
            STR_MSG_WIN_ANNOUNCE.format(
                eventPlayer,
                # 统计部分
                STR_MSG_WIN_STATS.format(eventPlayer.runDeathCount, eventPlayer.skipCount),
                # 时间部分
                "{0}{1}{2}".format(
                    # 小时部分
                    STR_TIME_UNIT_HOUR.format(floor(eventPlayer.winnerTime / 3600)) if (eventPlayer.winnerTime != null and eventPlayer.winnerTime >= 3600) else "",

                    # 分钟部分
                    STR_TIME_UNIT_MIN.format(floor((eventPlayer.winnerTime % 3600) / 60)) if (eventPlayer.winnerTime != null and eventPlayer.winnerTime >= 60) else "",

                    # 秒部分
                    STR_TIME_UNIT_SEC.format(floor(eventPlayer.winnerTime % 60)) if (eventPlayer.winnerTime != null) else STR_TIME_UNIT_ZERO_SEC
                )
            )
        )
        lbl_1:
        if hashTag == true:
            smallMessage(eventPlayer, STR_MSG_WIN_HINT.format(iconString(Icon.CHECKMARK)))
        savePlayerData()


rule "Charge winner ult":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isWinner != false
    @Condition eventPlayer.getUltCharge() < 100
    @Condition eventPlayer.isUsingUltimate() == false

    wait(15, Wait.ABORT_WHEN_FALSE)
    eventPlayer.setUltCharge(min(100, eventPlayer.getUltCharge() + 25))
    if ruleCondition:
        loop()
