#!mainFile "../main.opy"

#Only remove the following directive if the gamemode does not use tricks such as A+0, A*0, "am" == "**", etc which would otherwise be optimized out.
#!optimizeStrict


rule "initialize effects":
    hashTag = false if hashTag == false else true
    wait(random.uniform(1, 2))
    setDifficulty()
    
    # --------------------------------------------------------------------------------------------------------------------------------
    # Player HUD (Left)
    # --------------------------------------------------------------------------------------------------------------------------------
    # 下一个英雄
    hudText(null if localPlayer.isWinner or localPlayer.getHero() != heroList[localPlayer.heroNumber] or localPlayer.settlementCardEnd != null else localPlayer, " ", STR_HUD_NEXT_HERO, "{0} {1}".format(heroIcon(heroList[localPlayer.heroNumber + 1]) if localPlayer.heroNumber + 1 < len(heroList) else iconString(Icon.FLAG), heroList[localPlayer.heroNumber + 1] if localPlayer.heroNumber + 1 < len(heroList) else STR_HUD_ESCAPED), HudPosition.LEFT, 2, rgb(36, 205, 244), Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)

    hudText(null if localPlayer.isWinner or localPlayer.getHero() == heroList[localPlayer.heroNumber] or localPlayer.settlementCardEnd != null else localPlayer, iconString(Icon.NO), STR_HUD_NEXT_HERO, STR_HUD_UNLOCKED.format(heroIcon(heroList[localPlayer.heroNumber])), HudPosition.LEFT, 2, rgb(235, 45, 79), rgb(235, 45, 79), rgb(235, 45, 79), HudReeval.VISIBILITY_AND_STRING)

    hudText(localPlayer if localPlayer.isWinner and localPlayer.settlementCardEnd == null else null, iconString(Icon.CHECKMARK), STR_HUD_NEXT_HERO, STR_HUD_CHALLENGE_COMPLETE, HudPosition.LEFT, 2, Color.GREEN, Color.GREEN, Color.GREEN, HudReeval.VISIBILITY_AND_STRING)

    # 英雄 x/y · 阵亡 x/y
    hudSubheader(localPlayer if localPlayer.heroNumber + 1 < len(heroList) and localPlayer.getHero() == heroList[localPlayer.heroNumber] and localPlayer.settlementCardEnd == null else null, STR_HUD_STATS_HERO_DEATH.format(heroList.index(localPlayer.getHero()) + 1, len(heroList), localPlayer.progressionDeathCount, maxDeath if difficulty != 5 else "∞"), HudPosition.LEFT, 3, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 增益 · 减益 · 总计
    hudSubheader(localPlayer if localPlayer.settlementCardEnd == null else null, STR_HUD_STATS_EVENT.format(localPlayer.eventCount[EventType.BUFF], localPlayer.eventCount[EventType.DEBUFF], localPlayer.eventCount[EventType.BUFF] + localPlayer.eventCount[EventType.DEBUFF] + localPlayer.eventCount[EventType.MECH]), HudPosition.LEFT, 4, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 属性行
    hudSubheader(localPlayer if localPlayer.settlementCardEnd == null else null, STR_HUD_ATTR_PANEL.format(
        round(localPlayer.heart_steel[HeartSteelData.STACKS]),
        localPlayer.mod_speed_perma,
        negToPos(localPlayer.mod_dmg_perma),
        localPlayer.mod_heal_perma + localPlayer.mod_heal_event
    ), HudPosition.LEFT, 5, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 跳过提示
    hudSubheader(localPlayer if difficulty != 5 and localPlayer.progressionDeathCount == maxDeath and localPlayer.settlementCardEnd == null else null, STR_HUD_SKIP_HINT.format(inputBindingString(Button.ULTIMATE)), HudPosition.LEFT, 6, Color.BLUE, HudReeval.VISIBILITY_AND_STRING)

    # --------------------------------------------------------------------------------------------------------------------------------
    # 个人事件详情 (顶部中央底部): 排在 assignPlayerEvent 的 HUD_PAD_BOTTOM 状态行 (TOP 20) 之后
    # --------------------------------------------------------------------------------------------------------------------------------
    hudText(
        null if localPlayer.eventId == -1 or localPlayer.settlementCardEnd != null else localPlayer,
        null,
        null,
        STR_HUD_EVENT_TITLE.format(
            abilityIconString(Hero.SOMBRA, Button.ULTIMATE) if localPlayer.eventType == EventType.DEBUFF else abilityIconString(Hero.ZENYATTA, Button.ABILITY_1),
            localPlayer.eventName,
            STR_TIME_UNIT_SEC.format(localPlayer.eventDurationHud) if localPlayer.eventDuration > 0 else STR_MSG_DURATION_INSTANT
        ),
        HudPosition.TOP, 3, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS
    )
    hudText(
        null if localPlayer.eventId == -1 or localPlayer.settlementCardEnd != null else localPlayer,
        null,
        null,
        localPlayer.eventDesc,
        HudPosition.TOP, 4, Color.WHITE, Color.WHITE, rgb(255, 255, 255, 255), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS
    )

    # --------------------------------------------------------------------------------------------------------------------------------
    # 通关结算卡 (顶部中央, 仅本人, settlementCardEnd 期间显示)
    # --------------------------------------------------------------------------------------------------------------------------------
    hudHeader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_TITLE.format(hhmmss(localPlayer.winnerTime)),
        HudPosition.TOP, 6, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_PLAYER.format(localPlayer, masteryRunCode),
        HudPosition.TOP, 7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_MAP.format(getCurrentMap() if __currentMapText___ == null else __currentMapText___, difficultyText[0], VERSION),
        HudPosition.TOP, 8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_STATS.format(localPlayer.runDeathCount, localPlayer.skipCount),
        HudPosition.TOP, 9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_TITLES.format(
            STR_HUD_ACHIEVEMENT_DISABLED.format(iconString(Icon.WARNING)) if hashTag == false else ("{0}{1}{2}".format(
                titleText[localPlayer.earnedAchievements[0]],
                " · {0}".format(titleText[localPlayer.earnedAchievements[1]]) if len(localPlayer.earnedAchievements) > 1 else "",
                "{0}{1}".format(
                    " · {0}".format(titleText[localPlayer.earnedAchievements[2]]) if len(localPlayer.earnedAchievements) > 2 else "",
                    "{0}{1}".format(
                        " · {0}".format(titleText[localPlayer.earnedAchievements[3]]) if len(localPlayer.earnedAchievements) > 3 else "",
                        "{0}{1}".format(
                            " · {0}".format(titleText[localPlayer.earnedAchievements[4]]) if len(localPlayer.earnedAchievements) > 4 else "",
                            "{0}{1}".format(
                                " · {0}".format(titleText[localPlayer.earnedAchievements[5]]) if len(localPlayer.earnedAchievements) > 5 else "",
                                "{0}{1}".format(
                                    " · {0}".format(titleText[localPlayer.earnedAchievements[6]]) if len(localPlayer.earnedAchievements) > 6 else "",
                                    " · {0}".format(titleText[localPlayer.earnedAchievements[7]]) if len(localPlayer.earnedAchievements) > 7 else ""
                                )
                            )
                        )
                    )
                )
            ) if localPlayer.earnedAchievements != null and len(localPlayer.earnedAchievements) > 0 else "—")
        ),
        HudPosition.TOP, 10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )

    hudSubheader(
        localPlayer if localPlayer.settlementCardEnd != null else null,
        STR_HUD_CARD_COUNTDOWN.format(ceil(localPlayer.settlementCardEnd - getTotalTimeElapsed()) if localPlayer.settlementCardEnd != null else 0),
        HudPosition.TOP, 11, rgb(160, 169, 186), HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER
    )
    
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
        hudSubtext([player for player in getAllPlayers() if player.settlementCardEnd == null], STR_HUD_WELCOME_MULTI.format(maxDeath) if difficulty != 5 else STR_HUD_WELCOME_MULTI_HARD, HudPosition.TOP, 0, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)
    else:
        hudSubtext([player for player in getAllPlayers() if player.settlementCardEnd == null], STR_HUD_WELCOME_NORMAL.format(maxDeath) if difficulty != 5 else STR_HUD_WELCOME_NORMAL_HARD, HudPosition.TOP, 0, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)

    # 欢迎信息
    hudSubheader(getAllPlayers(), "{0} | {1}".format(STR_MODE_CODE, STR_HUD_FOOTER_INFO), HudPosition.TOP, 1, rgb(255, 255, 255, 125), HudReeval.VISIBILITY_AND_STRING)

    # 地图 · 难度
    hudSubtext([player for player in getAllPlayers() if player.settlementCardEnd == null], "{0} · {1}".format(getCurrentMap() if __currentMapText___ == null else __currentMapText___, difficultyText[0]), HudPosition.RIGHT, -6, difficultyText[1], HudReeval.VISIBILITY_STRING_AND_COLOR)

    # 模式版本
    hudSubheader([player for player in getAllPlayers() if player.settlementCardEnd == null], "{0} {1}".format(STR_HUD_VERSION, VERSION), HudPosition.RIGHT, -5, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

    # 运行时信息
    hudSubheader([player for player in getAllPlayers() if player.settlementCardEnd == null], "{0}\n{1}".format(
        STR_HUD_AUTO_RESTART.format(hhmmss(max(0, rebootTime - getTotalTimeElapsed()))),
        STR_HUD_SERVER_UPTIME.format(hhmmss(getTotalTimeElapsed()))
    ), HudPosition.RIGHT, -4, Color.YELLOW if rebootTime - getTotalTimeElapsed() <= 600 else Color.GRAY, HudReeval.VISIBILITY_STRING_AND_COLOR)
    hudSubheader([player for player in getAllPlayers() if player.settlementCardEnd == null], STR_HUD_SERVER_LOAD.format(getAverageServerLoad()), HudPosition.RIGHT, -2, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    
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
