#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict
#!rulePrefix "Title"

rule "Initialize title colors":
    rgbList = [vect(255, 0, 0), vect(255, 165, 0), vect(255, 255, 0), vect(0, 255, 0), vect(0, 0, 255), vect(75, 0, 130), vect(238, 130, 238)]

# 称号文本按栏位绑定：Team.1 的 8 个栏位各一条，单局恒定 8 次创建，
# 与具体玩家解耦——任意数量玩家进出栏位只改变 reeval 结果，不产生新的创建/销毁。
# 栏位占用者的称号数据由 playerJoined 初始化按玩家 key 查询写入
# playerTitleAndColor / rgb_vect / isDev 等 playervar，文本随占用者自动更新。
rule "Create in-world titles":
    @Event global
    @Condition titleSlotTextsCreated == false
    @Condition len(getPlayers(Team.1)) > 0

    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(0), player)]
            if TEAM1_SLOT_PLAYER(0) != null and TEAM1_SLOT_PLAYER(0).hasSpawned() and TEAM1_SLOT_PLAYER(0).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(0) != null and TEAM1_SLOT_PLAYER(0).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(0).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(0) != null and TEAM1_SLOT_PLAYER(0).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(0),
        1 if TEAM1_SLOT_PLAYER(0) != null and TEAM1_SLOT_PLAYER(0).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(0).rgb_vect.x, TEAM1_SLOT_PLAYER(0).rgb_vect.y, TEAM1_SLOT_PLAYER(0).rgb_vect.z) if TEAM1_SLOT_PLAYER(0) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(1), player)]
            if TEAM1_SLOT_PLAYER(1) != null and TEAM1_SLOT_PLAYER(1).hasSpawned() and TEAM1_SLOT_PLAYER(1).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(1) != null and TEAM1_SLOT_PLAYER(1).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(1).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(1) != null and TEAM1_SLOT_PLAYER(1).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(1),
        1 if TEAM1_SLOT_PLAYER(1) != null and TEAM1_SLOT_PLAYER(1).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(1).rgb_vect.x, TEAM1_SLOT_PLAYER(1).rgb_vect.y, TEAM1_SLOT_PLAYER(1).rgb_vect.z) if TEAM1_SLOT_PLAYER(1) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(2), player)]
            if TEAM1_SLOT_PLAYER(2) != null and TEAM1_SLOT_PLAYER(2).hasSpawned() and TEAM1_SLOT_PLAYER(2).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(2) != null and TEAM1_SLOT_PLAYER(2).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(2).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(2) != null and TEAM1_SLOT_PLAYER(2).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(2),
        1 if TEAM1_SLOT_PLAYER(2) != null and TEAM1_SLOT_PLAYER(2).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(2).rgb_vect.x, TEAM1_SLOT_PLAYER(2).rgb_vect.y, TEAM1_SLOT_PLAYER(2).rgb_vect.z) if TEAM1_SLOT_PLAYER(2) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(3), player)]
            if TEAM1_SLOT_PLAYER(3) != null and TEAM1_SLOT_PLAYER(3).hasSpawned() and TEAM1_SLOT_PLAYER(3).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(3) != null and TEAM1_SLOT_PLAYER(3).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(3).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(3) != null and TEAM1_SLOT_PLAYER(3).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(3),
        1 if TEAM1_SLOT_PLAYER(3) != null and TEAM1_SLOT_PLAYER(3).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(3).rgb_vect.x, TEAM1_SLOT_PLAYER(3).rgb_vect.y, TEAM1_SLOT_PLAYER(3).rgb_vect.z) if TEAM1_SLOT_PLAYER(3) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(4), player)]
            if TEAM1_SLOT_PLAYER(4) != null and TEAM1_SLOT_PLAYER(4).hasSpawned() and TEAM1_SLOT_PLAYER(4).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(4) != null and TEAM1_SLOT_PLAYER(4).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(4).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(4) != null and TEAM1_SLOT_PLAYER(4).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(4),
        1 if TEAM1_SLOT_PLAYER(4) != null and TEAM1_SLOT_PLAYER(4).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(4).rgb_vect.x, TEAM1_SLOT_PLAYER(4).rgb_vect.y, TEAM1_SLOT_PLAYER(4).rgb_vect.z) if TEAM1_SLOT_PLAYER(4) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(5), player)]
            if TEAM1_SLOT_PLAYER(5) != null and TEAM1_SLOT_PLAYER(5).hasSpawned() and TEAM1_SLOT_PLAYER(5).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(5) != null and TEAM1_SLOT_PLAYER(5).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(5).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(5) != null and TEAM1_SLOT_PLAYER(5).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(5),
        1 if TEAM1_SLOT_PLAYER(5) != null and TEAM1_SLOT_PLAYER(5).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(5).rgb_vect.x, TEAM1_SLOT_PLAYER(5).rgb_vect.y, TEAM1_SLOT_PLAYER(5).rgb_vect.z) if TEAM1_SLOT_PLAYER(5) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(6), player)]
            if TEAM1_SLOT_PLAYER(6) != null and TEAM1_SLOT_PLAYER(6).hasSpawned() and TEAM1_SLOT_PLAYER(6).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(6) != null and TEAM1_SLOT_PLAYER(6).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(6).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(6) != null and TEAM1_SLOT_PLAYER(6).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(6),
        1 if TEAM1_SLOT_PLAYER(6) != null and TEAM1_SLOT_PLAYER(6).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(6).rgb_vect.x, TEAM1_SLOT_PLAYER(6).rgb_vect.y, TEAM1_SLOT_PLAYER(6).rgb_vect.z) if TEAM1_SLOT_PLAYER(6) != null else rgb(0, 0, 0)
    )
    createInWorldText(
        [player for player in getAllPlayers() if isInLoS(TEAM1_SLOT_PLAYER(7), player)]
            if TEAM1_SLOT_PLAYER(7) != null and TEAM1_SLOT_PLAYER(7).hasSpawned() and TEAM1_SLOT_PLAYER(7).playerTitleAndColor != null
            else [],
        "{0} {1}".format(
            abilityIconString(Hero.TORBJORN, Button.ABILITY_2) if TEAM1_SLOT_PLAYER(7) != null and TEAM1_SLOT_PLAYER(7).isDev else "",
            titleText[TEAM1_SLOT_PLAYER(7).playerTitleAndColor]
        ) if TEAM1_SLOT_PLAYER(7) != null and TEAM1_SLOT_PLAYER(7).playerTitleAndColor != null else "",
        TEAM1_SLOT_PLAYER(7),
        1 if TEAM1_SLOT_PLAYER(7) != null and TEAM1_SLOT_PLAYER(7).isDev else 0.8,
        Clip.NONE,
        WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR,
        rgb(TEAM1_SLOT_PLAYER(7).rgb_vect.x, TEAM1_SLOT_PLAYER(7).rgb_vect.y, TEAM1_SLOT_PLAYER(7).rgb_vect.z) if TEAM1_SLOT_PLAYER(7) != null else rgb(0, 0, 0)
    )
    titleSlotTextsCreated = true


rule "Cycle dev rainbow":
    @Event eachPlayer
    @Condition eventPlayer.isDev == true
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition titleColor[eventPlayer.playerTitleAndColor] == null
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.info_pvar = (eventPlayer.info_pvar + 1) % len(rgbList)
    chaseOverTime(eventPlayer.rgb_vect, rgbList[eventPlayer.info_pvar], 2.5, ChaseTimeReeval.NONE)
    waitUntil(eventPlayer.rgb_vect == rgbList[eventPlayer.info_pvar], Math.INFINITY)
    if ruleCondition:
        loop()
    stopChasingVariable(eventPlayer.rgb_vect)
    eventPlayer.info_pvar = 0


rule "Cycle palette":
    @Event eachPlayer
    @Condition eventPlayer.playerTitleAndColor != null
    @Condition titleColor[eventPlayer.playerTitleAndColor] != null
    @Condition len(titleColor[eventPlayer.playerTitleAndColor]) > 1
    
    wait(0.016, Wait.ABORT_WHEN_FALSE)
    eventPlayer.info_pvar = (eventPlayer.info_pvar + 1) % len(titleColor[eventPlayer.playerTitleAndColor])
    chaseOverTime(
        eventPlayer.rgb_vect,
        titleColor[eventPlayer.playerTitleAndColor][eventPlayer.info_pvar],
        2.5,
        ChaseTimeReeval.NONE
    )
    waitUntil(
        eventPlayer.rgb_vect == titleColor[eventPlayer.playerTitleAndColor][eventPlayer.info_pvar]
        or not eventPlayer.rgb_activated,
        Math.INFINITY
    )
    if ruleCondition:
        loop()
    wait()
    stopChasingVariable(eventPlayer.rgb_vect)
    eventPlayer.info_pvar = 0
    eventPlayer.rgb_vect = titleColor[eventPlayer.playerTitleAndColor][0]
