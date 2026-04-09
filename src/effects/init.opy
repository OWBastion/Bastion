#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "initialize effects":
    hashTag = false if hashTag == false else true
    eventId = -1
    wait(random.uniform(1, 2))
    setDifficulty()
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # Player HUD (Top Left)
    # --------------------------------------------------------------------------------------------------------------------------------
    
    # 阵亡 / 英雄 / 下一个英雄
    hudText(localPlayer if localPlayer.heroNumber + 1 < len(heroList) and localPlayer.getHero() == heroList[localPlayer.heroNumber] else null, "{0}: {1}".format(STR_HUD_DEATHS, STR_HUD_DEATHS_VAL.format(localPlayer.progressionDeathCount, maxDeath if difficulty != 5 else "∞")), "", null, HudPosition.LEFT, 2, Color.WHITE, null, null, HudReeval.VISIBILITY_AND_STRING)
    hudText(localPlayer, "{0}: {1}".format(STR_HUD_HEROES, STR_HUD_HEROES_VAL.format(heroList.index(localPlayer.getHero()) + 1, len(heroList))), "", null, HudPosition.LEFT, 3, Color.WHITE, null, null, HudReeval.VISIBILITY_AND_STRING)
    hudText([] if localPlayer.isWinner or localPlayer.getHero() != heroList[localPlayer.heroNumber] else localPlayer, heroIcon(heroList[localPlayer.heroNumber + 1]) if localPlayer.heroNumber + 1 < len(heroList) else iconString(Icon.FLAG), STR_HUD_NEXT_HERO, heroList[localPlayer.heroNumber + 1] if localPlayer.heroNumber + 1 < len(heroList) else STR_HUD_ESCAPED, HudPosition.LEFT, 4, rgb(36, 205, 244), Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)
    hudText([] if localPlayer.isWinner or localPlayer.getHero() == heroList[localPlayer.heroNumber] else localPlayer, iconString(Icon.NO), STR_HUD_NEXT_HERO, STR_HUD_UNLOCKED.format(heroIcon(heroList[localPlayer.heroNumber])), HudPosition.LEFT, 4, rgb(235, 45, 79), rgb(235, 45, 79), rgb(235, 45, 79), HudReeval.VISIBILITY_AND_STRING)
    hudText(localPlayer if localPlayer.isWinner else null, iconString(Icon.CHECKMARK), STR_HUD_NEXT_HERO, STR_HUD_CHALLENGE_COMPLETE, HudPosition.LEFT, 4, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)
    
    # 成就禁用
    hudSubheader(null if hashTag else localPlayer, STR_HUD_ACHIEVEMENT_DISABLED.format(iconString(Icon.WARNING)), HudPosition.LEFT, 5, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # New Stats Panel (4.0)
    # --------------------------------------------------------------------------------------------------------------------------------
    # 边框 Top
    hudSubheader(localPlayer, STR_HUD_PANEL_TOP, HudPosition.LEFT, 6, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
        # 统计内容 (合并)
    hudSubheader(localPlayer, STR_HUD_STATS_PANEL.format(
        # 1. 阵亡/跳过
        STR_HUD_STATS_DEATH_SKIP.format(localPlayer.runDeathCount, localPlayer.skipCount),

        STR_HUD_STATS_EVENT.format(localPlayer.eventCount[0], localPlayer.eventCount[1], localPlayer.eventCount[0] + localPlayer.eventCount[1] + localPlayer.eventCount[2]) if dlcVishkarEvent else "",
        
        # 2. 玩家属性
        STR_HUD_ATTR_PANEL.format(
            round(localPlayer.heart_steel),
            localPlayer.mod_speed_perma,
            negToPos(localPlayer.mod_dmg_perma),
            localPlayer.mod_heal_perma + localPlayer.mod_heal_event
        ) if dlcVishkarEvent else "",

        # 3. 总耗时 (仅在通关后显示)
        STR_HUD_TOTAL_TIME.format("{0}{1}{2}".format(
            STR_TIME_UNIT_HOUR.format(floor(localPlayer.winnerTime / 3600)) if localPlayer.winnerTime != null and localPlayer.winnerTime >= 3600 else "", 
            STR_TIME_UNIT_MIN.format(floor(localPlayer.winnerTime % 3600 / 60)) if localPlayer.winnerTime != null and localPlayer.winnerTime >= 60 else "", 
            STR_TIME_UNIT_SEC.format(floor(localPlayer.winnerTime % 60)) if localPlayer.winnerTime != null else STR_TIME_UNIT_ZERO_SEC
        )) if localPlayer.isWinner else ""

    ), HudPosition.LEFT, 7, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    
    # 成就挑战
    hudSubheader(
    localPlayer if (hashTag == true and len(localPlayer.earnedAchievements) > 0 and len(allTitle) > 43) else null,
        "\r\n{0}".format(
            "{0}{1}{2}".format(
                # 第1行
                "{0} {1}".format(
                    allTitle[localPlayer.earnedAchievements[0]][0],
                    iconString(Icon.CHECKMARK)
                ),

                # 第2行
                ("\r\n{0} {1}".format(
                    allTitle[localPlayer.earnedAchievements[1]][0],
                    iconString(Icon.CHECKMARK)
                ) if len(localPlayer.earnedAchievements) > 1 else ""),

                # 第3~8行：用嵌套拼接来突破参数限制
                (
                    "\r\n{0} {1}{2}".format(
                        allTitle[localPlayer.earnedAchievements[2]][0],
                        iconString(Icon.CHECKMARK),

                        "{0}{1}".format(
                            # 第4行
                            ("\r\n{0} {1}".format(
                                allTitle[localPlayer.earnedAchievements[3]][0],
                                iconString(Icon.CHECKMARK)
                            ) if len(localPlayer.earnedAchievements) > 3 else ""),

                            "{0}{1}".format(
                                # 第5行
                                ("\r\n{0} {1}".format(
                                    allTitle[localPlayer.earnedAchievements[4]][0],
                                    iconString(Icon.CHECKMARK)
                                ) if len(localPlayer.earnedAchievements) > 4 else ""),

                                "{0}{1}".format(
                                    # 第6行
                                    ("\r\n{0} {1}".format(
                                        allTitle[localPlayer.earnedAchievements[5]][0],
                                        iconString(Icon.CHECKMARK)
                                    ) if len(localPlayer.earnedAchievements) > 5 else ""),

                                    "{0}{1}".format(
                                        # 第7行
                                        ("\r\n{0} {1}".format(
                                            allTitle[localPlayer.earnedAchievements[6]][0],
                                            iconString(Icon.CHECKMARK)
                                        ) if len(localPlayer.earnedAchievements) > 6 else ""),

                                        # 第8行
                                        ("\r\n{0} {1}".format(
                                            allTitle[localPlayer.earnedAchievements[7]][0],
                                            iconString(Icon.CHECKMARK)
                                        ) if len(localPlayer.earnedAchievements) > 7 else "")
                                    )
                                )
                            )
                        )
                    ) if len(localPlayer.earnedAchievements) > 2 else ""
                )
            )
        ),
        HudPosition.LEFT,
        100,
        rgb(heroColor[5].x, heroColor[5].y, heroColor[5].z),
        HudReeval.VISIBILITY_AND_STRING
    )
    
    # 边框 Bottom
    hudSubheader(localPlayer, STR_HUD_PANEL_BOTTOM, HudPosition.LEFT, 8, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # Random Events 4.0 HUD
    # --------------------------------------------------------------------------------------------------------------------------------
    if evalOnce(dlcVishkarEvent):
        # 事件版本子标题
        hudSubheader(getAllPlayers(), STR_HUD_RANDOM_EVENTS_VERSION, HudPosition.RIGHT, -5, difficultyText[1], HudReeval.VISIBILITY_STRING_AND_COLOR)
        
        # 个人事件详情 (改用 hudText)
        hudText(
            null if localPlayer.eventId == -1 else localPlayer, 
            "{0}".format(abilityIconString(Hero.SOMBRA, Button.ULTIMATE) if localPlayer.eventType == 1 else abilityIconString(Hero.ZENYATTA, Button.ABILITY_1)), 
            STR_HUD_EVENT_DETAIL.format(
                localPlayer.eventName, 
                STR_TIME_UNIT_SEC.format(localPlayer.eventDurationHud) if localPlayer.eventDuration > 0 else STR_MSG_DURATION_INSTANT, 
                localPlayer.eventDesc
            ), 
            null, HudPosition.LEFT, 70, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT
        )
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # Misc Info
    # --------------------------------------------------------------------------------------------------------------------------------
    # 总耗时
    # hudSubheader(localPlayer if localPlayer.isWinner else null, STR_HUD_TOTAL_TIME.format("{0}{1}{2}".format(STR_TIME_UNIT_HOUR.format(floor(localPlayer.winnerTime / 3600)) if localPlayer.winnerTime != null and localPlayer.winnerTime >= 3600 else "", STR_TIME_UNIT_MIN.format(floor(localPlayer.winnerTime % 3600 / 60)) if localPlayer.winnerTime != null and localPlayer.winnerTime >= 60 else "", STR_TIME_UNIT_SEC.format(floor(localPlayer.winnerTime % 60)) if localPlayer.winnerTime != null else STR_TIME_UNIT_ZERO_SEC)), HudPosition.LEFT, 7, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    # 跳过提示
    hudSubheader(localPlayer if difficulty != 5 and localPlayer.progressionDeathCount == maxDeath else null, STR_HUD_SKIP_HINT.format(inputBindingString(Button.ULTIMATE)), HudPosition.LEFT, 5, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # Goal Effects
    # --------------------------------------------------------------------------------------------------------------------------------
    wait(0.5)
    createEffect(getPlayers(Team.1), Effect.RING, Color.TEAM_1, endPosition, 4, EffectReeval.VISIBILITY)
    createEffect(getPlayers(Team.1), Effect.LIGHT_SHAFT, Color.TEAM_1, endPosition, 4, EffectReeval.VISIBILITY)
    createIcon(getPlayers(Team.1) if controlJumpPosition == null else [player for player in getPlayers(Team.1) if player.controlJumpIndex == evalOnce(len(controlRespawnPosition)) - 1], endPosition + vect(0, 5, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.BLUE)
    if controlJumpPosition != null:
        createEffect(getPlayers(Team.1), Effect.RING, Color.YELLOW, controlJumpPosition[0], 4, EffectReeval.VISIBILITY)
        createEffect(getPlayers(Team.1), Effect.LIGHT_SHAFT, Color.YELLOW, controlJumpPosition[0], 4, EffectReeval.VISIBILITY)
        createIcon([player for player in getPlayers(Team.1) if player.controlJumpIndex == 0], controlJumpPosition[0] + vect(0, 5, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.YELLOW)
        if controlJumpPosition[1] == null:
            goto lbl_0
        createEffect(getPlayers(Team.1), Effect.RING, Color.GREEN, controlJumpPosition[1], 4, EffectReeval.VISIBILITY)
        createEffect(getPlayers(Team.1), Effect.LIGHT_SHAFT, Color.GREEN, controlJumpPosition[1], 4, EffectReeval.VISIBILITY)
        createIcon([player for player in getPlayers(Team.1) if player.controlJumpIndex == 1], controlJumpPosition[1] + vect(0, 5, 0), Icon.FLAG, IconReeval.VISIBILITY_AND_POSITION, Color.GREEN)
        lbl_0:
        
    # --------------------------------------------------------------------------------------------------------------------------------
    # Mode Info (Top/Right HUD)
    # --------------------------------------------------------------------------------------------------------------------------------
    wait(0.5)
    if controlJumpPosition != null and portalPosition == null:
        hudSubtext(getAllPlayers(), STR_HUD_WELCOME_MULTI.format(maxDeath) if difficulty != 5 else STR_HUD_WELCOME_MULTI_HARD, HudPosition.TOP, 0, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)
    else:
        hudSubtext(getAllPlayers(), STR_HUD_WELCOME_NORMAL.format(maxDeath) if difficulty != 5 else STR_HUD_WELCOME_NORMAL_HARD, HudPosition.TOP, 0, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)
    
    # 欢迎信息
    hudSubheader(getAllPlayers(), "{0} | {1}".format(STR_MODE_CODE, STR_HUD_FOOTER_INFO), HudPosition.TOP, 1, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)
    
    # 难度显示
    hudSubtext(getAllPlayers(), "{0}：{1}".format(getCurrentMap() if __currentMapText___ == null else __currentMapText___, difficultyText[0]), HudPosition.RIGHT, -6, difficultyText[1], HudReeval.VISIBILITY_STRING_AND_COLOR)
    
    # 自动重开倒计时
    hudSubheader(getAllPlayers(), STR_HUD_AUTO_RESTART.format("{0}{1}{2}".format(STR_TIME_UNIT_HOUR.format(floor((rebootTime - getTotalTimeElapsed()) / 3600)) if rebootTime - getTotalTimeElapsed() > 3599 else "", STR_TIME_UNIT_MIN.format(floor(((rebootTime - getTotalTimeElapsed()) % 3600) / 60)) if rebootTime - getTotalTimeElapsed() > 59 else "", STR_TIME_UNIT_SEC.format(floor((rebootTime - getTotalTimeElapsed()) % 60)))), HudPosition.RIGHT, -4, Color.YELLOW if rebootTime - getTotalTimeElapsed() <= 600 else Color.GRAY, HudReeval.VISIBILITY_STRING_AND_COLOR)
    
    # 开发者面板 (Dev Player)
    hudSubheader(devPlayer, STR_HUD_SERVER_UPTIME.format("{0}{1}{2}".format(STR_TIME_UNIT_HOUR.format(floor(getTotalTimeElapsed() / 3600)) if getTotalTimeElapsed() >= 3600 else "", STR_TIME_UNIT_MIN.format(floor(getTotalTimeElapsed() % 3600 / 60)) if getTotalTimeElapsed() >= 60 else "", STR_TIME_UNIT_SEC.format(floor(getTotalTimeElapsed() % 60)))), HudPosition.RIGHT, -4, Color.GRAY, HudReeval.VISIBILITY_AND_STRING)
    hudSubheader(devPlayer, STR_HUD_SERVER_LOAD.format(getAverageServerLoad()), HudPosition.RIGHT, -2, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    # 版本号
    hudSubheader(getAllPlayers(), f"{STR_HUD_VERSION} {VERSION}", HudPosition.RIGHT, -3, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # World Effects
    # --------------------------------------------------------------------------------------------------------------------------------
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.AQUA, creditsPosition, random.uniform(1, 2), EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.SKY_BLUE, creditsPosition, random.uniform(1, 2), EffectReeval.VISIBILITY)
    createEffect(getAllPlayers(), Effect.BAD_AURA, Color.WHITE, creditsPosition, random.uniform(1, 2), EffectReeval.VISIBILITY)
    wait(0.5)
    
    # 3rd person camera
    createEffect(localPlayer, Effect.RING, Color.PURPLE, thirdPersonPosition, 1.2, EffectReeval.VISIBILITY)
    createInWorldText(localPlayer, STR_WORLD_THIRD_PERSON.format(inputBindingString(Button.JUMP), iconString(Icon.ARROW_DOWN)), thirdPersonPosition + Vector.UP * 1.3, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    
    # reset progress ring
    wait(0.5)
    createEffect(localPlayer if localPlayer.heroNumber > 0 or localPlayer.runDeathCount > 0 else null, Effect.RING, Color.RED, resetPosition, 1.2, EffectReeval.VISIBILITY)
    createInWorldText(localPlayer if localPlayer.heroNumber > 0 or localPlayer.runDeathCount > 0 else null, STR_WORLD_RESET_PROGRESS.format(iconString(Icon.ARROW_DOWN)), resetPosition + Vector.UP * 1.3, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)
    
    # springboard
    if springBoardPosition != null:
        createEffect(localPlayer, Effect.RING, Color.GREEN, springBoardPosition, 1.2, EffectReeval.VISIBILITY)
        createInWorldText(localPlayer, STR_WORLD_SPRINGBOARD.format(inputBindingString(Button.JUMP), iconString(Icon.ARROW_DOWN)), springBoardPosition + Vector.UP * 1.3, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING)



rule "3rd person":
    @Event eachPlayer
    @Condition distance(eventPlayer * vect(1, 0, 1), thirdPersonPosition * vect(1, 0, 1)) <= 1.2
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(getAverageServerLoad() / 100 * 0.032)
    setThirdPerson()


rule "springboard":
    @Event eachPlayer
    @Condition springBoardPosition != null
    @Condition distance(eventPlayer * vect(1, 0, 1), springBoardPosition * vect(1, 0, 1)) <= 1.2
    @Condition eventPlayer.getPosition().y >= springBoardPosition.y
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(getAverageServerLoad() / 100 * 0.032, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.applyImpulse(Vector.UP, 14, Relativity.TO_PLAYER)
    wait(0.032)
    eventPlayer.applyImpulse(worldVector(Vector.FORWARD, eventPlayer, Transform.ROTATION), 3.5, Relativity.TO_WORLD)
    wait(5)


rule "portalPosition":
    @Event eachPlayer
    @Condition portalPosition != null
    @Condition distance(eventPlayer * vect(1, 0, 1), portalPosition[0] * vect(1, 0, 1)) <= 1.2
    @Condition eventPlayer.getPosition().y >= portalPosition[0].y
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.isAlive() == true
    
    wait(getAverageServerLoad() / 100 * 0.032, Wait.ABORT_WHEN_FALSE)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, eventPlayer, 200)
    eventPlayer.teleport(nearestWalkablePosition(portalPosition.last()))
    wait(5)
